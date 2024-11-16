<template>
    <div>
      <Navbar :isLoggedIn="isLoggedIn" :username="username" />
      <div class="update-profile">
        <h2>Update Profile</h2>
        <form @submit.prevent="updateProfile">
          <div>
            <label for="username">Username:</label>
            <input
              type="text"
              id="username"
              v-model="userInfo.username"
              required
            />
          </div>
          <div>
            <label for="firstname">First Name:</label>
            <input
              type="text"
              id="firstname"
              v-model="userInfo.firstname"
              required
            />
          </div>
          <div>
            <label for="middlename">Middle Name:</label>
            <input
              type="text"
              id="middlename"
              v-model="userInfo.middlename"
            />
          </div>
          <div>
            <label for="lastname">Last Name:</label>
            <input
              type="text"
              id="lastname"
              v-model="userInfo.lastname"
              required
            />
          </div>
          <div>
            <label for="gender">Gender:</label>
            <select id="gender" v-model="userInfo.gender" required>
              <option value="Male">Male</option>
              <option value="Female">Female</option>
              <option value="Other">Other</option>
            </select>
          </div>
          <div>
            <label for="birthdate">Birthdate:</label>
            <input
              type="date"
              id="birthdate"
              v-model="userInfo.birthdate"
              required
            />
          </div>
          <div>
            <label for="program">Program:</label>
            <input
              type="text"
              id="program"
              v-model="userInfo.program"
              required
            />
          </div>
          <button type="submit" class="update-btn" :disabled="isUpdating">
            {{ isUpdating ? 'Updating...' : 'UPDATE' }}
          </button>
        </form>
        <div v-if="updateMessage" :class="['message', updateMessage.type]">
          {{ updateMessage.text }}
        </div>
      </div>
    </div>
  </template>
  
  <script>
  import { ref, onMounted } from 'vue';
  import { useRouter } from 'vue-router';
  import Navbar from '../../components/Navbar.vue';
  import axios from 'axios';
  
  export default {
    name: 'UpdateUserProfile',
    components: {
      Navbar,
    },
    setup() {
      const isLoggedIn = ref(false);
      const username = ref('');
      const userInfo = ref({
        student_id: '',
        username: '',
        email: '',
        firstname: '',
        middlename: '',
        lastname: '',
        gender: '',
        birthdate: '',
        program: ''
      });
      const router = useRouter();
      const isUpdating = ref(false);
      const updateMessage = ref(null);
  
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
            // Ensure the date is in the correct format for the input
            if (userInfo.value.birthdate) {
              userInfo.value.birthdate = new Date(userInfo.value.birthdate).toISOString().split('T')[0];
            }
          } catch (error) {
            console.error('Failed to fetch user details:', error);
            updateMessage.value = { type: 'error', text: 'Failed to fetch user details. Please try again later.' };
          }
        }
      });
  
      const updateProfile = async () => {
        isUpdating.value = true;
        updateMessage.value = null;
        try {
          const token = localStorage.getItem('token');
          const response = await axios.put('http://localhost:5000/user', userInfo.value, {
            headers: {
              Authorization: `Bearer ${token}`,
            },
          });
          updateMessage.value = { type: 'success', text: 'Profile updated successfully!' };
          localStorage.setItem('username', userInfo.value.username);
          setTimeout(() => {
            router.push('/user/userprofile');
          }, 2000);
        } catch (error) {
          console.error('Failed to update profile:', error);
          if (error.response && error.response.data.error === 'Username already taken') {
            updateMessage.value = { type: 'error', text: 'Username already taken. Please choose a different username.' };
          } else {
            updateMessage.value = { type: 'error', text: 'Failed to update profile. Please try again.' };
          }
        } finally {
          isUpdating.value = false;
        }
      };
  
      return {
        isLoggedIn,
        username,
        userInfo,
        updateProfile,
        isUpdating,
        updateMessage,
      };
    },
  };
  </script>
  
  <style scoped>
  .update-profile {
    padding: 20px;
    background-color: #f9f9f9;
    border-radius: 10px;
    max-width: 600px;
    margin: 20px auto;
  }
  form div {
    margin-bottom: 15px;
  }
  label {
    display: block;
    margin-bottom: 5px;
  }
  input, select {
    width: 100%;
    padding: 8px;
    border: 1px solid #ddd;
    border-radius: 4px;
  }
  .update-btn {
    background-color: #0f6016;
    color: white;
    padding: 10px 20px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    font-size: 16px;
  }
  .update-btn:hover:not(:disabled) {
    background-color: #0d4f12;
  }
  .update-btn:disabled {
    background-color: #ccc;
    cursor: not-allowed;
  }
  .message {
    margin-top: 15px;
    padding: 10px;
    border-radius: 5px;
  }
  .message.error {
    background-color: #ffebee;
    color: #c62828;
  }
  .message.success {
    background-color: #e8f5e9;
    color: #2e7d32;
  }
  </style>