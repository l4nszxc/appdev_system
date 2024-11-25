const db = require('../config/db');

const createUser  = (userData, callback) => {
  const sql = `INSERT INTO users (student_id, username, email, password, firstname, middlename, lastname, gender, birthdate, program, otp, otpExpires, role) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`;
  db.query(sql, [
    userData.student_id, 
    userData.username, 
    userData.email, 
    userData.password, 
    userData.firstname, 
    userData.middlename, 
    userData.lastname, 
    userData.gender, 
    userData.birthdate, 
    userData.program, 
    userData.otp, 
    userData.otpExpires,
    userData.role || 'user'  // Default to 'user' if not specified
  ], callback);
};

// Function to find a user by email
const findUserByEmail = (email, callback) => {
  const sql = `SELECT * FROM users WHERE email = ?`;
  db.query(sql, [email], (err, results) => {
    if (err) {
      console.error('Error in findUserByEmail:', err);
      return callback(err, null);
    }
    callback(null, results);
  });
};

const findUserByStudentId = (student_id, callback) => {
  const sql = 'SELECT * FROM users WHERE student_id = ?';
  db.query(sql, [student_id], callback);
};

const updateUser = (userData, callback) => {
  const { email, ...updateData } = userData;
  const sql = `UPDATE users SET ? WHERE email = ?`;
  db.query(sql, [updateData, email], (err, result) => {
    if (err) {
      console.error('Error in updateUser:', err);
      return callback(err);
    }
    console.log('Update result:', result);
    callback(null, result);
  });
};

const updateUserProfile = (userData, callback) => {
  const { student_id, ...updateData } = userData;
  const sql = `UPDATE users SET ? WHERE student_id = ?`;
  db.query(sql, [updateData, student_id], (err, result) => {
    if (err) {
      console.error('Error in updateUserProfile:', err);
      return callback(err);
    }
    console.log('Profile update result:', result);
    callback(null, result);
  });
};

const findUserByUsername = (username, callback) => {
  const sql = 'SELECT * FROM users WHERE username = ?';
  db.query(sql, [username], (err, results) => {
    if (err) {
      console.error('Error in findUserByUsername:', err);
      return callback(err);
    }
    callback(null, results);
  });
};

const updateUserRole = (student_id, role, callback) => {
  const sql = `UPDATE users SET role = ? WHERE student_id = ?`;
  db.query(sql, [role, student_id], (err, result) => {
    if (err) {
      console.error('Error in updateUserRole:', err);
      return callback(err);
    }
    console.log('Role update result:', result);
    callback(null, result);
  });
};

module.exports = {
  createUser,
  findUserByEmail,
  findUserByStudentId,
  findUserByUsername,
  updateUser,
  updateUserProfile,
  updateUserRole
};
