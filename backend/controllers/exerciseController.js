const db = require('../config/db');

exports.getWeeklyExercises = (req, res) => {
  const studentId = req.user.student_id;
  const query = `
    SELECT * FROM user_exercises 
    WHERE student_id = ? 
    AND exercise_date >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)
    ORDER BY exercise_date DESC
  `;

  db.query(query, [studentId], (err, results) => {
    if (err) {
      console.error('Error fetching weekly exercises:', err);
      return res.status(500).json({ error: err.message });
    }
    res.status(200).json(results);
  });
};

exports.saveExercise = (req, res) => {
  const studentId = req.user.student_id;
  const { exerciseType, exerciseTitle } = req.body;

  if (!exerciseType || !exerciseTitle) {
    return res.status(400).json({ error: 'Exercise type and title are required' });
  }

  const query = `
    INSERT INTO user_exercises (student_id, exercise_date, exercise_completed, exercise_type, exercise_title)
    VALUES (?, CURDATE(), TRUE, ?, ?)
  `;

  db.query(query, [studentId, exerciseType, exerciseTitle], (err, result) => {
    if (err) {
      console.error('Error saving exercise:', err);
      return res.status(500).json({ error: err.message });
    }
    console.log('Exercise saved successfully:', result);
    res.status(201).json({ message: 'Exercise saved successfully', id: result.insertId });
  });
};