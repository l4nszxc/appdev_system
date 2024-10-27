<template>
  <div class="app-container">
    <div class="register-card">
      <div class="register-content">
        <h2 class="register-title">CREATE AN ACCOUNT</h2>
        <form @submit.prevent="register" class="register-form">
          <!-- Username Field -->
          <div class="form-group">
            <label for="username" class="form-label">Username</label>
            <div class="input-wrapper">
              <User class="input-icon" :size="20" />
              <input
                id="username"
                v-model="username"
                placeholder="Username"
                required
                class="form-input"
              />
            </div>
          </div>

          <!-- First, Middle, and Last Name Fields in Column Layout -->
          <div class="form-group">
            <label for="firstname" class="form-label">First Name</label>
            <input
              id="firstname"
              v-model="firstname"
              placeholder="First Name"
              required
              class="form-input"
            />
          </div>

          <div class="form-group">
            <label for="middlename" class="form-label">Middle Name</label>
            <input
              id="middlename"
              v-model="middlename"
              placeholder="Middle Name"
              class="form-input"
            />
          </div>

          <div class="form-group">
            <label for="lastname" class="form-label">Last Name</label>
            <input
              id="lastname"
              v-model="lastname"
              placeholder="Last Name"
              required
              class="form-input"
            />
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
            <UserPlus class="button-icon" :size="20" />
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
    <p v-if="message" class="message">{{ message }}</p>
  </div>
</template>


<script setup>
import { ref } from 'vue'
import { User, Mail, Lock, UserPlus } from 'lucide-vue-next'
import axios from 'axios'

const username = ref('')
const firstname = ref('')
const middlename = ref('')
const lastname = ref('')
const email = ref('')
const password = ref('')
const confirmPassword = ref('')
const message = ref('')

const register = async () => {
  try {
    const response = await axios.post('http://localhost:5000/register', {
      username: username.value,
      firstname: firstname.value,
      middlename: middlename.value,
      lastname: lastname.value,
      email: email.value,
      password: password.value,
      confirmPassword: confirmPassword.value
    })
    message.value = response.data.message
  } catch (error) {
    message.value = error.response.data.message || 'Registration failed'
  }
}
</script>
<style scoped>
.app-container {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(to bottom right, #1a1a2e, #16213e);
  padding: 1rem;
}

.register-card {
  width: 100%;
  max-width: 32rem;
  background-color: #0f3460;
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

.register-title {
  font-size: 1.5rem;
  font-weight: bold;
  text-align: center;
  color: #e94560;
  margin-bottom: 1.5rem;
}

.register-form {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.form-row {
  display: flex;
  gap: 1rem;
  flex-wrap: wrap;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
  flex: 1;
  min-width: 0;
}

.form-label {
  font-size: 0.875rem;
  font-weight: 500;
  color: #a5b1c2;
}

.input-wrapper {
  position: relative;
}

.input-icon {
  position: absolute;
  left: 0.75rem;
  top: 50%;
  transform: translateY(-50%);
  color: #a5b1c2;
}

.form-input {
  width: 87%;
  padding: 0.7rem 1rem;
  padding-left: 2.5rem; /* Maintain padding for icons */
  border: 1px solid #2c3e50;
  border-radius: 0.375rem;
  font-size: 1rem;
  background-color: #1e3a5f;
  color: #ffffff;
}

.form-input::placeholder {
  color: #718096;
}

.form-input:focus {
  outline: none;
  box-shadow: 0 0 0 2px #e94560;
  border-color: transparent;
}

.submit-button {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  padding: 0.5rem 1rem;
  background-color: #e94560;
  color: white;
  border-radius: 0.375rem;
  font-size: 1rem;
  font-weight: 500;
  transition: background-color 0.3s;
}

.submit-button:hover {
  background-color: #d63553;
}

.submit-button:focus {
  outline: none;
  box-shadow: 0 0 0 2px #e94560, 0 0 0 4px rgba(233, 69, 96, 0.3);
}

.button-icon {
  margin-left: 0.5rem;
}

.register-footer {
  padding: 1rem 1.5rem;
  background-color: #16213e;
  border-top: 1px solid #2c3e50;
}

.login-text {
  color: #a5b1c2;
  font-size: 0.875rem;
  text-align: center;
}

.link {
  color: #e94560;
  text-decoration: none;
}

.link:hover {
  text-decoration: underline;
}

.message {
  margin-top: 1rem;
  font-size: 0.875rem;
  text-align: center;
  color: #ffffff;
  background-color: #1e3a5f;
  padding: 0.5rem 1rem;
  border-radius: 9999px;
}
</style>