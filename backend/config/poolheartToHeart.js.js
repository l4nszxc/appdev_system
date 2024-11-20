const mysql = require('mysql2/promise');

const pool = mysql.createPool({
  host: 'localhost',
  user: 'root',       // Replace with your MySQL username
  password: '',       // Replace with your MySQL password
  database: 'appdev_system',
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});

// Test the connection
const testConnection = async () => {
  try {
    await pool.getConnection();
    console.log('Database connected successfully (pool connection)!');
  } catch (error) {
    console.error('Error connecting to the database (pool connection):', error);
    process.exit(1); // Exit if unable to connect
  }
};

testConnection();

module.exports = pool; // Export the pool connection
