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
const moodController = require('./controllers/moodController');
const postController = require('./controllers/postController');
const authMiddleware = require('./middleware/authMiddleware');
const adminManageUsersController = require('./controllers/adminManageUsersController');
const empathyChallengeController = require('./controllers/empathyChallengeController');
const chatController = require('./controllers/chatController');

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

// Admin manage users routes
app.get('/api/students/program/:program', authMiddleware, adminManageUsersController.getUsersByProgram);

// Exercise routes
app.get('/exercises', authMiddleware, exerciseController.getWeeklyExercises);
app.post('/exercises', authMiddleware, exerciseController.saveExercise);

// Feedback routes
app.post('/api/feedback', authMiddleware, userFeedbackController.submitFeedback);
app.get('/api/feedback', authMiddleware, userFeedbackController.getUserFeedback);
app.get('/api/feedback/all', authMiddleware, userFeedbackController.getAllFeedback); // New route for fetching all feedback

app.get('/user', authMiddleware, userController.getUserProfile);
app.put('/user', authMiddleware, userController.updateUserProfile);
app.post('/user/profile-picture', authMiddleware, upload.single('profilePicture'), userController.uploadProfilePicture);

// Post routes
app.get('/posts', authMiddleware, postController.getPosts);
app.get('/posts/user', authMiddleware, postController.getPostsByUser); // Add this line
app.post('/posts', authMiddleware, postController.createPost);
app.post('/posts/reactions', authMiddleware, postController.addReaction);
app.post('/posts/comments', authMiddleware, postController.addComment);
app.delete('/posts/:id', authMiddleware, postController.deletePost);
app.put('/posts/:id', authMiddleware, postController.updatePost); // Add this line

// Appointment routes
app.post('/api/appointments', authMiddleware, heartToHeartController.createAppointment);
app.get('/api/appointments', authMiddleware, heartToHeartController.getAppointmentsByDate);
app.get('/api/appointments/current', authMiddleware, heartToHeartController.getCurrentAppointment);
app.delete('/api/appointments/:id', authMiddleware, heartToHeartController.cancelAppointment);

app.get('/api/appointments/today', authMiddleware, heartToHeartController.getTodaysAppointments);
app.get('/api/appointments/all', authMiddleware, heartToHeartController.getAllAppointments);

app.post('/api/appointments/:id/meeting-link', authMiddleware, heartToHeartController.updateMeetingLink);

app.post('/mood', authMiddleware, moodController.saveMood);
app.get('/mood/weekly', authMiddleware, moodController.getWeeklyMoods);
app.get('/mood/monthly', authMiddleware, moodController.getMonthlyMoods);

app.get('/moods', authMiddleware, moodController.getAllMoods);

// Empathy Challenge routes
app.get('/empathy-challenge', authMiddleware, empathyChallengeController.getUserChallenge);
app.post('/empathy-challenge/comment-progress', authMiddleware, empathyChallengeController.updateCommentChallengeProgress);
app.post('/empathy-challenge/reaction-progress', authMiddleware, empathyChallengeController.updateReactionChallengeProgress);
app.post('/admin/reset-empathy-challenges', authMiddleware, empathyChallengeController.resetChallenges);

// Chat routes
app.post('/conversations', authMiddleware, chatController.createConversation);
app.get('/conversations', authMiddleware, chatController.getConversations);
app.post('/messages', authMiddleware, chatController.createMessage);
app.get('/messages/:conversationId', authMiddleware, chatController.getMessages);
app.get('/users/search', authMiddleware, chatController.searchUsers);
app.get('/users/all', authMiddleware, chatController.getAllUsers);

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));