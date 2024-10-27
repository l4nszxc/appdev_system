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

const register = async () => {
    try {
      const response = await axios.post('http://localhost:5000/register', {
        username: username.value,
        email: email.value,
        password: password.value,
        confirmPassword: confirmPassword.value
      });
      message.value = response.data.message; // Success message
    } catch (error) {
      console.error(error); // Log error to console for debugging
      message.value = error.response?.data?.message || 'Registration failed'; // Display error message
    }
  }
  