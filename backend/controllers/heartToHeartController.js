// controllers/heartToHeartController.js

const HeartToHeart = require('../models/heartToHeartModel');

exports.createAppointment = async (req, res) => {
  try {
    const { date, start_time } = req.body;
    
    // Validate inputs
    if (!date || !start_time) {
      return res.status(400).json({ message: 'Date and start time are required' });
    }

    // Check if user already has an appointment
    const existingAppointment = await HeartToHeart.getCurrentAppointment(req.user.student_id);
    if (existingAppointment) {
      return res.status(400).json({ message: 'You already have an active appointment' });
    }

    // Check if date already has 2 appointments
    const appointmentCount = await HeartToHeart.countAppointmentsByDate(date);
    if (appointmentCount >= 2) {
      return res.status(400).json({ message: 'Maximum appointments reached for this date' });
    }

    // Check if time slot is available
    const isTimeSlotAvailable = await HeartToHeart.checkTimeSlotAvailability(date, start_time);
    if (!isTimeSlotAvailable) {
      return res.status(400).json({ message: 'Time slot already taken' });
    }

    // Calculate end time (1 hour after start time)
    const startDateTime = new Date(`2000-01-01T${start_time}`);
    const endDateTime = new Date(startDateTime.getTime() + 60 * 60 * 1000);
    const end_time = endDateTime.toTimeString().slice(0, 8);

    const result = await HeartToHeart.create({
      student_id: req.user.student_id,
      date,
      start_time,
      end_time,
      status: 'scheduled'
    });

    if (result.insertId) {
      const createdAppointment = await HeartToHeart.getById(result.insertId);
      res.status(201).json(createdAppointment);
    } else {
      throw new Error('Failed to create appointment');
    }
  } catch (error) {
    console.error('Error creating appointment:', error);
    res.status(500).json({ message: 'Internal server error' });
  }
};

exports.getAppointmentsByDate = async (req, res) => {
  try {
    const { date } = req.query;
    if (!date) {
      return res.status(400).json({ message: 'Date is required' });
    }

    const appointments = await HeartToHeart.getByDate(date);
    res.json(appointments || []);
  } catch (error) {
    console.error('Error getting appointments:', error);
    res.status(500).json({ message: 'Internal server error' });
  }
};

exports.getCurrentAppointment = async (req, res) => {
  try {
      const appointment = await HeartToHeart.getCurrentAppointment(req.user.student_id);
      console.log('Current Appointment:', appointment); // Log the appointment
      res.json(appointment);
  } catch (error) {
      console.error('Error getting current appointment:', error);
      res.status(500).json({ message: 'Internal server error' });
  }
};

exports.cancelAppointment = async (req, res) => {
  try {
    const { id } = req.params;
    const appointment = await HeartToHeart.getById(id);

    if (!appointment) {
      return res.status(404).json({ message: 'Appointment not found' });
    }

    if (appointment.student_id !== req.user.student_id) {
      return res.status(403).json({ message: 'Unauthorized to cancel this appointment' });
    }

    await HeartToHeart.cancel(id);
    res.json({ message: 'Appointment cancelled successfully' });
  } catch (error) {
    console.error('Error canceling appointment:', error);
    res.status(500).json({ message: 'Internal server error' });
  }
};
exports.getTodaysAppointments = async (req, res) => {
  try {
    const appointments = await HeartToHeart.getTodaysAppointments();
    res.json(appointments || []);
  } catch (error) {
    console.error('Error getting today\'s appointments:', error);
    res.status(500).json({ message: 'Internal server error' });
  }
};
exports.getAllAppointments = async (req, res) => {
  try {
    const appointments = await HeartToHeart.getAllAppointments();
    res.json(appointments || []);
  } catch (error) {
    console.error('Error getting all appointments:', error);
    res.status(500).json({ message: 'Internal server error' });
  }
};
