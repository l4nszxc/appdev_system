const postModel = require('../models/postModel');
const multer = require('multer');
const path = require('path');

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, 'uploads/posts/');
  },
  filename: (req, file, cb) => {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    cb(null, 'post-' + uniqueSuffix + path.extname(file.originalname));
  }
});

const upload = multer({ storage: storage });

exports.createPost = [upload.single('image'), (req, res) => {
  const { content, emotion } = req.body;
  const studentId = req.user.student_id;
  const imageUrl = req.file ? `/uploads/posts/${req.file.filename}` : null;

  postModel.createPost({ studentId, content, emotion, imageUrl }, (err, result) => {
    if (err) {
      return res.status(500).json({ message: 'Failed to create post', error: err });
    }
    res.status(201).json({ message: 'Post created successfully', postId: result.insertId });
  });
}];

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
exports.deletePost = async (req, res) => {
  const postId = req.params.id;

  try {
    // Delete related reactions first
    await postModel.deleteReactionsByPostId(postId);

    // Delete related comments next
    await postModel.deleteCommentsByPostId(postId);

    // Then delete the post
    await postModel.deletePost(postId);

    res.status(200).json({ message: 'Post and related reactions and comments deleted successfully' });
  } catch (err) {
    console.error('Failed to delete post and related reactions and comments:', err);
    res.status(500).json({ message: 'Failed to delete post and related reactions and comments', error: err });
  }
};
exports.getPostsByUser = (req, res) => {
  const studentId = req.user.student_id;

  postModel.getPostsByUser(studentId, (err, results) => {
    if (err) {
      return res.status(500).json({ message: 'Failed to fetch user posts', error: err });
    }
    res.status(200).json(results);
  });
};
exports.updatePost = (req, res) => {
  const postId = req.params.id;
  const { content, emotion } = req.body;
  const studentId = req.user.student_id;

  postModel.updatePost({ postId, studentId, content, emotion }, (err, result) => {
    if (err) {
      return res.status(500).json({ message: 'Failed to update post', error: err });
    }
    res.status(200).json({ message: 'Post updated successfully' });
  });
};
exports.getReactionsByPostId = (req, res) => {
  const postId = req.params.id;

  postModel.getReactionsByPostId(postId, (err, reactions) => {
    if (err) {
      return res.status(500).json({ message: 'Failed to fetch reactions', error: err });
    }
    res.status(200).json(reactions);
  });
};

exports.getCommentsByPostId = (req, res) => {
  const postId = req.params.id;

  postModel.getCommentsByPostId(postId, (err, comments) => {
    if (err) {
      return res.status(500).json({ message: 'Failed to fetch comments', error: err });
    }
    res.status(200).json(comments);
  });
};