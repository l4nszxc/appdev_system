const userModel = require('../models/userModel');

exports.getUserProfile = (req, res) => {
  const studentId = req.user.student_id; // Changed from id to student_id

  userModel.findUserByStudentId(studentId, (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    if (results.length === 0) {
      return res.status(404).json({ message: 'User not found' });
    }
    const user = results[0];
    // Remove sensitive information
    delete user.password;
    delete user.otp;
    delete user.otpExpires;
    res.status(200).json(user);
  });
};