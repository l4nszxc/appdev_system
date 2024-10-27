<template>
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
    <p v-if="message" class="message">{{ message }}</p>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { Mail, Lock, ArrowRight } from 'lucide-vue-next'

const email = ref('')
const password = ref('')
const message = ref('')

const handleSubmit = async () => {
  try {
    // Simulating API call
    await new Promise(resolve => setTimeout(resolve, 1000))
    message.value = 'Login successful!'
  } catch (error) {
    message.value = 'Login failed. Please try again.'
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

.login-card {
  width: 100%;
  max-width: 28rem;
  background-color: #0f3460;
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
  color: #e94560;
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
  width: 85%;
  padding: 0.5rem 1rem 0.5rem 2.5rem;
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

.login-footer {
  padding: 1rem 1.5rem;
  background-color: #16213e;
  border-top: 1px solid #2c3e50;
}

.footer-links {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.5rem;
  font-size: 0.875rem;
}

.signup-text {
  color: #a5b1c2;
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