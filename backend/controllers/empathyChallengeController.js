const empathyChallengeModel = require('../models/empathyChallengeModel');

exports.getUserChallenge = (req, res) => {
  const studentId = req.user.student_id;
  empathyChallengeModel.getUserChallenge(studentId, (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    if (results.length === 0) {
      empathyChallengeModel.createUserChallenge(studentId, (err) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json({ comment_level: 1, comments_count: 0, reaction_level: 1, reactions_count: 0 });
      });
    } else {
      const challenge = results[0];
      const today = new Date().toISOString().split('T')[0];
      const lastResetDate = new Date(challenge.last_reset_date).toISOString().split('T')[0];
      if (lastResetDate !== today) {
        empathyChallengeModel.resetDailyChallenges(studentId, (err) => {
          if (err) return res.status(500).json({ error: err.message });
          res.json({ ...challenge, comments_count: 0, reactions_count: 0, last_reset_date: today });
        });
      } else {
        res.json(challenge);
      }
    }
  });
};

exports.updateCommentChallengeProgress = (req, res) => {
  const studentId = req.user.student_id;
  empathyChallengeModel.getUserChallenge(studentId, (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    if (results.length === 0) return res.status(404).json({ message: 'Challenge not found' });

    const challenge = results[0];
    const newCommentsCount = challenge.comments_count + 1;
    const requiredComments = challenge.comment_level * 5;

    if (newCommentsCount >= requiredComments) {
      empathyChallengeModel.updateCommentChallenge(studentId, challenge.comment_level, requiredComments, (err) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json({ ...challenge, comments_count: requiredComments, message: "You've done a level challenge for today, please come back tomorrow." });
      });
    } else {
      empathyChallengeModel.updateCommentChallenge(studentId, challenge.comment_level, newCommentsCount, (err) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json({ ...challenge, comments_count: newCommentsCount });
      });
    }
  });
};

exports.updateReactionChallengeProgress = (req, res) => {
  const studentId = req.user.student_id;
  empathyChallengeModel.getUserChallenge(studentId, (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    if (results.length === 0) return res.status(404).json({ message: 'Challenge not found' });

    const challenge = results[0];
    const newReactionsCount = challenge.reactions_count + 1;
    const requiredReactions = challenge.reaction_level * 5;

    if (newReactionsCount >= requiredReactions) {
      empathyChallengeModel.updateReactionChallenge(studentId, challenge.reaction_level, requiredReactions, (err) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json({ ...challenge, reactions_count: requiredReactions, message: "You've done a level challenge for today, please come back tomorrow." });
      });
    } else {
      empathyChallengeModel.updateReactionChallenge(studentId, challenge.reaction_level, newReactionsCount, (err) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json({ ...challenge, reactions_count: newReactionsCount });
      });
    }
  });
};

exports.resetChallenges = (req, res) => {
  empathyChallengeModel.resetChallenges((err) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json({ message: 'Challenges reset' });
  });
};