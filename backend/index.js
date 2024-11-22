const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const multer = require('multer');
const path = require('path');
const authController = require('./controllers/authController');
const userController = require('./controllers/userController');
const exerciseController = require('./controllers/exerciseController');
const userFeedbackController = require('./controllers/userFeedbackController');
const heartToHeartController = require('./controllers/heartToHeartController');
const postController = require('./controllers/postController');
const authMiddleware = require('./middleware/authMiddleware');

const app = express();
app.use(cors());
app.use(bodyParser.json());
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

// Set up multer for file uploads
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, 'uploads/');
  },
  filename: (req, file, cb) => {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    cb(null, file.fieldname + '-' + uniqueSuffix + path.extname(file.originalname));
  }
});

const upload = multer({ storage: storage });
// Auth routes
app.post('/register', authController.register);
app.post('/login', authController.login);
app.post('/verify-otp', authController.verifyOTP);
app.post('/forgot-password', authController.forgotPassword);
app.post('/verify-reset-otp', authController.verifyResetOTP);
app.post('/reset-password', authController.resetPassword);

// User routes
app.get('/user', authMiddleware, userController.getUserProfile);
app.put('/user', authMiddleware, userController.updateUserProfile);

// Exercise routes
app.get('/exercises', authMiddleware, exerciseController.getWeeklyExercises);
app.post('/exercises', authMiddleware, exerciseController.saveExercise);

// Feedback routes
app.post('/api/feedback', authMiddleware, userFeedbackController.submitFeedback);
app.get('/api/feedback', authMiddleware, userFeedbackController.getUserFeedback);

app.get('/user', authMiddleware, userController.getUserProfile);
app.put('/user', authMiddleware, userController.updateUserProfile);
app.post('/user/profile-picture', authMiddleware, upload.single('profilePicture'), userController.uploadProfilePicture);

// Post routes]
// Post routes
app.post('/posts', authMiddleware, postController.createPost);
app.get('/posts', authMiddleware, postController.getPosts);
app.post('/posts/reactions', authMiddleware, postController.addReaction);
app.post('/posts/comments', authMiddleware, postController.addComment);


// Appointment routes
app.post('/api/appointments', authMiddleware, heartToHeartController.createAppointment);
app.get('/api/appointments', authMiddleware, heartToHeartController.getAppointmentsByDate);
app.get('/api/appointments/current', authMiddleware, heartToHeartController.getCurrentAppointment);
app.delete('/api/appointments/:id', authMiddleware, heartToHeartController.cancelAppointment);

app.get('/api/appointments/today', authMiddleware, heartToHeartController.getTodaysAppointments);
app.get('/api/appointments/all', authMiddleware, heartToHeartController.getAllAppointments);

app.post('/api/appointments/:id/meeting-link', authMiddleware, heartToHeartController.updateMeetingLink);

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));