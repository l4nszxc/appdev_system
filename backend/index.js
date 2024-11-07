
const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const authController = require('./controllers/authController');

const app = express();
//const router = express.Router();

app.use(cors());
app.use(bodyParser.json());

app.get('/', (req, res) => {
    console.log(`Received a ${req.method} request to ${req.url}`);
    res.json({ message: 'Welcome to the API' });
});

// Define routes
app.post('/register', authController.register);
app.post('/login', authController.login);
app.post('/fingerprint/start', authController.startFingerprintAuth);
app.post('/fingerprint/finish', authController.finishFingerprintAuth);

const PORT = 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));

module.exports = app;