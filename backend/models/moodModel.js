const db = require('../config/db');

exports.saveMood = (studentId, mood, sentiment, comment) => {
  return new Promise((resolve, reject) => {
    const sql = 'INSERT INTO moods (student_id, mood, sentiment, comment) VALUES (?, ?, ?, ?)';
    db.query(sql, [studentId, mood, sentiment, comment], (error, results) => {
      if (error) {
        console.error('Error saving mood:', error);
        reject(error);
      } else {
        resolve(results.insertId);
      }
    });
  });
};

exports.getMoodsByPeriod = (studentId, period) => {
  return new Promise((resolve, reject) => {
    const sql = `
      SELECT mood, sentiment, created_at 
      FROM moods 
      WHERE student_id = ? 
      AND created_at >= DATE_SUB(CURDATE(), INTERVAL 1 ${period})
      ORDER BY created_at DESC
    `;
    db.query(sql, [studentId], (error, results) => {
      if (error) {
        console.error('Error fetching moods:', error);
        reject(error);
      } else {
        resolve(results);
      }
    });
  });
};
exports.getAllMoods = () => {
  return new Promise((resolve, reject) => {
    const sql = 'SELECT * FROM moods ORDER BY created_at DESC';
    db.query(sql, (error, results) => {
      if (error) {
        console.error('Error fetching all moods:', error);
        reject(error);
      } else {
        resolve(results);
      }
    });
  });
};