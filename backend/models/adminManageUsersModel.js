// adminManageUsersModel.js
const db = require('../config/db');

exports.findUsersByProgram = (program, callback) => {
  let sql;
  let params;

  if (program === 'ALL STUDENTS') {
    sql = 'SELECT student_id, username, email, firstname, middlename, lastname, gender, birthdate, program FROM users';
    params = [];
  } else {
    sql = 'SELECT student_id, username, email, firstname, middlename, lastname, gender, birthdate, program FROM users WHERE program = ?';
    params = [program];
  }

  db.query(sql, params, (err, results) => {
    if (err) {
      console.error('Error fetching users:', err);
      return callback(err, null);
    }
    callback(null, results);
  });
};