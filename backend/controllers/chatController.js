const ChatModel = require('../models/chatModel');

exports.initiateChat = async (req, res) => {
    const { isAnonymous } = req.body;
    try {
        const chat = await ChatModel.createChat(req.user.student_id, isAnonymous);
        res.status(201).json(chat);
    } catch (error) {
        console.error('Error initiating chat:', error);
        res.status(500).json({ message: 'Failed to initiate chat' });
    }
};

exports.sendMessage = async (req, res) => {
    const { chatId } = req.params;
    const { content } = req.body;
    try {
        const message = await ChatModel.addMessage(chatId, req.user.student_id, content);
        res.status(201).json(message);
    } catch (error) {
        console.error('Error sending message:', error);
        res.status(500).json({ message: 'Failed to send message' });
    }
};

exports.fetchMessages = async (req, res) => {
    const { chatId } = req.params;
    try {
        const messages = await ChatModel.getMessages(chatId);
        res.status(200).json(messages);
    } catch (error) {
        console.error('Error fetching messages:', error);
        res.status(500).json({ message: 'Failed to fetch messages' });
    }
};