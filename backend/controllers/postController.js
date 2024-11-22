const postModel = require('../models/postModel');

exports.createPost = (req, res) => {
  const { content, emotion } = req.body;
  const studentId = req.user.student_id;

  postModel.createPost({ studentId, content, emotion }, (err, result) => {
    if (err) {
      return res.status(500).json({ message: 'Failed to create post', error: err });
    }
    res.status(201).json({ message: 'Post created successfully', postId: result.insertId });
  });
};

exports.getPosts = (req, res) => {
  postModel.getPosts((err, results) => {
    if (err) {
      return res.status(500).json({ message: 'Failed to fetch posts', error: err });
    }
    res.status(200).json(results);
  });
};

exports.addReaction = (req, res) => {
  const { postId, reactionType } = req.body;
  const studentId = req.user.student_id;

  postModel.addReaction({ postId, studentId, reactionType }, (err, result) => {
    if (err) {
      return res.status(500).json({ message: 'Failed to add reaction', error: err });
    }
    res.status(201).json({ message: 'Reaction added successfully' });
  });
};

exports.addComment = (req, res) => {
  const { postId, content } = req.body;
  const studentId = req.user.student_id;

  postModel.addComment({ postId, studentId, content }, (err, result) => {
    if (err) {
      return res.status(500).json({ message: 'Failed to add comment', error: err });
    }
    res.status(201).json({ message: 'Comment added successfully' });
  });
};