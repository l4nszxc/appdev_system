const chatModel = require('../models/chatModel');
const userModel = require('../models/userModel');
const db = require('../config/db');

exports.createConversation = (req, res) => {
  const { participantId } = req.body;
  const studentId = req.user.student_id;

  chatModel.createConversation(studentId, participantId, (err, result) => {
    if (err) {
      console.error('Error creating conversation:', err);
      return res.status(500).json({ error: 'An error occurred while creating the conversation.' });
    }
    res.status(201).json({ message: 'Conversation created successfully', conversationId: result.insertId });
  });
};

exports.getConversations = (req, res) => {
    const studentId = req.user.student_id;
    const sql = `
      SELECT c.*, 
             u1.firstname as student_firstname, u1.lastname as student_lastname,
             u2.firstname as participant_firstname, u2.lastname as participant_lastname
      FROM conversations c
      JOIN users u1 ON c.student_id = u1.student_id
      JOIN users u2 ON c.participant_id = u2.student_id
      WHERE c.student_id = ? OR c.participant_id = ?
    `;
    
    db.query(sql, [studentId, studentId], (err, results) => {
      if (err) {
        console.error('Error fetching conversations:', err);
        return res.status(500).json({ error: 'Database error' });
      }
      res.json(results);
    });
  };

exports.createMessage = (req, res) => {
  const { conversationId, message } = req.body;
  const senderId = req.user.student_id;

  chatModel.createMessage(conversationId, senderId, message, (err, result) => {
    if (err) {
      console.error('Error sending message:', err);
      return res.status(500).json({ error: 'An error occurred while sending the message.' });
    }
    res.status(201).json({ message: 'Message sent successfully', messageId: result.insertId });
  });
};

exports.getMessages = (req, res) => {
    const { conversationId } = req.params;
    
    chatModel.getMessages(conversationId, (err, results) => {
      if (err) {
        console.error('Error fetching messages:', err);
        return res.status(500).json({ error: 'Failed to fetch messages' });
      }
      res.status(200).json(results);
    });
  };

exports.searchUsers = async (req, res) => {
    const { query } = req.query;
    try {
      const sql = `
        SELECT student_id, username, firstname, middlename, lastname, profile_picture 
        FROM users 
        WHERE (student_id LIKE ? OR username LIKE ? OR 
              CONCAT(firstname, ' ', lastname) LIKE ?) 
              AND role != 'admin'
      `;
      const searchPattern = `%${query}%`;
      db.query(sql, [searchPattern, searchPattern, searchPattern], (err, results) => {
        if (err) {
          console.error('Error searching users:', err);
          return res.status(500).json({ error: 'Database error' });
        }
        res.json(results);
      });
    } catch (error) {
      res.status(500).json({ error: 'Server error' });
    }
  };

  exports.getAllUsers = (req, res) => {
    const sql = `
      SELECT student_id, username, firstname, middlename, lastname, profile_picture 
      FROM users 
      WHERE role != 'admin'
      AND student_id != ?
    `;
    
    db.query(sql, [req.user.student_id], (err, results) => {
      if (err) {
        console.error('Error fetching users:', err);
        return res.status(500).json({ error: 'Database error' });
      }
      res.json(results);
    });
  };