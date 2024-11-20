const express = require('express');
const router = express.Router();
const chatController = require('../controllers/chatController');
const authMiddleware = require('../middleware/authMiddleware');

// Initiate a chat
router.post('/initiate', authMiddleware, chatController.initiateChat);

// Send a message
router.post('/:chatId/message', authMiddleware, chatController.sendMessage);

// Fetch messages
router.get('/:chatId/messages', authMiddleware, chatController.fetchMessages);

module.exports = router;