<template>
    <div>
      <Navbar :isLoggedIn="isLoggedIn" :username="username" :profilePicture="userInfo.profile_picture" />
      <div v-if="challenge">
        <h2>Empathy Challenge - Level {{ challenge.level }}</h2>
        <p>Comment on {{ challenge.level * 5 }} posts. Progress: {{ challenge.comments_count }} / {{ challenge.level * 5 }}</p>
        <p v-if="challengeCompleted">You've already completed the challenge!</p>
      </div>
    </div>
  </template>
  
  <script>
  import { ref, onMounted } from 'vue';
  import axios from 'axios';
  import Navbar from '@/components/Navbar.vue';
  
  export default {
    name: 'UserEmpathyC',
    components: {
      Navbar,
    },
    setup() {
      const isLoggedIn = ref(false);
      const username = ref('');
      const userInfo = ref({});
      const challenge = ref(null);
      const challengeCompleted = ref(false);
  
      const fetchChallenge = async () => {
        try {
          const token = localStorage.getItem('token');
          const challengeResponse = await axios.get('http://localhost:5000/empathy-challenge', {
            headers: {
              Authorization: `Bearer ${token}`,
            },
          });
          challenge.value = challengeResponse.data;
  
          if (challenge.value.level > 10) {
            challengeCompleted.value = true;
          }
        } catch (error) {
          console.error('Failed to fetch challenge:', error);
        }
      };
  
      onMounted(async () => {
        isLoggedIn.value = localStorage.getItem('isLoggedIn') === 'true';
        username.value = localStorage.getItem('username') || '';
  
        if (isLoggedIn.value) {
          try {
            const token = localStorage.getItem('token');
            const response = await axios.get('http://localhost:5000/user', {
              headers: {
                Authorization: `Bearer ${token}`,
              },
            });
            userInfo.value = response.data;
  
            await fetchChallenge();
          } catch (error) {
            console.error('Failed to fetch user details or challenge:', error);
          }
        }
      });
  
      return {
        isLoggedIn,
        username,
        userInfo,
        challenge,
        challengeCompleted,
      };
    },
  };
  </script>
  
  <style scoped>
  /* Add your styles here */
  </style>