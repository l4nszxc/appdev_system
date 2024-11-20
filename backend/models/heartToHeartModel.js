const pool = require('../config/poolheartToHeart.js'); // Use the pool connection

class HeartToHeart {
  static async create(appointment) {
    try {
      const query = `
        INSERT INTO appointments (student_id, date, start_time, end_time, status)
        VALUES (?, ?, ?, ?, ?)
      `;
      const [result] = await pool.execute(query, [
        appointment.student_id,
        appointment.date,
        appointment.start_time,
        appointment.end_time,
        appointment.status,
      ]);
      return result;
    } catch (error) {
      console.error('Database error while creating appointment:', error);
      throw error;
    }
  }

  static async getByDate(date) {
    try {
      const query = `
        SELECT a.*, u.firstname, u.lastname 
        FROM appointments a
        JOIN users u ON a.student_id = u.student_id
        WHERE a.date = ? AND a.status = 'scheduled'
      `;
      const [rows] = await pool.execute(query, [date]);
      return rows || []; // Return empty array if no appointments found
    } catch (error) {
      console.error('Database error while getting appointments by date:', error);
      throw error;
    }
  }

  static async countAppointmentsByDate(date) {
    try {
      const query = `
        SELECT COUNT(*) as count
        FROM appointments
        WHERE date = ? AND status = 'scheduled'
      `;
      const [rows] = await pool.execute(query, [date]);
      return rows[0] ? rows[0].count : 0; // Return count or 0 if not found
    } catch (error) {
      console.error('Database error while counting appointments by date:', error);
      throw error;
    }
  }

  static async checkTimeSlotAvailability(date, startTime) {
    try {
      const query = `
        SELECT COUNT(*) as count
        FROM appointments
        WHERE date = ? AND start_time = ? AND status = 'scheduled'
      `;
      const [rows] = await pool.execute(query, [date, startTime]);
      return rows[0] ? rows[0].count === 0 : true; // Return true if no count found
    } catch (error) {
      console.error('Database error while checking time slot availability:', error);
      throw error;
    }
  }

  static async getCurrentAppointment(studentId) {
    try {
      const query = `
        SELECT * FROM appointments 
        WHERE student_id = ? 
        AND date >= CURDATE() 
        AND status = 'scheduled'
        ORDER BY date, start_time 
        LIMIT 1
      `;
      const [rows] = await pool.execute(query, [studentId]);
      return rows[0] || null; // Return appointment or null if not found
    } catch (error) {
      console.error('Database error while getting current appointment:', error);
      throw error;
    }
  }

  static async getById(id) {
    try {
      const query = 'SELECT * FROM appointments WHERE id = ?';
      const [rows] = await pool.execute(query, [id]);
      return rows[0] || null; // Return appointment or null if not found
    } catch (error) {
      console.error('Database error while getting appointment by ID:', error);
      throw error;
    }
  }

  static async cancel(id) {
    try {
      const query = `
        UPDATE appointments 
        SET status = 'cancelled'
        WHERE id = ?
      `;
      const [result] = await pool.execute(query, [id]);
      return result;
    } catch (error) {
      console.error('Database error while cancelling appointment:', error);
      throw error;
    }
  }
  static async getTodaysAppointments() {
    try {
      const query = `
        SELECT a.*, u.firstname, u.lastname 
        FROM appointments a
        JOIN users u ON a.student_id = u.student_id
        WHERE a.date = CURDATE() AND a.status = 'scheduled'
      `;
      const [rows] = await pool.execute(query);
      return rows || []; // Return empty array if no appointments found
    } catch (error) {
      console.error('Database error while getting today\'s appointments:', error);
      throw error;
    }
  }
  static async getAllAppointments() {
    try {
      const query = `
        SELECT a.*, u.firstname, u.lastname 
        FROM appointments a
        JOIN users u ON a.student_id = u.student_id
        WHERE a.status = 'scheduled'
        ORDER BY a.date, a.start_time
      `;
      const [rows] = await pool.execute(query);
      return rows || []; // Return empty array if no appointments found
    } catch (error) {
      console.error('Database error while getting all appointments:', error);
      throw error;
    }
  }
}

module.exports = HeartToHeart;
