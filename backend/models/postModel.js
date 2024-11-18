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

const addReaction = (postId, studentId, callback) => {
  const checkSql = 'SELECT * FROM post_reactions WHERE post_id = ? AND student_id = ?';
  db.query(checkSql, [postId, studentId], (checkErr, checkResults) => {
    if (checkErr) return callback(checkErr);

    if (checkResults.length > 0) {
      // Remove reaction if exists
      const removeSql = `
        DELETE FROM post_reactions WHERE post_id = ? AND student_id = ?;
        UPDATE posts SET reactions = GREATEST(reactions - 1, 0) WHERE id = ?
      `;
      db.query(removeSql, [postId, studentId, postId], callback);
    } else {
      // Add reaction
      const addSql = `
        INSERT INTO post_reactions (post_id, student_id) VALUES (?, ?);
        UPDATE posts SET reactions = reactions + 1 WHERE id = ?
      `;
      db.query(addSql, [postId, studentId, postId], callback);
    }
  });
};

const addComment = (postData, callback) => {
  const sql = `
    INSERT INTO comments (post_id, student_id, content) VALUES (?, ?, ?);
    UPDATE posts SET comments_count = comments_count + 1 WHERE id = ?
  `;
  db.query(sql, [postData.postId, postData.studentId, postData.content, postData.postId], callback);
};

const getPostComments = (postId, callback) => {
  const sql = `
    SELECT 
      c.id, 
      c.content, 
      c.created_at, 
      u.username,
      u.profile_picture
    FROM comments c
    JOIN users u ON c.student_id = u.student_id
    WHERE c.post_id = ?
    ORDER BY c.created_at ASC
  `;
  db.query(sql, [postId], callback);
};

module.exports = {
  createPost,
  getPosts,
  addReaction,
  addComment,
  getPostComments
};