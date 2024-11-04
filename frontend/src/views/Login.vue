<template>
  <Navbar />
  <div class="app-container">
    <div class="login-card">
      <div class="login-content">
        <h2 class="login-title">Sign in to your account</h2>
        <form @submit.prevent="handleSubmit" class="login-form">
          <div class="form-group">
            <label for="email" class="form-label">Email</label>
            <div class="input-wrapper">
              <Mail class="input-icon" :size="20" />
              <input
                id="email"
                v-model="email"
                type="email"
                placeholder="Enter your email"
                required
                class="form-input"
              />
            </div>
          </div>
          <div class="form-group">
            <label for="password" class="form-label">Password</label>
            <div class="input-wrapper">
              <Lock class="input-icon" :size="20" />
              <input
                id="password"
                v-model="password"
                type="password"
                placeholder="Enter your password"
                required
                class="form-input"
              />
            </div>
          </div>
          <button type="submit" class="submit-button">
            Sign in
            <ArrowRight class="button-icon" :size="20" />
          </button>
        </form>
      </div>
      <div class="login-footer">
        <div class="footer-links">
          <p class="signup-text">
            Don't have an account?
            <router-link to="/register" class="link">Sign up</router-link>
          </p>
          <router-link to="/forgot-password" class="link">Forgot password?</router-link>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { Mail, Lock, ArrowRight } from 'lucide-vue-next';
import Navbar from '../components/Navbar.vue';
import axios from 'axios';

const email = ref('');
const password = ref('');
const isLoggedIn = ref(false); // State to track login status
const router = useRouter();

const handleSubmit = async () => {
  try {
    const response = await axios.post('http://localhost:5000/login', {
      email: email.value,
      password: password.value,
    });
    alert(response.data.message); // Success notification
    localStorage.setItem('token', response.data.token);
    localStorage.setItem('isLoggedIn', 'true'); // Set login flag
    isLoggedIn.value = true;
    router.push({ name: 'userHome' }); // Redirect to user home page
  } catch (error) {
    alert(error.response.data.message || 'An error occurred'); // Error notification
  }
};

// Check login status on component mount
onMounted(() => {
  isLoggedIn.value = localStorage.getItem('isLoggedIn') === 'true';
});
</script>

<style scoped>
/* Main container with background gradient */
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

/* Login card styling */
.login-card {
  width: 100%;
  max-width: 28rem;
  background-color: #4b8f5f; /* Calming green */
  border-radius: 0.5rem;
  box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.3), 0 10px 10px -5px rgba(0, 0, 0, 0.2);
  overflow: hidden;
  margin-top: 2rem;
}

.login-content {
  padding: 1.5rem;
}

@media (min-width: 640px) {
  .login-content {
    padding: 2rem;
  }
}

/* Title styling */
.login-title {
  font-size: 1.5rem;
  font-weight: bold;
  text-align: center;
  color: #ffffff;
  margin-bottom: 1.5rem;
}

/* Form layout */
.login-form {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

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
  width: 85%;
  padding: 0.5rem 1rem 0.5rem 2.5rem;
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
.login-footer {
  padding: 1rem 1.5rem;
  background-color: #457b9d;
  border-top: 1px solid #2a9d8f;
}

.footer-links {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.5rem;
  font-size: 0.875rem;
}

.signup-text {
  color: #f1faee;
}

.link {
  color: #1d3557;
  text-decoration: none;
}

.link:hover {
  text-decoration: underline;
}
</style>
