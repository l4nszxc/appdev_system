<template>
  <Navbar />
  <div class="app-container">
    <div class="register-card">
      <div class="register-content">
        <h2 class="register-title">CREATE AN ACCOUNT</h2>
        <form @submit.prevent="register" class="register-form">
          <!-- Student ID Field -->
          <div class="form-group">
            <label for="student_id" class="form-label">Student ID</label>
            <div class="input-wrapper">
              <input
                id="student_id"
                v-model="student_id"
                placeholder="Student ID (e.g., MCC2022-0811)"
                required
                class="form-input"
              />
            </div>
          </div>

          <!-- First Name Field -->
          <div class="form-group">
            <label for="firstname" class="form-label">First Name</label>
            <div class="input-wrapper">
              <input
                id="firstname"
                v-model="firstname"
                placeholder="First Name"
                required
                class="form-input"
              />
            </div>
          </div>

          <!-- Middle Name Field -->
          <div class="form-group">
            <label for="middlename" class="form-label">Middle Name</label>
            <div class="input-wrapper">
              <input
                id="middlename"
                v-model="middlename"
                placeholder="Middle Name"
                class="form-input"
              />
            </div>
          </div>

          <!-- Last Name Field -->
          <div class="form-group">
            <label for="lastname" class="form-label">Last Name</label>
            <div class="input-wrapper">
              <input
                id="lastname"
                v-model="lastname"
                placeholder="Last Name"
                required
                class="form-input"
              />
            </div>
          </div>

          <!-- Gender Field -->
          <div class="form-group">
            <label for="gender" class="form-label">Gender</label>
            <div class="input-wrapper">
              <select id="gender" v-model="gender" required class="form-input">
                <option value="Male">Male</option>
                <option value="Female">Female</option>
                <option value="Other">Other</option>
              </select>
            </div>
          </div>

          <!-- Birthdate Field -->
          <div class="form-group">
            <label for="birthdate" class="form-label">Birthdate</label>
            <div class="input-wrapper">
              <input
                id="birthdate"
                v-model="birthdate"
                type="date"
                required
                class="form-input"
              />
            </div>
          </div>

          <!-- Program Field -->
          <div class="form-group">
            <label for="program" class="form-label">Program</label>
            <div class="input-wrapper">
              <input
                id="program"
                v-model="program"
                placeholder="Program"
                required
                class="form-input"
              />
            </div>
          </div>

          <!-- Username Field -->
          <div class="form-group">
            <label for="username" class="form-label">Username</label>
            <div class="input-wrapper">
              <User  class="input-icon" :size="20" />
              <input
                id="username"
                v-model="username"
                placeholder="Username"
                required
                class="form-input"
              />
            </div>
          </div>

          <!-- Email Field -->
          <div class="form-group">
            <label for="email" class="form-label">Email</label>
            <div class="input-wrapper">
              <Mail class="input-icon" :size="20" />
              <input
                id="email"
                v-model="email"
                type="email"
                placeholder="Email"
                required
                class="form-input"
              />
            </div>
          </div>

          <!-- Password Field -->
          <div class="form-group">
            <label for="password" class="form-label">Password</label>
            <div class="input-wrapper">
              <Lock class="input-icon" :size="20" />
              <input
                id="password"
                v-model="password"
                type="password"
                placeholder="Password"
                required
                class="form-input"
              />
            </div>
          </div>

          <!-- Confirm Password Field -->
          <div class="form-group">
            <label for="confirmPassword" class="form-label">Confirm Password</ ```vue
            <label for="confirmPassword" class="form-label">Confirm Password</label>
            <div class="input-wrapper">
              <Lock class="input-icon" :size="20" />
              <input
                id="confirmPassword"
                v-model="confirmPassword"
                type="password"
                placeholder="Confirm Password"
                required
                class="form-input"
              />
            </div>
          </div>

          <!-- Register Button -->
          <button type="submit" class="submit-button">
            Register
            <User Plus class="button-icon" :size="20" />
          </button>
        </form>
      </div>
      <div class="register-footer">
        <p class="login-text">
          Already have an account?
          <router-link to="/login" class="link">Sign in</router-link>
        </p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { User, Mail, Lock, UserPlus } from 'lucide-vue-next'
import axios from 'axios'
import Navbar from '../components/Navbar.vue'; // Import Navbar component

const student_id = ref('');  // Keep this line for student_id
const firstname = ref('');
const middlename = ref('');
const lastname = ref('');
const gender = ref('');
const birthdate = ref('');
const program = ref('');
const username = ref('')
const email = ref('')
const password = ref('')
const confirmPassword = ref('')

const register = async () => {
  if (password.value !== confirmPassword.value) {
    alert('Passwords do not match!'); // Password mismatch notification
    return;
  }

  try {
    const response = await axios.post('http://localhost:5000/register', {
      student_id: student_id.value,  // Include student_id here
      username: username.value,
      email: email.value,
      password: password.value,
      confirmPassword: confirmPassword.value,
      firstname: firstname.value,
      middlename: middlename.value,
      lastname: lastname.value,
      gender: gender.value,
      birthdate: birthdate.value,
      program: program.value
    });

    alert(response.data.message); // Success notification
  } catch (error) {
    alert(error.response.data.message || 'An error occurred'); // Generic error message
  }
};

</script>

<style scoped>
/* Main container with gradient background */
.app-container {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: flex-start;
  background-image: url('../assets/bg minsu.png');
  background-size: cover;
  background-position: center; /* Centers the background image */
  background-repeat: no-repeat;
  padding-top: 80px;
}

/* Card for registration form */
.register-card {
  width: 100%;
  max-width: 32rem;
  background-color: #128535; /* Soft green background */
  border-radius: 0.5rem;
  box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.3), 0 10px 10px -5px rgba(0, 0, 0, 0.2);
  overflow: hidden;
}

.register-content {
  padding: 1.5rem;
}

@media (min-width: 640px) {
  .register-content {
    padding: 2rem;
  }
}

/* Title styling */
.register-title {
  font-size: 1.5rem;
  font-weight: bold;
  text-align: center;
  color: #ffffff;
  margin-bottom: 1.5rem;
}

/* Form layout */
.register-form {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
  flex: 1;
  min-width: 0;
}

/* Label and icon colors */
.form-label {
  font-size: 0.875rem;
  font-weight: 500;
  color: #f1faee;
}

.input-wrapper {
  position: relative;
}

.input-icon {
  position: absolute;
  left: 0.75rem;
  top: 50%;
  transform: translateY(-50%);
  color: #f1faee;
}

/* Input field styling */
.form-input {
  width: 87%;
  padding: 0.7rem 1rem;
  padding-left: 2.5rem;
  border: 1px solid #ffffff;
  border-radius: 0.375rem;
  font-size: 1rem;
  background-color: #9da09d; /* Dark blue-green */
  color: #f1faee;
}

.form-input::placeholder {
  color: #747c7c;
}

.form-input:focus {
  outline: none;
  box-shadow: 0 0 0 2px #2a9d8f;
  border-color: transparent;
}

/* Submit button styling */
.submit-button {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  padding: 0.5rem 1rem;
  background-color: #2464c4;
  color: #ffffff;
  border-radius: 0.375rem;
  font-size: 1rem;
  font-weight: 500;
  transition: background-color 0.3s;
}

.submit-button:hover {
  background-color: #457b9d;
}

.submit-button:focus {
  outline: none;
  box-shadow: 0 0 0 2px #2a9d8f, 0 0 0 4px rgba(42, 157, 143, 0.3);
}

.button-icon {
  margin-left: 0.5rem;
}

/* Footer styling */
.register-footer {
  padding: 1rem 1.5rem;
  background-color: #0f6016;
  border-top: 1px solid #2a9d8f;
}

.login-text {
  color: #f1faee;
  font-size: 0.875rem;
  text-align: center;
}

.link {
  color: #1d3557;
  text-decoration: none;
}

.link:hover {
  text-decoration: underline;
}

/* Message styling */
.message {
  margin-top: 1rem;
  font-size: 0.875rem;
  text-align: center;
  color: #ffffff;
  background-color: #457b9d;
  padding: 0.5rem 1rem;
  border-radius: 9999px;
}
</style>