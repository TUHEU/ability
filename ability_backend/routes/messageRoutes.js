// routes/messageRoutes.js
const express = require('express');
const router = express.Router();
const msg = require('../controllers/messagesController');
router.post('/', msg.sendMessage);
router.get('/conversation', msg.getConversation);
router.get('/conversations', msg.getConversations);
module.exports = router;
