
<template>
  <Navbar />
  <div class="app-container">
    <div class="login-card">
      <div class="login-content">
        <h2 class="login-title">LOG IN</h2>
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
            Log In
            <ArrowRight class="button-icon" :size="20" />
          </button>
          <button @click="authenticateWithFingerprint" type="button" class="fingerprint-button">
            <FingerprintIcon :size="20" class="fingerprint-icon" />
            Login with Fingerprint
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
    <div v-if="isLoggedIn" class="welcome-message">
      Logged in as: {{ username }} <!-- Use local state instead -->
    </div>
  </div>
</template>

<script setup>
<<<<<<< HEAD

import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { Mail, Lock, ArrowRight, FingerprintIcon } from 'lucide-vue-next';
import Navbar from '../components/Navbar.vue';
import axios from 'axios'
=======
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { Mail, Lock, ArrowRight } from 'lucide-vue-next';
import Navbar from '../components/Navbar.vue';
import axios from 'axios';
>>>>>>> 0f2941a0bc1337b7083106f0e75ce9460af8ff9e

const email = ref('');
const password = ref('');
const isLoggedIn = ref(false); // State to track login status
const username = ref(''); // State for username
const router = useRouter();

const handleSubmit = async () => {
  try {
    const response = await axios.post('http://localhost:5000/login', {
      email: email.value,
      password: password.value,
    });
    alert(response.data.message); // Success notification
    localStorage.setItem('token', response.data.token);
    localStorage.setItem('username', response.data.username);  // Store username
    localStorage.setItem('isLoggedIn', 'true'); // Set login flag
    isLoggedIn.value = true;
    username.value = response.data.username; // Store username in local state
    router.push({ name: 'userHome' }); // Redirect to user home page
  } catch (error) {
    alert(error.response?.data?.message || 'An error occurred');
  }
};

<<<<<<< HEAD
const authenticateWithFingerprint = async () => {
  if (!window.PublicKeyCredential) {
    alert('Your browser does not support fingerprint authentication.');
    return;
  }

  try {
    const response = await axios.post('http://localhost:5000/auth/fingerprint/start');
    const options = response.data;

    const credential = await navigator.credentials.get(options);

    const result = await axios.post('http://localhost:5000/auth/fingerprint/finish', {
      id: credential.id,
      rawId: Array.from(new Uint8Array(credential.rawId)),
      response: {
        authenticatorData: Array.from(new Uint8Array(credential.response.authenticatorData)),
        clientDataJSON: Array.from(new Uint8Array(credential.response.clientDataJSON)),
        signature: Array.from(new Uint8Array(credential.response.signature))
      },
      type: credential.type
    });

    if (result.data.success) {
      alert('Fingerprint authentication successful!');
      localStorage.setItem('token', result.data.token);
      router.push({ name: 'userHome' });
    } else {
      alert('Fingerprint authentication failed.');
    }
  } catch (error) {
    console.error('Fingerprint authentication error:', error);
    alert('An error occurred during fingerprint authentication.');
  }
};

=======
>>>>>>> 0f2941a0bc1337b7083106f0e75ce9460af8ff9e
// Check login status on component mount
onMounted(() => {
  isLoggedIn.value = localStorage.getItem('isLoggedIn') === 'true';
  username.value = localStorage.getItem('username') || ''; // Retrieve username safely
});
</script>

<style scoped>
.app-container {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: flex-start;
  background-image: url('../assets/bg minsu.png');
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  padding-top: 80px;
}

.login-card {
  width: 100%;
<<<<<<< HEAD
  max-width: 32rem; /* Use the desired max-width */
=======
  max-width: 32rem;
>>>>>>> 0f2941a0bc1337b7083106f0e75ce9460af8ff9e
  background-color: #128535; /* Soft green background */
  border-radius: 0.5rem;
  box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.3), 0 10px 10px -5px rgba(0, 0, 0, 0.2);
  overflow: hidden;
}

.login-content {
  padding: 1.5rem;
}

@media (min-width: 640px) {
  .login-content {
    padding: 2rem;
  }
}

.login-title {
  font-size: 1.5rem;
  font-weight: bold;
  text-align: center;
  color: #ffffff;
  margin-bottom: 1.5rem;
}

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

.form-input {
  width: 85%;
  padding: 0.5rem 1rem 0.5rem 2.5rem;
  border: 1px solid #ffffff;
  border-radius: 0.375rem;
  font-size: 1rem;
  background-color: #9da09d;
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

.login-footer {
  padding: 1rem 1.5rem;
<<<<<<< HEAD
  background-color: #0f6016; /* Soft green background */
  border-top: 1px solid #2a9d8f; /* Solid border for the top */
}
=======
  background-color: #0f6016;
  border-top: 1px solid #2a9d8f;}
>>>>>>> 0f2941a0bc1337b7083106f0e75ce9460af8ff9e

 .fingerprint-button {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  padding: 0.5rem 1rem;
  background-color: #4CAF50; /* Original background color */
  color: white;
  border: none;
  border-radius: 0.375rem;
  font-size: 1rem;
  cursor: pointer;
  transition: background-color 0.3s;
}
  .footer-links {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 100%;
  padding: 0.5rem 1rem;
  margin-top: 1rem;
  background-color: #4CAF50;
  color: white;
  border: none;
  border-radius: 0.375rem;
  font-size: 1rem;
  cursor: pointer;
  transition: background-color 0.3s;
}

.fingerprint-button:hover {
  background-color: #45a049;
}

.fingerprint-icon {
  margin-right: 0.5rem;
}
.link:hover {
  text-decoration: underline; /* Underline on hover */
}

/* Welcome message styling */
.welcome-message {
  margin-top: 1rem;
  font-size: 1rem;
  color: #f1faee; /* Adjust color as needed */
}
<<<<<<< HEAD
</style>
=======
</style>
>>>>>>> 0f2941a0bc1337b7083106f0e75ce9460af8ff9e
