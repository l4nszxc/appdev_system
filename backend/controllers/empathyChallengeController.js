const db = require('../config/db');

exports.getUserChallenge = (req, res) => {
  const studentId = req.user.student_id;
  db.query('SELECT * FROM empathy_challenges WHERE student_id = ?', [studentId], (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    if (results.length === 0) {
      db.query('INSERT INTO empathy_challenges (student_id) VALUES (?)', [studentId], (err, result) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json({ level: 1, comments_count: 0 });
      });
    } else {
      res.json(results[0]);
    }
  });
};

exports.updateChallengeProgress = (req, res) => {
    const studentId = req.user.student_id;
    db.query('SELECT * FROM empathy_challenges WHERE student_id = ?', [studentId], (err, results) => {
      if (err) return res.status(500).json({ error: err.message });
      if (results.length === 0) return res.status(404).json({ message: 'Challenge not found' });
  
      const challenge = results[0];
      const newCommentsCount = challenge.comments_count + 1;
      const level = challenge.level;
      const requiredComments = level * 5;
  
      if (newCommentsCount >= requiredComments) {
        const newLevel = level + 1;
        db.query('UPDATE empathy_challenges SET level = ?, comments_count = 0 WHERE student_id = ?', [newLevel, studentId], (err) => {
          if (err) return res.status(500).json({ error: err.message });
          res.json({ level: newLevel, comments_count: 0 });
        });
      } else {
        db.query('UPDATE empathy_challenges SET comments_count = ? WHERE student_id = ?', [newCommentsCount, studentId], (err) => {
          if (err) return res.status(500).json({ error: err.message });
          res.json({ level, comments_count: newCommentsCount });
        });
      }
    });
  };

exports.resetChallenges = (req, res) => {
  db.query('DELETE FROM empathy_challenges', (err) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json({ message: 'Challenges reset' });
  });
};