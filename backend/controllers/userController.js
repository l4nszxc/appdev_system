const userModel = require('../models/userModel');

exports.getUserProfile = (req, res) => {
  const studentId = req.user.student_id;

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

exports.updateUserProfile = (req, res) => {
  const studentId = req.user.student_id;
  const { username, firstname, middlename, lastname, gender, birthdate, program } = req.body;

  // First, check if the new username is already taken
  userModel.findUserByUsername(username, (err, results) => {
    if (err) {
      return res.status(500).json({ error: 'An error occurred while checking the username.' });
    }
    if (results.length > 0 && results[0].student_id !== studentId) {
      return res.status(400).json({ error: 'Username already taken' });
    }

    // If username is not taken, proceed with the update
    userModel.updateUserProfile(
      { student_id: studentId, username, firstname, middlename, lastname, gender, birthdate, program },
      (err, result) => {
        if (err) {
          console.error('Error updating user profile:', err);
          return res.status(500).json({ error: 'An error occurred while updating the profile.' });
        }
        if (result.affectedRows === 0) {
          return res.status(404).json({ message: 'User not found' });
        }
        res.status(200).json({ message: 'Profile updated successfully' });
      }
    );
  });
};