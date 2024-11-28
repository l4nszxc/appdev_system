<template>
  <div class="min-h-screen flex items-center justify-center bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
    <div class="max-w-md w-full space-y-8">
      <div>
        <h2 class="mt-6 text-center text-3xl font-extrabold text-gray-900">Verify Your Email</h2>
        <p v-if="email" class="mt-2 text-center text-sm text-gray-600">
          Please enter the OTP sent to {{ email }}
        </p>
        <p v-else class="mt-2 text-center text-sm text-red-600">
          Email not found. Please try registering again.
        </p>
      </div>
      <form v-if="email" class="mt-8 space-y-6" @submit.prevent="verifyOTP">
        <div class="rounded-md shadow-sm -space-y-px">
          <div>
            <label for="otp" class="sr-only">OTP</label>
            <input
              id="otp"
              name="otp"
              type="text"
              required
              class="appearance-none rounded-md relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm"
              placeholder="Enter OTP"
              v-model="otp"
            />
          </div>
        </div>

        <div>
          <button
            type="submit"
            class="group relative w-full flex justify-center py-2 px-4 border border-transparent text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
          >
            Verify OTP
          </button>
        </div>
      </form>
      <p v-if="message" class="mt-2 text-center text-sm" :class="{'text-green-600': isSuccess, 'text-red-600': !isSuccess}">
        {{ message }}
      </p>
      <p v-if="timeLeft > 0" class="mt-2 text-center text-sm text-gray-600">
        OTP expires in {{ formattedTimeLeft }}
      </p>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useStore } from 'vuex'

const router = useRouter()
const store = useStore()

const otp = ref('')
const message = ref('')
const isSuccess = ref(false)
const timeLeft = ref(300) // 5 minutes in seconds

const email = computed(() => store.state.auth.email)

onMounted(() => {
  console.log('Email in OTP component:', email.value);
  if (!email.value) {
    console.error('Email not found in store');
    message.value = 'Email not found. Please try registering again.';
    isSuccess.value = false;
  } else {
    startCountdown();
  }
})

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
    if (!email.value) {
      throw new Error('Email not found');
    }

    const response = await fetch('http://localhost:5000/verify-otp', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ email: email.value, otp: otp.value }),
    });

    if (!response.ok) {
      const errorData = await response.json();
      throw new Error(errorData.message || 'Failed to verify OTP');
    }

    const data = await response.json();
    console.log('OTP verification response:', data);
    message.value = data.message;
    isSuccess.value = true;

    setTimeout(() => {
      router.push('/login');
    }, 2000);
  } catch (error) {
    console.error('Error verifying OTP:', error);
    message.value = error.message || 'An error occurred. Please try again.';
    isSuccess.value = false;
  }
};
</script>

<style scoped>
/* Add your styles here if needed */
</style>