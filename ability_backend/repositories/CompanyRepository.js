// repositories/CompanyRepository.js
// DESIGN PATTERN: Repository Pattern
const pool = require('../config/db');

class CompanyRepository {
    async findByAdminUserId(userId) {
        const [rows] = await pool.query(
            'SELECT * FROM companies WHERE admin_user_id = ?', [userId]
        );
        return rows[0] || null;
    }

    async findById(companyId) {
        const [rows] = await pool.query(
            'SELECT * FROM companies WHERE company_id = ?', [companyId]
        );
        return rows[0] || null;
    }

    async findByEmployerEmail(email) {
        const [rows] = await pool.query(
            `SELECT c.company_id, c.admin_user_id
             FROM companies c
             JOIN users u ON c.admin_user_id = u.user_id
             WHERE u.email = ? LIMIT 1`,
            [email]
        );
        return rows[0] || null;
    }

    async create(connection, { adminUserId, companyName }) {
        const [result] = await connection.query(
            `INSERT INTO companies (admin_user_id, company_name, reality_score, inclusivity_tier)
             VALUES (?, ?, 1.00, 'None')`,
            [adminUserId, companyName]
        );
        return result.insertId;
    }
}

module.exports = new CompanyRepository();
