
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const userModel = require('../models/userModel');
const crypto = require('crypto');
const base64url = require('base64url');
const { Fido2Lib } = require('fido2-lib');

const f2l = new Fido2Lib({
  timeout: 60000,
  rpId: "localhost",
  rpName: "MindConnect",
  challengeSize: 32,
  attestation: "none",
  cryptoParams: [-7, -257],
  authenticatorAttachment: "platform"
});

let currentChallenge = null;

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

exports.getUserProfile = (req, res) => {
  // Assume you have a function to get user info by ID from the token
  const userId = req.user.id; // Get user ID from the token payload
  userModel.findUserByStudentId(userId, (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    if (results.length = 0) return res.status(404).json({ message: 'User  not found' });

    const user = results[0];
    // Send user data excluding password
    const { password, ...userProfile } = user;
    res.status(200).json(userProfile);
  });
}

// Start fingerprint authentication
exports.startFingerprintAuth = async (req, res) => {
  try {
    const registrationOptions = await f2l.attestationOptions();
    
    // store the challenge for later use
    currentChallenge = registrationOptions.challenge;

    res.json(registrationOptions);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

// Finish fingerprint authentication
exports.finishFingerprintAuth = async (req, res) => {
  try {
    const { id, rawId, response, type } = req.body;
    
    const userId = req.body.userId; // You might want to get this from the session or request
    const userKey = await getUserKey(userId); // You need to implement this function

    if (!userKey) {
      return res.status(400).json({ error: 'User not registered for fingerprint auth' });
    }

    const expectedAssertionResult = await f2l.assertionResult(
      {
        id: base64url.toBuffer(id),
        rawId: base64url.toBuffer(rawId),
        response: {
          authenticatorData: base64url.toBuffer(response.authenticatorData),
          clientDataJSON: base64url.toBuffer(response.clientDataJSON),
          signature: base64url.toBuffer(response.signature)
        },
        type
      },
      {
        challenge: currentChallenge,
        origin: "http://localhost:8080",
        factor: "either",
        publicKey: userKey,
        prevCounter: 0,
        userHandle: null
      }
    );

    if (expectedAssertionResult.verified) {
      const token = jwt.sign({ id: userId }, 'your_jwt_secret', { expiresIn: '1h' });
      res.json({ success: true, token });
    } else {
      res.status(400).json({ error: 'Fingerprint authentication failed' });
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

// Placeholder function for getUserKey - you need to implement this
async function getUserKey(userId) {
  // This should retrieve the user's public key from your database
  // For now, it's just a placeholder
  return null;
}

module.exports = {
  register: exports.register,
  login: exports.login,
  startFingerprintAuth: exports.startFingerprintAuth,
  finishFingerprintAuth: exports.finishFingerprintAuth
};