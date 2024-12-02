<template>
    <div>
      <Navbar :isLoggedIn="isLoggedIn" :username="username" :profilePicture="userInfo.profile_picture" />
      <div v-if="challenge">
        <h2>Empathy Challenge</h2>
        <div>
          <h3>Comment Challenge - Level {{ challenge.comment_level }}</h3>
          <p>Comment on {{ challenge.comment_level * 5 }} posts. Progress: {{ challenge.comments_count }} / {{ challenge.comment_level * 5 }}</p>
          <p v-if="challenge.comments_count >= challenge.comment_level * 5" class="completed">Completed</p>
          <p v-else>{{ challenge.comment_level * 5 - challenge.comments_count }} comments left to proceed to the next level.</p>
        </div>
        <div>
          <h3>Reaction Challenge - Level {{ challenge.reaction_level }}</h3>
          <p>React to {{ challenge.reaction_level * 5 }} posts. Progress: {{ challenge.reactions_count }} / {{ challenge.reaction_level * 5 }}</p>
          <p v-if="challenge.reactions_count >= challenge.reaction_level * 5" class="completed">Completed</p>
          <p v-else>{{ challenge.reaction_level * 5 - challenge.reactions_count }} reactions left to proceed to the next level.</p>
        </div>
        <br>
        <div>
          <p>Challenge Start Date: {{ new Date(challenge.start_date).toLocaleDateString() }}</p>
          <p>Challenge End Date: {{ new Date(challenge.end_date).toLocaleDateString() }}</p>
        </div>
        <br>
        <p v-if="challengeCompleted">You've already completed the challenge!</p>
        <p v-if="challenge.message" class="completed-message">{{ challenge.message }}</p>
        <br>
        <button @click="goToFeed">Go to Feed</button>
      </div>
    </div>
  </template>
  
  <script>
  import { ref, onMounted } from 'vue';
  import axios from 'axios';
  import { useRouter } from 'vue-router';
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
      const challenge = ref({
        comment_level: 1,
        comments_count: 0,
        reaction_level: 1,
        reactions_count: 0,
        start_date: '',
        end_date: '',
        message: '',
      });
      const challengeCompleted = ref(false);
      const router = useRouter();
  
      const fetchChallenge = async () => {
        try {
          const token = localStorage.getItem('token');
          const challengeResponse = await axios.get('http://localhost:5000/empathy-challenge', {
            headers: {
              Authorization: `Bearer ${token}`,
            },
          });
          challenge.value = challengeResponse.data;
  
          if (challenge.value.comment_level > 10 && challenge.value.reaction_level > 10) {
            challengeCompleted.value = true;
          }
  
          if (challenge.value.comments_count >= challenge.value.comment_level * 5 && challenge.value.reactions_count >= challenge.value.reaction_level * 5) {
            challenge.value.message = "Level for today was completed, please come back tomorrow for more levels.";
          }
        } catch (error) {
          console.error('Failed to fetch challenge:', error);
        }
      };
  
      const goToFeed = () => {
        router.push('/feed');
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
        goToFeed,
      };
    },
  };
  </script>
  
  <style scoped>
  .completed {
    border: 2px solid green;
    padding: 5px;
    display: inline-block;
    margin-top: 5px;
  }
  
  .completed-message {
    border: 2px solid blue;
    padding: 10px;
    display: inline-block;
    margin-top: 10px;
  }
  </style>