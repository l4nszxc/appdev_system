const express = require('express');
const router = express.Router();
const chatController = require('../controllers/chatController');
const { authMiddleware, adminMiddleware } = require('../middleware/authMiddleware');

// User Routes
router.post('/initiate', authMiddleware, chatController.initiateChat);
router.post('/:chatId/message', authMiddleware, chatController.sendMessage);
router.get('/:chatId/messages', authMiddleware, chatController.fetchMessages);
router.get('/:chatId/info', authMiddleware, chatController.getChatInfo);

// Admin Routes (protected by both auth and admin middleware)
router.get('/active', authMiddleware, adminMiddleware, chatController.getActiveChats);
router.patch('/:chatId/status', authMiddleware, adminMiddleware, chatController.updateChatStatus);

module.exports = router;
