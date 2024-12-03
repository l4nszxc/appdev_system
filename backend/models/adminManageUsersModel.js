const db = require('../config/db');

exports.findUsersByProgram = (program, callback) => {
  const sql = 'SELECT student_id, username, email, firstname, middlename, lastname, gender, birthdate, program FROM users WHERE program = ?';
  db.query(sql, [program], (err, results) => {
    if (err) {
      console.error('Error fetching users by program:', err);
      return callback(err, null);
    }
    callback(null, results);
  });
};