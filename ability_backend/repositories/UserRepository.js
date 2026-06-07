// repositories/UserRepository.js
// DESIGN PATTERN: Repository Pattern
// Centralises all SQL for the users table. Controllers never touch raw SQL.
const pool = require('../config/db');

class UserRepository {
    async findByEmail(email) {
        const [rows] = await pool.query('SELECT * FROM users WHERE email = ?', [email]);
        return rows[0] || null;
    }

    async findById(id) {
        const [rows] = await pool.query('SELECT * FROM users WHERE user_id = ?', [id]);
        return rows[0] || null;
    }

    async create(connection, { email, passwordHash, role }) {
        const fullName = email.split('@')[0];
        const [result] = await connection.query(
            'INSERT INTO users (email, password_hash, role, full_name) VALUES (?, ?, ?, ?)',
            [email, passwordHash, role, fullName]
        );
        return result.insertId;
    }

    async emailExists(email) {
        const [rows] = await pool.query('SELECT user_id FROM users WHERE email = ?', [email]);
        return rows.length > 0;
    }
}

module.exports = new UserRepository();
