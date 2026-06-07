// repositories/ApplicationRepository.js
// DESIGN PATTERN: Repository Pattern
const pool = require('../config/db');

class ApplicationRepository {
    async findByJobId(jobId) {
        const [rows] = await pool.query(`
            SELECT a.application_id, a.job_id, a.seeker_id, a.status, a.applied_at,
                   u.email AS seeker_email,
                   COALESCE(u.full_name, CONCAT('User ', u.user_id)) AS seeker_name,
                   j.title AS job_title, c.company_name
            FROM applications a
            JOIN users u ON a.seeker_id = u.user_id
            JOIN job_listings j ON a.job_id = j.job_id
            JOIN companies c ON j.company_id = c.company_id
            WHERE a.job_id = ?
            ORDER BY a.applied_at DESC
        `, [jobId]);
        return rows;
    }

    async findBySeekerId(seekerId) {
        const [rows] = await pool.query(`
            SELECT a.application_id, a.job_id, a.seeker_id, a.status, a.applied_at,
                   j.title AS job_title, j.description, j.job_type, j.is_remote,
                   c.company_name, c.company_id
            FROM applications a
            JOIN job_listings j ON a.job_id = j.job_id
            JOIN companies c ON j.company_id = c.company_id
            WHERE a.seeker_id = ?
            ORDER BY a.applied_at DESC
        `, [seekerId]);
        return rows;
    }

    async findDuplicate(jobId, seekerId) {
        const [rows] = await pool.query(
            'SELECT application_id FROM applications WHERE job_id = ? AND seeker_id = ?',
            [jobId, seekerId]
        );
        return rows[0] || null;
    }

    async create(jobId, seekerId) {
        const [result] = await pool.query(
            'INSERT INTO applications (job_id, seeker_id, status) VALUES (?, ?, ?)',
            [jobId, seekerId, 'pending']
        );
        return result.insertId;
    }

    async updateStatus(applicationId, status) {
        const [result] = await pool.query(
            'UPDATE applications SET status = ? WHERE application_id = ?',
            [status, applicationId]
        );
        return result.affectedRows > 0;
    }

    async countByEmployerId(employerId) {
        const [rows] = await pool.query(`
            SELECT COUNT(*) AS total FROM applications a
            JOIN job_listings j ON a.job_id = j.job_id
            WHERE j.employer_id = ?
        `, [employerId]);
        return rows[0].total;
    }

    async countInterviewsByEmployerId(employerId) {
        const [rows] = await pool.query(`
            SELECT COUNT(*) AS total FROM applications a
            JOIN job_listings j ON a.job_id = j.job_id
            WHERE j.employer_id = ? AND LOWER(a.status) IN ('interview_offered','interview_scheduled')
        `, [employerId]);
        return rows[0].total;
    }
}

module.exports = new ApplicationRepository();
