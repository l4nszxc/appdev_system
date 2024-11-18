const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const authController = require('./controllers/authController');
const userController = require('./controllers/userController');
const exerciseController = require('./controllers/exerciseController');
const userFeedbackController = require('./controllers/userFeedbackController');
const authMiddleware = require('./middleware/authMiddleware');

const app = express();
app.use(cors());
app.use(bodyParser.json());

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

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));