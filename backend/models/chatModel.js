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
    
    addMessage: (chatId, senderId, content) => {
        return new Promise((resolve, reject) => {
            const sql = 'INSERT INTO messages (chat_id, student_id, content) VALUES (?, ?, ?)';
            db.query(sql, [chatId, senderId, content], (error, results) => {
                if (error) {
                    reject(error);
                } else {
                    resolve({ id: results.insertId, chatId, senderId, content });
                }
            });
        });
    },

    getMessages: (chatId) => {
        return new Promise((resolve, reject) => {
            const sql = 'SELECT * FROM messages WHERE chat_id = ? ORDER BY timestamp ASC';
            db.query(sql, [chatId], (error, results) => {
                if (error) {
                    reject(error);
                } else {
                    resolve(results);
                }
            });
        });
    }
};

module.exports = ChatModel;