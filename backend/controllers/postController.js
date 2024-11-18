const postModel = require('../models/postModel');

exports.createPost = (req, res) => {
  const { content, emotion } = req.body;
  const studentId = req.user.student_id;

  postModel.createPost({ studentId, content, emotion }, (err, result) => {
    if (err) {
      return res.status(500).json({ error: 'Failed to create post' });
    }
    res.status(201).json({ message: 'Post created successfully', postId: result.insertId });
  });
};

exports.getPosts = (req, res) => {
  postModel.getPosts((err, results) => {
    if (err) {
      return res.status(500).json({ error: 'Failed to fetch posts' });
    }
    res.status(200).json(results);
  });
};

exports.toggleReaction = (req, res) => {
  const { postId } = req.params;
  const studentId = req.user.student_id;

  postModel.addReaction(postId, studentId, (err, result) => {
    if (err) {
      return res.status(500).json({ error: 'Failed to toggle reaction' });
    }
    res.status(200).json({ message: 'Reaction toggled successfully' });
  });
};

exports.addComment = (req, res) => {
  const { postId } = req.params;
  const { content } = req.body;
  const studentId = req.user.student_id;

  postModel.addComment({ postId, studentId, content }, (err, result) => {
    if (err) {
      return res.status(500).json({ error: 'Failed to add comment' });
    }
    res.status(201).json({ message: 'Comment added successfully', commentId: result.insertId });
  });
};

exports.getComments = (req, res) => {
  const { postId } = req.params;

  postModel.getPostComments(postId, (err, results) => {
    if (err) {
      return res.status(500).json({ error: 'Failed to fetch comments' });
    }
    res.status(200).json(results);
  });
};

