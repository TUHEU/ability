// controllers/communityController.js
// DESIGN PATTERN: Repository Pattern
const CommunityRepository = require('../repositories/CommunityRepository');

exports.getLearningResources = async (req, res) => {
    try { res.status(200).json(await CommunityRepository.getLearningResources()); }
    catch (err) { res.status(500).json({ message: 'Server error.' }); }
};

exports.getMentors = async (req, res) => {
    try { res.status(200).json(await CommunityRepository.getMentors()); }
    catch (err) { res.status(500).json({ message: 'Server error.' }); }
};

exports.getForumPosts = async (req, res) => {
    try { res.status(200).json(await CommunityRepository.getForumPosts()); }
    catch (err) { res.status(500).json({ message: 'Server error.' }); }
};

exports.requestMentorship = async (req, res) => {
    const { seeker_id, mentor_id, message } = req.body;
    if (!seeker_id || !mentor_id) return res.status(400).json({ message: 'seeker_id and mentor_id required.' });
    try {
        const requestId = await CommunityRepository.createMentorshipRequest(seeker_id, mentor_id, message);
        res.status(201).json({ message: 'Mentorship request sent!', requestId });
    } catch (err) { res.status(500).json({ message: 'Server error.' }); }
};
