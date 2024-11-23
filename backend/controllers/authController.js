const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const nodemailer = require('nodemailer');
const userModel = require('../models/userModel');

// Nodemailer configuration
const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: 'kusakalaniosa28@gmail.com',
    pass: 'dwha kvpo ogpk txmg',
  },
});

const generateOTP = () => {
  return Math.floor(100000 + Math.random() * 900000).toString();
};

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

        const otp = generateOTP();
        const otpExpires = new Date(Date.now() + 300000); // OTP expires in 5 minutes

        const newUser = {
          student_id,
          username,
          email,
          password: hashedPassword,
          firstname,
          middlename,
          lastname,
          gender,
          birthdate,
          program,
          otp,
          otpExpires,
          isVerified: false
        };

        userModel.createUser(newUser, (err) => {
          if (err) return res.status(500).json({ error: err.message });

          const mailOptions = {
            from: 'kusakalaniosa28@gmail.com',
            to: email,
            subject: 'Your OTP for Email Verification',
            text: `Your OTP is: ${otp}. It is valid for 5 minutes.`,
          };

          transporter.sendMail(mailOptions, (error, info) => {
            if (error) return res.status(500).json({ error: error.message });
            res.status(201).json({ 
              message: 'User registered successfully! Please check your email for the OTP.',
              email: email // Send back the email for the frontend to use
            });
          });
        });
      });
    });
  });
};

exports.verifyOTP = (req, res) => {
  const { email, otp } = req.body;

  if (!email || !otp) {
    return res.status(400).json({ message: 'Email and OTP are required.' });
  }

  console.log(`Attempting to verify OTP for email: ${email}`);

  userModel.findUserByEmail(email, (err, results) => {
    if (err) {
      console.error('Database error:', err);
      return res.status(500).json({ error: 'An error occurred while verifying the OTP.' });
    }
    
    if (results.length === 0) {
      console.log(`No user found for email: ${email}`);
      return res.status(400).json({ message: 'User not found!' });
    }

    const user = results[0];
    console.log('User found:', user);

    if (user.isVerified) {
      console.log(`User ${email} is already verified`);
      return res.status(400).json({ message: 'Email already verified!' });
    }

    console.log(`Stored OTP: ${user.otp}, Received OTP: ${otp}, OTP Expires: ${user.otpExpires}`);

    if (user.otp !== otp) {
      console.log(`Invalid OTP for user ${email}`);
      return res.status(400).json({ message: 'Invalid OTP.' });
    }

    if (new Date() > new Date(user.otpExpires)) {
      console.log(`Expired OTP for user ${email}`);
      return res.status(400).json({ message: 'OTP has expired.' });
    }

    userModel.updateUser({ email, isVerified: true, otp: null, otpExpires: null }, (updateErr) => {
      if (updateErr) {
        console.error('Error updating user:', updateErr);
        return res.status(500).json({ error: 'An error occurred while verifying the email.' });
      }
      console.log(`Successfully verified email for user ${email}`);
      res.status(200).json({ message: 'Email verified successfully! You can now log in.' });
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
    if (!user.isVerified) {
      return res.status(403).json({ message: 'Please verify your email before logging in.' });
    }

    bcrypt.compare(password, user.password, (err, isMatch) => {
      if (err) return res.status(500).json({ error: err.message });
      if (!isMatch) return res.status(400).json({ message: 'Incorrect password!' });

      const token = jwt.sign({ student_id: user.student_id, username: user.username }, 'your_jwt_secret', { expiresIn: '1h' });
      res.status(200).json({
        message: 'Login successful!',
        token,
        username: user.username,
      });
    });
  });
};
exports.forgotPassword = async (req, res) => {
  const { email } = req.body;
  try {
    const user = await new Promise((resolve, reject) => {
      userModel.findUserByEmail(email, (err, results) => {
        if (err) reject(err);
        resolve(results[0]); // Get the first (and should be only) result
      });
    });

    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    const resetToken = generateOTP();
    const resetTokenExpires = new Date(Date.now() + 300000); // 5 minutes

    await new Promise((resolve, reject) => {
      userModel.updateUser({
        email,
        reset_password_token: resetToken,
        reset_password_expires: resetTokenExpires
      }, (err) => {
        if (err) reject(err);
        resolve();
      });
    });

    // Send email with reset token
    const mailOptions = {
      from: 'kusakalaniosa28@gmail.com',
      to: email,
      subject: 'Password Reset OTP',
      text: `Your OTP for password reset is: ${resetToken}. It is valid for 5 minutes.`,
    };

    await transporter.sendMail(mailOptions);
    res.status(200).json({ message: 'Password reset OTP sent to your email' });
  } catch (error) {
    console.error('Error in forgot password process:', error);
    res.status(500).json({ message: 'Error in forgot password process', error: error.message });
  }
};

exports.verifyResetOTP = async (req, res) => {
  const { email, otp } = req.body;
  try {
    console.log('Verifying OTP for email:', email);
    const user = await new Promise((resolve, reject) => {
      userModel.findUserByEmail(email, (err, results) => {
        if (err) reject(err);
        resolve(results[0]);
      });
    });

    if (!user) {
      console.log('User not found for email:', email);
      return res.status(404).json({ message: 'User not found' });
    }

    console.log('Stored OTP:', user.reset_password_token, 'Received OTP:', otp);
    if (user.reset_password_token !== otp) {
      console.log('Invalid OTP for user:', email);
      return res.status(400).json({ message: 'Invalid OTP' });
    }

    if (new Date() > new Date(user.reset_password_expires)) {
      console.log('Expired OTP for user:', email);
      return res.status(400).json({ message: 'OTP has expired' });
    }

    console.log('OTP verified successfully for user:', email);
    res.status(200).json({ message: 'OTP verified successfully' });
  } catch (error) {
    console.error('Error in OTP verification:', error);
    res.status(500).json({ message: 'Error in OTP verification', error: error.message });
  }
};

exports.resetPassword = async (req, res) => {
  const { email, otp, newPassword } = req.body;
  try {
    console.log('Resetting password for email:', email);
    const user = await new Promise((resolve, reject) => {
      userModel.findUserByEmail(email, (err, results) => {
        if (err) reject(err);
        resolve(results[0]);
      });
    });

    if (!user) {
      console.log('User not found for email:', email);
      return res.status(404).json({ message: 'User not found' });
    }

    console.log('Stored OTP:', user.reset_password_token, 'Received OTP:', otp);
    if (user.reset_password_token !== otp) {
      console.log('Invalid OTP for user:', email);
      return res.status(400).json({ message: 'Invalid OTP' });
    }

    if (new Date() > new Date(user.reset_password_expires)) {
      console.log('Expired OTP for user:', email);
      return res.status(400).json({ message: 'OTP has expired' });
    }

    const hashedPassword = await bcrypt.hash(newPassword, 10);
    await new Promise((resolve, reject) => {
      userModel.updateUser({
        email,
        password: hashedPassword,
        reset_password_token: null,
        reset_password_expires: null
      }, (err) => {
        if (err) reject(err);
        resolve();
      });
    });

    console.log('Password reset successfully for user:', email);
    res.status(200).json({ message: 'Password reset successfully' });
  } catch (error) {
    console.error('Error in password reset:', error);
    res.status(500).json({ message: 'Error in password reset', error: error.message });
  }
};