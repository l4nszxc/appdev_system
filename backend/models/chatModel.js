const db = require('../config/db');

const ChatModel = {
    createChat: (studentId, isAnonymous) => {
        return new Promise((resolve, reject) => {
            const sql = 'INSERT INTO chats (student_id, is_anonymous) VALUES (?, ?)';
            db.query(sql, [studentId, isAnonymous], (error, results) => {
                if (error) {
                    reject(error);
                } else {
                    resolve({ chatId: results.insertId, studentId, isAnonymous });
                }
            });
        });
    },
    
    addMessage: (chatId, senderId, content, senderType) => {
        return new Promise((resolve, reject) => {
            const sql = 'INSERT INTO messages (chat_id, sender_id, content, sender_type) VALUES (?, ?, ?, ?)';
            db.query(sql, [chatId, senderId, content, senderType], (error, results) => {
                if (error) {
                    reject(error);
                } else {
                    resolve({ 
                        id: results.insertId, 
                        chatId, 
                        senderId, 
                        content,
                        senderType,
                        timestamp: new Date()
                    });
                }
            });
        });
    },

    getMessages: (chatId) => {
        return new Promise((resolve, reject) => {
            const sql = `
                SELECT m.*, c.is_anonymous,
                    CASE 
                        WHEN c.is_anonymous = 1 AND m.sender_type = 'user' THEN 'Anonymous'
                        WHEN m.sender_type = 'admin' THEN 'Admin'
                        ELSE u.username 
                    END as sender_name,
                    m.sender_type
                FROM messages m
                JOIN chats c ON m.chat_id = c.chat_id
                LEFT JOIN users u ON m.sender_id = u.student_id
                WHERE m.chat_id = ?
                ORDER BY m.timestamp ASC`;
            
            db.query(sql, [chatId], (error, results) => {
                if (error) {
                    reject(error);
                } else {
                    resolve(results);
                }
            });
        });
    },

    getChatInfo: (chatId) => {
        return new Promise((resolve, reject) => {
            const sql = `
                SELECT c.*, 
                    CASE 
                        WHEN c.is_anonymous = 1 THEN 'Anonymous'
                        ELSE u.username 
                    END as username
                FROM chats c
                LEFT JOIN users u ON c.student_id = u.student_id
                WHERE c.chat_id = ?`;
            
            db.query(sql, [chatId], (error, results) => {
                if (error) {
                    reject(error);
                } else {
                    resolve(results[0]);
                }
            });
        });
    },

    getActiveChats: () => {
        return new Promise((resolve, reject) => {
            const sql = `
                SELECT c.*, 
                    CASE 
                        WHEN c.is_anonymous = 1 THEN 'Anonymous User'
                        ELSE u.username 
                    END as username,
                    u.program,
                    (
                        SELECT COUNT(*) 
                        FROM messages m 
                        WHERE m.chat_id = c.chat_id
                    ) as message_count,
                    (
                        SELECT m.timestamp 
                        FROM messages m 
                        WHERE m.chat_id = c.chat_id 
                        ORDER BY m.timestamp DESC 
                        LIMIT 1
                    ) as last_message_time
                FROM chats c
                LEFT JOIN users u ON c.student_id = u.student_id
                WHERE c.status = 'active'
                ORDER BY last_message_time DESC`;
            
            db.query(sql, (error, results) => {
                if (error) {
                    reject(error);
                } else {
                    resolve(results);
                }
            });
        });
    },

    updateChatStatus: (chatId, status) => {
        return new Promise((resolve, reject) => {
            const sql = 'UPDATE chats SET status = ? WHERE chat_id = ?';
            db.query(sql, [status, chatId], (error, results) => {
                if (error) {
                    reject(error);
                } else {
                    resolve({ chatId, status });
                }
            });
        });
    }
};

module.exports = ChatModel;
