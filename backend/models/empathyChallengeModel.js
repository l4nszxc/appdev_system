const db = require('../config/db');

const getUserChallenge = (studentId, callback) => {
  db.query('SELECT * FROM empathy_challenges WHERE student_id = ?', [studentId], callback);
};

const createUserChallenge = (studentId, callback) => {
  db.query('INSERT INTO empathy_challenges (student_id) VALUES (?)', [studentId], callback);
};

const updateCommentChallenge = (studentId, commentLevel, commentsCount, callback) => {
  db.query('UPDATE empathy_challenges SET comment_level = ?, comments_count = ? WHERE student_id = ?', [commentLevel, commentsCount, studentId], callback);
};

const updateReactionChallenge = (studentId, reactionLevel, reactionsCount, callback) => {
  db.query('UPDATE empathy_challenges SET reaction_level = ?, reactions_count = ? WHERE student_id = ?', [reactionLevel, reactionsCount, studentId], callback);
};

const resetChallenges = (callback) => {
  db.query('DELETE FROM empathy_challenges', callback);
};

const resetDailyChallenges = (studentId, callback) => {
  db.query('UPDATE empathy_challenges SET comments_count = 0, reactions_count = 0, last_reset_date = CURRENT_TIMESTAMP WHERE student_id = ?', [studentId], callback);
};

module.exports = {
  getUserChallenge,
  createUserChallenge,
  updateCommentChallenge,
  updateReactionChallenge,
  resetChallenges,
  resetDailyChallenges,
};