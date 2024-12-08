const db = require('../config/db');

const createConversation = (studentId, participantId, callback) => {
  const sql = `INSERT INTO conversations (student_id, participant_id) VALUES (?, ?)`;
  db.query(sql, [studentId, participantId], callback);
};

const getConversations = (studentId, callback) => {
  const sql = `SELECT * FROM conversations WHERE student_id = ? OR participant_id = ?`;
  db.query(sql, [studentId, studentId], callback);
};

const createMessage = (conversationId, senderId, message, callback) => {
  const sql = `INSERT INTO messages (conversation_id, sender_id, message) VALUES (?, ?, ?)`;
  db.query(sql, [conversationId, senderId, message], callback);
};

const getMessages = (conversationId, callback) => {
    const sql = `
      SELECT m.*, u.firstname, u.lastname, u.profile_picture 
      FROM messages m
      JOIN users u ON m.sender_id = u.student_id
      WHERE m.conversation_id = ?
      ORDER BY m.created_at ASC
    `;
    db.query(sql, [conversationId], callback);
  };

const searchUsers = (query, callback) => {
  const sql = `SELECT student_id, username, firstname, lastname FROM users WHERE student_id LIKE ? OR username LIKE ? OR CONCAT(firstname, ' ', lastname) LIKE ?`;
  const searchQuery = `%${query}%`;
  db.query(sql, [searchQuery, searchQuery, searchQuery], callback);
};

const getAllUsers = (callback) => {
  const sql = `SELECT student_id, username, firstname, lastname FROM users`;
  db.query(sql, callback);
};

module.exports = {
  createConversation,
  getConversations,
  createMessage,
  getMessages,
  searchUsers,
  getAllUsers
};