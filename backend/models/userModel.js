const db = require('../config/db');

// Function to create a new user
const createUser  = (userData, callback) => {
  const { student_id, username, email, password, firstname, middlename, lastname, gender, birthdate, program } = userData;
  const sql = `INSERT INTO users (student_id, username, email, password, firstname, middlename, lastname, gender, birthdate, program) 
               VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`;
  db.query(sql, [student_id, username, email, password, firstname, middlename, lastname, gender, birthdate, program], callback);
};

const findUserByStudentId = (student_id, callback) => {
  const sql = 'SELECT * FROM users WHERE student_id = ?';
  db.query(sql, [student_id], callback);
};


// Function to find a user by email
const findUserByEmail = (email, callback) => {
  const sql = `SELECT * FROM users WHERE email = ?`;
  db.query(sql, [email], callback);
};

module.exports = {
  createUser,
  findUserByEmail,
  findUserByStudentId,
};