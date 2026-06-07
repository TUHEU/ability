// controllers/authController.js
// DESIGN PATTERN: Repository Pattern (data access via UserRepository / CompanyRepository)
//                 Factory Pattern   (token creation via TokenFactory)
const pool = require('../config/db');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const UserRepository = require('../repositories/UserRepository');
const CompanyRepository = require('../repositories/CompanyRepository');

// ── FACTORY PATTERN ─────────────────────────────────────────────────────────
// TokenFactory encapsulates the details of JWT creation.
// To change algorithm or claims, update only this one place.
class TokenFactory {
    static create(payload) {
        return jwt.sign(payload, process.env.JWT_SECRET, { expiresIn: '7d' });
    }
}

// ── REGISTER ─────────────────────────────────────────────────────────────────
exports.register = async (req, res) => {
    const { email, password, role, companyName } = req.body;

    if (!email || !password || !role) {
        return res.status(400).json({ message: 'Missing required fields.' });
    }

    const connection = await pool.getConnection();
    try {
        await connection.beginTransaction();

        if (await UserRepository.emailExists(email)) {
            await connection.rollback();
            return res.status(400).json({ message: 'Email already registered.' });
        }

        const salt = await bcrypt.genSalt(10);
        const passwordHash = await bcrypt.hash(password, salt);

        const newUserId = await UserRepository.create(connection, { email, passwordHash, role });

        if (role === 'employer') {
            const finalName = companyName || `Company ${newUserId}`;
            await CompanyRepository.create(connection, { adminUserId: newUserId, companyName: finalName });
        }

        await connection.commit();
        res.status(201).json({
            message: role === 'employer' ? 'Employer registered!' : 'User registered!',
            userId: newUserId
        });
    } catch (err) {
        await connection.rollback();
        console.error('Register error:', err);
        res.status(500).json({ message: 'Server error during registration.' });
    } finally {
        connection.release();
    }
};

// ── LOGIN ─────────────────────────────────────────────────────────────────────
exports.login = async (req, res) => {
    const { email, password } = req.body;
    try {
        const user = await UserRepository.findByEmail(email);
        if (!user) return res.status(404).json({ message: 'User not found.' });

        const isMatch = await bcrypt.compare(password, user.password_hash);
        if (!isMatch) return res.status(401).json({ message: 'Invalid credentials.' });

        // Fetch companyId so Flutter can save it and use it when posting jobs
        let companyId = null;
        if (user.role === 'employer') {
            const company = await CompanyRepository.findByAdminUserId(user.user_id);
            if (company) companyId = company.company_id;
        }

        // TokenFactory creates the JWT
        const token = TokenFactory.create({ userId: user.user_id, role: user.role });

        res.status(200).json({
            message: 'Login successful!',
            token,
            user: {
                id: user.user_id,
                name: user.full_name || email.split('@')[0],
                email: user.email,
                role: user.role,
                companyId  // ← Flutter saves this on login
            }
        });
    } catch (err) {
        console.error('Login error:', err);
        res.status(500).json({ message: 'Server error during login.' });
    }
};
