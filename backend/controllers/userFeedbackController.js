const UserFeedback = require('../models/userFeedback');

const userFeedbackController = {
  async submitFeedback(req, res) {
    try {
      const { type, content } = req.body;
      const studentId = req.user.student_id; // Assuming authMiddleware adds user info to req

      if (!type || !content) {
        return res.status(400).json({ message: 'Feedback type and content are required' });
      }

      const feedbackId = await UserFeedback.create(studentId, type, content);
      
      res.status(201).json({ message: 'Feedback submitted successfully', feedbackId });
    } catch (error) {
      console.error('Error submitting feedback:', error);
      res.status(500).json({ message: 'An error occurred while submitting feedback' });
    }
  },

  async getUserFeedback(req, res) {
    try {
      const studentId = req.user.student_id; // Assuming authMiddleware adds user info to req

      const feedback = await UserFeedback.getByStudentId(studentId);
      
      res.status(200).json(feedback);
    } catch (error) {
      console.error('Error fetching user feedback:', error);
      res.status(500).json({ message: 'An error occurred while fetching feedback' });
    }
  },
  async getAllFeedback(req, res) {
    try {
      const feedback = await UserFeedback.getAll();
      res.status(200).json(feedback);
    } catch (error) {
      console.error('Error fetching all feedback:', error);
      res.status(500).json({ message: 'An error occurred while fetching feedback' });
    }
  }

  
};

module.exports = userFeedbackController;