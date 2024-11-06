const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const userModel = require('../models/userModel');

// Register new user
// Register new user
exports.register = (req, res) => {
  const { student_id, username, email, password, confirmPassword, firstname, middlename, lastname, gender, birthdate, program } = req.body;

  if (password !== confirmPassword) {
    return res.status(400).json({ message: 'Passwords do not match!' });
  }

  userModel.findUserByEmail(email, (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    if (results.length > 0) return res.status(400).json({ message: 'Email already exists!' });

    userModel.findUserByStudentId(student_id, (err, results) => {
      if (err) return res.status(500).json({ error: err.message });
      if (results.length > 0) return res.status(400).json({ message: 'Student ID already exists!' });

      bcrypt.hash(password, 10, (err, hashedPassword) => {
        if (err) return res.status(500).json({ error: err.message });

        userModel.createUser  ({
          student_id,  // Include student_id here
          username,
          email,
          password: hashedPassword,
          firstname,
          middlename,
          lastname,
          gender,
          birthdate,
          program
        }, (err, result) => {
          if (err) return res.status(500).json({ error: err.message });
          res.status(201).json({ message: 'User  registered successfully!' });
        });
      });
    });
  });
};


// Login user
exports.login = (req, res) => {
  const { email, password } = req.body;

  userModel.findUserByEmail(email, (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    if (results.length === 0) return res.status(400).json({ message: 'User not found!' });

    const user = results[0];
    bcrypt.compare(password, user.password, (err, isMatch) => {
      if (!isMatch) return res.status(400).json({ message: 'Incorrect password!' });

      const token = jwt.sign({ id: user.id, username: user.username }, 'your_jwt_secret', { expiresIn: '1h' });
      res.status(200).json({
        message: 'Login successful!',
        token,
        username: user.username,  // Include the username in the response
      });
    });
  });
};
