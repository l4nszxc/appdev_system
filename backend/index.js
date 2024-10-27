const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const authController = require('./controllers/authController');

const app = express();
app.use(cors());
app.use(bodyParser.json());

// Routes
app.post('/register', authController.register);
app.post('/login', authController.login);

const PORT = 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));