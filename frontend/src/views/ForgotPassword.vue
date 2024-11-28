<template>
  <Navbar />
  <div class="app-container">
    <div class="forgot-password-card">
      <div class="forgot-password-content">
        <h2 class="forgot-password-title">Reset Password</h2>
        <div v-if="step === 1">
          <form @submit.prevent="sendResetOTP" class="forgot-password-form">
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
            <button type="submit" class="submit-button">
              Send OTP
              <ArrowRight class="button-icon" :size="20" />
            </button>
          </form>
        </div>
        <div v-if="step === 2">
          <form @submit.prevent="verifyOTP" class="forgot-password-form">
            <div class="form-group">
              <label for="otp" class="form-label">OTP</label>
              <div class="input-wrapper">
                <Lock class="input-icon" :size="20" />
                <input
                  id="otp"
                  v-model="otp"
                  type="text"
                  placeholder="Enter OTP"
                  required
                  class="form-input"
                />
              </div>
            </div>
            <button type="submit" class="submit-button">
              Verify OTP
              <ArrowRight class="button-icon" :size="20" />
            </button>
          </form>
          <p v-if="timeLeft > 0" class="mt-2 text-center text-sm text-gray-600">
            OTP expires in {{ formattedTimeLeft }}
          </p>
        </div>
        <div v-if="step === 3">
          <form @submit.prevent="resetPassword" class="forgot-password-form">
            <div class="form-group">
              <label for="newPassword" class="form-label">New Password</label>
              <div class="input-wrapper">
                <Lock class="input-icon" :size="20" />
                <input
                  id="newPassword"
                  v-model="newPassword"
                  type="password"
                  placeholder="Enter new password"
                  required
                  class="form-input"
                />
              </div>
            </div>
            <div class="form-group">
              <label for="confirmPassword" class="form-label">Confirm Password</label>
              <div class="input-wrapper">
                <Lock class="input-icon" :size="20" />
                <input
                  id="confirmPassword"
                  v-model="confirmPassword"
                  type="password"
                  placeholder="Confirm new password"
                  required
                  class="form-input"
                />
              </div>
            </div>
            <button type="submit" class="submit-button">
              Reset Password
              <ArrowRight class="button-icon" :size="20" />
            </button>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue';
import { useRouter } from 'vue-router';
import { Mail, Lock, ArrowRight } from 'lucide-vue-next';
import Navbar from '../components/Navbar.vue';
import axios from 'axios';

const router = useRouter();
const step = ref(1);
const email = ref('');
const otp = ref('');
const newPassword = ref('');
const confirmPassword = ref('');
const timeLeft = ref(300); // 5 minutes in seconds

const sendResetOTP = async () => {
  try {
    const response = await axios.post('http://localhost:5000/forgot-password', { email: email.value });
    console.log('Server response:', response.data);
    alert(response.data.message);
    step.value = 2;
    startCountdown();
  } catch (error) {
    console.error('Error in sendResetOTP:', error);
    alert(error.response?.data?.message || 'An error occurred');
  }
};

const startCountdown = () => {
  const countdown = setInterval(() => {
    if (timeLeft.value > 0) {
      timeLeft.value--;
    } else {
      clearInterval(countdown);
    }
  }, 1000);
};

const formattedTimeLeft = computed(() => {
  const minutes = Math.floor(timeLeft.value / 60);
  const seconds = timeLeft.value % 60;
  return `${minutes}:${seconds < 10 ? '0' : ''}${seconds}`;
});

const verifyOTP = async () => {
  try {
    console.log('Verifying OTP:', otp.value);
    const response = await axios.post('http://localhost:5000/verify-reset-otp', { email: email.value, otp: otp.value });
    console.log('OTP verification response:', response.data);
    alert(response.data.message);
    step.value = 3;
  } catch (error) {
    console.error('Error in verifyOTP:', error);
    alert(error.response?.data?.message || 'An error occurred during OTP verification');
  }
};

const resetPassword = async () => {
  if (newPassword.value !== confirmPassword.value) {
    alert('Passwords do not match');
    return;
  }
  try {
    console.log('Resetting password for email:', email.value);
    const response = await axios.post('http://localhost:5000/reset-password', {
      email: email.value,
      otp: otp.value,
      newPassword: newPassword.value
    });
    console.log('Password reset response:', response.data);
    alert(response.data.message);
    router.push('/login');
  } catch (error) {
    console.error('Error in resetPassword:', error);
    alert(error.response?.data?.message || 'An error occurred during password reset');
  }
};
</script>

<style scoped>
/* Add your styles here if needed */
</style>