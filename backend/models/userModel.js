const db = require('../config/db');

// Function to create a new user
const createUser  = (userData, callback) => {
<<<<<<< HEAD
  const { student_id, username, email, password, firstname, middlename, lastname, gender, birthdate, program } = userData;
  const sql = `INSERT INTO users (student_id, username, email, password, firstname, middlename, lastname, gender, birthdate, program) 
               VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`;
  db.query(sql, [student_id, username, email, password, firstname, middlename, lastname, gender, birthdate, program], callback);
=======
  const sql = `INSERT INTO users (student_id, username, email, password, firstname, middlename, lastname, gender, birthdate, program, otp, otpExpires) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`;
  db.query(sql, [userData.student_id, userData.username, userData.email, userData.password, userData.firstname, userData.middlename, userData.lastname, userData.gender, userData.birthdate, userData.program, userData.otp, userData.otpExpires], callback);
>>>>>>> 0f2941a0bc1337b7083106f0e75ce9460af8ff9e
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

<<<<<<< HEAD
// Function to find a user by student ID
const findUserByUsername = (username, callback) => {
  const sql = `SELECT * FROM users WHERE username = ?`;
  db.query(sql, [username], callback);
};

module.exports = {
  createUser,
  findUserByEmail,
  findUserByUsername,
=======
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




module.exports = {
  createUser,
  findUserByEmail,
  findUserByStudentId,
  updateUser,
>>>>>>> 0f2941a0bc1337b7083106f0e75ce9460af8ff9e
};