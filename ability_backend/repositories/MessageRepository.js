// repositories/MessageRepository.js
// DESIGN PATTERN: Repository Pattern
const pool = require('../config/db');

class MessageRepository {
    async findConversation(userId, otherUserId, jobId = null) {
        let query = `
            SELECT m.message_id, m.sender_id, m.receiver_id, m.content, m.media_url, m.sent_at,
                   COALESCE(u1.full_name, u1.email) AS sender_name,
                   COALESCE(u2.full_name, u2.email) AS receiver_name
            FROM messages m
            JOIN users u1 ON m.sender_id = u1.user_id
            JOIN users u2 ON m.receiver_id = u2.user_id
            WHERE ((m.sender_id = ? AND m.receiver_id = ?) OR (m.sender_id = ? AND m.receiver_id = ?))
        `;
        const params = [userId, otherUserId, otherUserId, userId];
        if (jobId != null) { query += ' AND m.job_id = ?'; params.push(jobId); }
        query += ' ORDER BY m.sent_at ASC';
        const [rows] = await pool.query(query, params);
        return rows;
    }

    async findAllForUser(userId) {
        const [rows] = await pool.query(`
            SELECT m.message_id, m.sender_id, m.receiver_id, m.content, m.sent_at,
                   COALESCE(u1.full_name, u1.email) AS sender_name,
                   COALESCE(u2.full_name, u2.email) AS receiver_name
            FROM messages m
            JOIN users u1 ON m.sender_id = u1.user_id
            JOIN users u2 ON m.receiver_id = u2.user_id
            WHERE m.sender_id = ? OR m.receiver_id = ?
            ORDER BY m.sent_at DESC
        `, [userId, userId]);
        return rows;
    }

    async create(senderId, receiverId, jobId, content) {
        const [result] = await pool.query(
            'INSERT INTO messages (sender_id, receiver_id, job_id, content) VALUES (?, ?, ?, ?)',
            [senderId, receiverId, jobId || null, content]
        );
        const [rows] = await pool.query(`
            SELECT m.*, COALESCE(s.full_name, s.email) AS sender_name,
                   COALESCE(r.full_name, r.email) AS receiver_name
            FROM messages m
            JOIN users s ON m.sender_id = s.user_id
            JOIN users r ON m.receiver_id = r.user_id
            WHERE m.message_id = ?
        `, [result.insertId]);
        return rows[0];
    }
}

module.exports = new MessageRepository();
