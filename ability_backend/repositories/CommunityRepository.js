// repositories/CommunityRepository.js
// DESIGN PATTERN: Repository Pattern
const pool = require('../config/db');

class CommunityRepository {
    async getLearningResources() {
        const [rows] = await pool.query(
            'SELECT resource_id AS id, title, description, icon_name, lessons_count FROM learning_resources ORDER BY created_at DESC'
        );
        return rows;
    }

    async getMentors() {
        const [rows] = await pool.query(
            'SELECT mentor_id AS id, name, role, expertise AS tag, experience AS exp FROM mentors WHERE available = TRUE'
        );
        return rows;
    }

    async getForumPosts() {
        const [rows] = await pool.query(
            'SELECT post_id AS id, title, category, upvotes, replies_count AS replies FROM forum_posts ORDER BY created_at DESC'
        );
        return rows;
    }

    async createMentorshipRequest(seekerId, mentorId, message) {
        const [result] = await pool.query(
            'INSERT INTO mentorship_requests (seeker_id, mentor_id, message) VALUES (?, ?, ?)',
            [seekerId, mentorId, message || '']
        );
        return result.insertId;
    }
}

module.exports = new CommunityRepository();
