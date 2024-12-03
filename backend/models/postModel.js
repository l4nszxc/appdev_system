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
      u.student_id,
      (SELECT COUNT(*) FROM posts_reactions WHERE post_id = p.id) AS reactions_count,
      (SELECT COUNT(*) FROM posts_comments WHERE post_id = p.id) AS comments_count
    FROM posts p
    JOIN users u ON p.student_id = u.student_id
    ORDER BY p.created_at DESC
  `;
  db.query(sql, (err, posts) => {
    if (err) return callback(err);

    const postIds = posts.map(post => post.id);
    if (postIds.length === 0) return callback(null, posts);

    const commentsSql = `
      SELECT 
        c.id, 
        c.post_id, 
        c.content, 
        c.created_at, 
        u.username, 
        u.profile_picture 
      FROM posts_comments c
      JOIN users u ON c.student_id = u.student_id
      WHERE c.post_id IN (?)
    `;
    db.query(commentsSql, [postIds], (err, comments) => {
      if (err) return callback(err);

      const reactionsSql = `
        SELECT 
          r.id,
          r.post_id, 
          r.reaction_type,
          u.username, 
          u.profile_picture 
        FROM posts_reactions r
        JOIN users u ON r.student_id = u.student_id
        WHERE r.post_id IN (?)
      `;
      db.query(reactionsSql, [postIds], (err, reactions) => {
        if (err) return callback(err);

        posts.forEach(post => {
          post.comments = comments.filter(comment => comment.post_id === post.id);
          post.reactions = reactions.filter(reaction => reaction.post_id === post.id);
        });

        callback(null, posts);
      });
    });
  });
};

const addReaction = (reactionData, callback) => {
  const sql = `
    INSERT INTO posts_reactions (post_id, student_id, reaction_type) 
    VALUES (?, ?, ?) 
    ON DUPLICATE KEY UPDATE reaction_type = VALUES(reaction_type)
  `;
  db.query(sql, [reactionData.postId, reactionData.studentId, reactionData.reactionType], callback);
};

const addComment = (commentData, callback) => {
  const sql = 'INSERT INTO posts_comments (post_id, student_id, content) VALUES (?, ?, ?)';
  db.query(sql, [commentData.postId, commentData.studentId, commentData.content], callback);
};
const deleteReactionsByPostId = (postId) => {
  return new Promise((resolve, reject) => {
    const sql = 'DELETE FROM posts_reactions WHERE post_id = ?';
    db.query(sql, [postId], (err, result) => {
      if (err) {
        return reject(err);
      }
      resolve(result);
    });
  });
};

const deleteCommentsByPostId = (postId) => {
  return new Promise((resolve, reject) => {
    const sql = 'DELETE FROM posts_comments WHERE post_id = ?';
    db.query(sql, [postId], (err, result) => {
      if (err) {
        return reject(err);
      }
      resolve(result);
    });
  });
};

const deletePost = (postId) => {
  return new Promise((resolve, reject) => {
    const sql = 'DELETE FROM posts WHERE id = ?';
    db.query(sql, [postId], (err, result) => {
      if (err) {
        return reject(err);
      }
      resolve(result);
    });
  });
};

const getPostsByUser = (studentId, callback) => {
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
      u.student_id,
      (SELECT COUNT(*) FROM posts_reactions WHERE post_id = p.id) AS reactions_count,
      (SELECT COUNT(*) FROM posts_comments WHERE post_id = p.id) AS comments_count
    FROM posts p
    JOIN users u ON p.student_id = u.student_id
    WHERE p.student_id = ?
    ORDER BY p.created_at DESC
  `;
  db.query(sql, [studentId], (err, posts) => {
    if (err) return callback(err);

    const postIds = posts.map(post => post.id);
    if (postIds.length === 0) return callback(null, posts);

    const commentsSql = `
      SELECT 
        c.id, 
        c.post_id, 
        c.content, 
        c.created_at, 
        u.username, 
        u.profile_picture 
      FROM posts_comments c
      JOIN users u ON c.student_id = u.student_id
      WHERE c.post_id IN (?)
    `;
    db.query(commentsSql, [postIds], (err, comments) => {
      if (err) return callback(err);

      const reactionsSql = `
        SELECT 
          r.id,
          r.post_id, 
          r.reaction_type,
          u.username, 
          u.profile_picture 
        FROM posts_reactions r
        JOIN users u ON r.student_id = u.student_id
        WHERE r.post_id IN (?)
      `;
      db.query(reactionsSql, [postIds], (err, reactions) => {
        if (err) return callback(err);

        posts.forEach(post => {
          post.comments = comments.filter(comment => comment.post_id === post.id);
          post.reactions = reactions.filter(reaction => reaction.post_id === post.id);
        });

        callback(null, posts);
      });
    });
  });
};

const updatePost = (postData, callback) => {
  const sql = 'UPDATE posts SET content = ?, emotion = ? WHERE id = ? AND student_id = ?';
  db.query(sql, [postData.content, postData.emotion, postData.postId, postData.studentId], callback);
};

module.exports = {
  createPost,
  getPosts,
  getPostsByUser,
  addReaction,
  addComment,
  deleteCommentsByPostId,
  deleteReactionsByPostId,
  deletePost,
  updatePost,
};