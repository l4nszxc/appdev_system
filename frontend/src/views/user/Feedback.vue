<template>
    <div>
      <Navbar :isLoggedIn="isLoggedIn" :username="username" />
      <div class="max-w-md mx-auto mt-8">
        <h2 class="text-3xl font-bold mb-8 text-center">Send Feedback</h2>
        <form @submit.prevent="submitForm" class="space-y-4">
          <div>
            <label for="name" class="block mb-1 font-medium">Name</label>
            <input v-model="form.name" type="text" id="name" required class="w-full px-3 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-primary" />
          </div>
          <div>
            <label for="email" class="block mb-1 font-medium">Email</label>
            <input v-model="form.email" type="email" id="email" required class="w-full px-3 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-primary" />
          </div>
          <div>
            <label for="message" class="block mb-1 font-medium">Message</label>
            <textarea v-model="form.message" id="message" required rows="4" class="w-full px-3 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-primary"></textarea>
          </div>
          <button type="submit" class="w-full px-4 py-2 bg-primary text-white rounded-md hover:bg-primary-dark transition-colors">
            Send Message
          </button>
        </form>
        <div v-if="submitStatus" :class="['mt-4 p-4 rounded-md', submitStatus.success ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700']">
          {{ submitStatus.message }}
        </div>
      </div>
    </div>
  </template>
  
  <script>
  import { ref, onMounted } from 'vue';
  import axios from 'axios';
  import Navbar from '@/components/Navbar.vue'; // Import the Navbar component
  
  export default {
    name: 'Feedback',
    components: {
      Navbar, // Register the Navbar component
    },
    setup() {
      const form = ref({
        name: '',
        email: '',
        message: ''
      });
  
      const submitStatus = ref(null);
      const isLoggedIn = ref(false);
      const username = ref('');
  
      // Check login status on component mount
      onMounted(() => {
        isLoggedIn.value = localStorage.getItem('isLoggedIn') === 'true';
        username.value = localStorage.getItem('username') || '';
      });
  
      const submitForm = async () => {
        try {
          const response = await axios.post('http://localhost:3000/api/feedback', form.value);
          if (response.data.success) {
            submitStatus.value = { success: true, message: 'Message sent successfully!' };
            form.value = { name: '', email: '', message: '' };
          }
        } catch (error) {
          console.error('Error submitting form:', error);
          submitStatus.value = { success: false, message: 'An error occurred. Please try again.' };
        }
      };
  
      return {
        form,
        submitStatus,
        submitForm,
        isLoggedIn,
        username
      };
    }
  };
  </script>
  
  <style scoped>
  /* Add any additional styles you want here */
  </style>