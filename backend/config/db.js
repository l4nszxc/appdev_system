const mysql = require('mysql2');

const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',       // Replace with your MySQL username
  password: '',       // Replace with your MySQL password
  database: 'appdev_system'
});

db.connect((err) => {
  if (err) {
    console.error('Error connecting to the database (single connection):', err);
    return;
  }
  console.log('Database connected (single connection)!');
});

module.exports = db;
