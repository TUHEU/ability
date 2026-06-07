// routes/communityRoutes.js
const express = require('express');
const router = express.Router();
const community = require('../controllers/communityController');
router.get('/learning', community.getLearningResources);
router.get('/mentors', community.getMentors);
router.get('/forum', community.getForumPosts);
router.post('/mentorship-request', community.requestMentorship);
module.exports = router;
