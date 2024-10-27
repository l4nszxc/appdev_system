const db = require('../config/db');

// Function to create a new user
const createUser = (userData, callback) => {
  const { username, email, password } = userData;
  const sql = `INSERT INTO users (username, email, password) VALUES (?, ?, ?)`;
  db.query(sql, [username, email, password], callback);
};

// Function to find a user by email
const findUserByEmail = (email, callback) => {
  const sql = `SELECT * FROM users WHERE email = ?`;
  db.query(sql, [email], callback);
};

module.exports = {
  createUser,
  findUserByEmail,
};