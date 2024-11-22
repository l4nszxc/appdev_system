const db = require('../config/db');

const createPost = (postData, callback) => {
  const sql = 'INSERT INTO posts (student_id, content, emotion) VALUES (?, ?, ?)';
  db.query(sql, [postData.studentId, postData.content, postData.emotion], callback);
};

const getPosts = (callback) => {
  const sql = `
    SELECT 
      p.id, 
      p.content, 
      p.emotion, 
      p.reactions,
      p.comments_count,
      p.created_at, 
      u.username, 
      u.profile_picture,
      u.student_id
    FROM posts p
    JOIN users u ON p.student_id = u.student_id
    ORDER BY p.created_at DESC
  `;
  db.query(sql, callback);
};

module.exports = {
  createPost,
  getPosts
};