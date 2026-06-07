// repositories/JobRepository.js
// DESIGN PATTERN: Repository Pattern
const pool = require('../config/db');

class JobRepository {
    async findAll() {
        const [rows] = await pool.query(`
            SELECT j.job_id, j.company_id, j.employer_id, j.title, j.description,
                   j.job_type, j.is_remote, j.created_at,
                   j.accommodation_offerings AS accommodations, c.company_name
            FROM job_listings j
            JOIN companies c ON j.company_id = c.company_id
            ORDER BY j.created_at DESC
        `);
        return rows;
    }

    async findById(jobId) {
        const [rows] = await pool.query(
            'SELECT * FROM job_listings WHERE job_id = ?', [jobId]
        );
        return rows[0] || null;
    }

    async findByEmployerId(employerId) {
        const [rows] = await pool.query(`
            SELECT j.job_id, j.company_id, j.employer_id, j.title, j.description,
                   j.job_type, j.is_remote, j.created_at,
                   j.accommodation_offerings AS accommodations, c.company_name,
                   (SELECT COUNT(*) FROM applications WHERE job_id = j.job_id) AS applicantCount
            FROM job_listings j
            JOIN companies c ON j.company_id = c.company_id
            WHERE j.employer_id = ?
            ORDER BY j.created_at DESC
        `, [employerId]);
        return rows;
    }

    async create({ companyId, employerId, title, description, jobType, isRemote, accommodations }) {
        const [result] = await pool.query(
            `INSERT INTO job_listings (company_id, employer_id, title, description, job_type, is_remote, accommodation_offerings)
             VALUES (?, ?, ?, ?, ?, ?, ?)`,
            [companyId, employerId || null, title, description, jobType, isRemote, JSON.stringify(accommodations || [])]
        );
        return result.insertId;
    }

    async countByEmployerId(employerId) {
        const [rows] = await pool.query(
            'SELECT COUNT(*) AS total FROM job_listings WHERE employer_id = ?', [employerId]
        );
        return rows[0].total;
    }
}

module.exports = new JobRepository();
