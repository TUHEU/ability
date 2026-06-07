// controllers/messagesController.js
// DESIGN PATTERN: Repository Pattern
const MessageRepository = require('../repositories/MessageRepository');
const UserRepository = require('../repositories/UserRepository');

exports.getConversation = async (req, res) => {
    const { userId, otherUserId, jobId } = req.query;
    try {
        const rows = await MessageRepository.findConversation(userId, otherUserId, jobId);
        res.status(200).json(rows);
    } catch (err) {
        res.status(500).json({ message: 'Server error.' });
    }
};

exports.getConversations = async (req, res) => {
    const { userId } = req.query;
    try {
        const rows = await MessageRepository.findAllForUser(userId);
        const convos = {};
        rows.forEach(row => {
            const otherId   = row.sender_id == userId ? row.receiver_id : row.sender_id;
            const otherName = row.sender_id == userId ? row.receiver_name : row.sender_name;
            if (!convos[otherId]) {
                convos[otherId] = { other_user_id: otherId, other_user_name: otherName,
                                    last_message: row.content, last_message_time: row.sent_at, total_messages: 0 };
            }
            convos[otherId].total_messages++;
        });
        res.status(200).json(Object.values(convos));
    } catch (err) {
        res.status(500).json({ message: 'Server error.' });
    }
};

exports.sendMessage = async (req, res) => {
    const { sender_id, receiver_id, job_id, content } = req.body;
    try {
        if (!await UserRepository.findById(sender_id))
            return res.status(404).json({ message: 'Sender not found.' });
        if (!await UserRepository.findById(receiver_id))
            return res.status(404).json({ message: 'Receiver not found.' });

        const msg = await MessageRepository.create(sender_id, receiver_id, job_id, content);
        res.status(201).json(msg);
    } catch (err) {
        res.status(500).json({ message: 'Server error.' });
    }
};
