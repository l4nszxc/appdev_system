const Sentiment = require('sentiment');
const sentiment = new Sentiment();
const moodModel = require('../models/moodModel');

exports.saveMood = async (req, res) => {
  const { mood, comment } = req.body;
  const studentId = req.user.student_id;

  const sentimentResult = sentiment.analyze(mood);
  const sentimentScore = sentimentResult.score;
  let sentimentLabel = 'Neutral';
  if (sentimentScore > 0) sentimentLabel = 'Positive';
  else if (sentimentScore < 0) sentimentLabel = 'Negative';

  try {
    await moodModel.saveMood(studentId, mood, sentimentLabel, comment);
    res.status(201).json({ message: 'Mood saved successfully' });
  } catch (error) {
    console.error('Error saving mood:', error);
    res.status(500).json({ message: 'An error occurred while saving mood' });
  }
};

exports.getWeeklyMoods = async (req, res) => {
  const studentId = req.query.studentId || req.user.student_id;
  try {
    const moods = await moodModel.getMoodsByPeriod(studentId, 'WEEK');
    res.status(200).json(moods);
  } catch (error) {
    console.error('Error fetching weekly moods:', error);
    res.status(500).json({ message: 'An error occurred while fetching weekly moods' });
  }
};

exports.getMonthlyMoods = async (req, res) => {
  const studentId = req.query.studentId || req.user.student_id;
  try {
    const moods = await moodModel.getMoodsByPeriod(studentId, 'MONTH');
    res.status(200).json(moods);
  } catch (error) {
    console.error('Error fetching monthly moods:', error);
    res.status(500).json({ message: 'An error occurred while fetching monthly moods' });
  }
};
exports.getAllMoods = async (req, res) => {
  try {
    const moods = await moodModel.getAllMoods();
    const summary = {
      Positive: 0,
      Neutral: 0,
      Negative: 0
    };

    moods.forEach(mood => {
      summary[mood.sentiment]++;
    });

    res.status(200).json({ moods, summary });
  } catch (error) {
    console.error('Error fetching all moods:', error);
    res.status(500).json({ message: 'An error occurred while fetching all moods' });
  }
};
