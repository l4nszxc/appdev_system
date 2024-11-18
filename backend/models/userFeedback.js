const db = require('../config/db');

const UserFeedback = {
  create(studentId, feedbackType, feedbackContent) {
    return new Promise((resolve, reject) => {
      db.query(
        'INSERT INTO feedback (student_id, feedback_type, feedback_content) VALUES (?, ?, ?)',
        [studentId, feedbackType, feedbackContent],
        (error, results) => {
          if (error) {
            console.error('Error creating feedback:', error);
            reject(error);
          } else {
            resolve(results.insertId);
          }
        }
      );
    });
  },

  getByStudentId(studentId) {
    return new Promise((resolve, reject) => {
      db.query(
        'SELECT * FROM feedback WHERE student_id = ? ORDER BY created_at DESC',
        [studentId],
        (error, results) => {
          if (error) {
            console.error('Error fetching feedback:', error);
            reject(error);
          } else {
            resolve(results);
          }
        }
      );
    });
  }
};

module.exports = UserFeedback;