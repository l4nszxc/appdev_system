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
        // Get chat info to check if it's active
        const chatInfo = await ChatModel.getChatInfo(chatId);
        if (!chatInfo) {
            return res.status(404).json({ message: 'Chat not found' });
        }
        if (chatInfo.status !== 'active') {
            return res.status(400).json({ message: 'Chat is no longer active' });
        }

// Determine sender type based on user role
        const senderType = req.user.role === 'admin' ? 'admin' : 'user';
        
        const message = await ChatModel.addMessage(
            chatId, 
            req.user.student_id, 
            content,
            senderType
        );

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

exports.getChatInfo = async (req, res) => {
    const { chatId } = req.params;
    try {
        const chatInfo = await ChatModel.getChatInfo(chatId);
        if (!chatInfo) {
            return res.status(404).json({ message: 'Chat not found' });
        }
        res.status(200).json(chatInfo);
    } catch (error) {
        console.error('Error fetching chat info:', error);
        res.status(500).json({ message: 'Failed to fetch chat info' });
    }
};

exports.getActiveChats = async (req, res) => {
    try {
        // Only admin can view all active chats
        if (req.user.role !== 'admin') {
            return res.status(403).json({ message: 'Unauthorized access' });
        }
        const chats = await ChatModel.getActiveChats();
        res.status(200).json(chats);
    } catch (error) {
        console.error('Error fetching active chats:', error);
        res.status(500).json({ message: 'Failed to fetch active chats' });
    }
};

exports.updateChatStatus = async (req, res) => {
    const { chatId } = req.params;
    const { status } = req.body;
    try {
        // Only admin can update chat status
        if (req.user.role !== 'admin') {
            return res.status(403).json({ message: 'Unauthorized access' });
        }
        
        // Validate status
        if (!['active', 'closed'].includes(status)) {
            return res.status(400).json({ message: 'Invalid status' });
        }

        const result = await ChatModel.updateChatStatus(chatId, status);
        res.status(200).json(result);
    } catch (error) {
        console.error('Error updating chat status:', error);
        res.status(500).json({ message: 'Failed to update chat status' });
    }
};
