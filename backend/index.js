
const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const authController = require('./controllers/authController');

const app = express();
//const router = express.Router();

app.use(cors());
app.use(bodyParser.json());

app.get('/user/:username', async (req, res) => {
    const username = req.params.username;
    // Fetch user data from database or API
    const userData = await userModel.findUserByUsername(username);
    res.json(userData);
  });

// Define routes
app.post('/register', authController.register);
app.post('/login', authController.login);
app.post('/fingerprint/start', authController.startFingerprintAuth);
app.post('/fingerprint/finish', authController.finishFingerprintAuth);
app.post('/verify-otp', authController.verifyOTP);
app.post('/forgot-password', authController.forgotPassword);
app.post('/verify-reset-otp', authController.verifyResetOTP);
app.post('/reset-password', authController.resetPassword);

const PORT = 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));

module.exports = app;

