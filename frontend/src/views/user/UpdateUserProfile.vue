<template>
  <div>
    <Navbar :isLoggedIn="isLoggedIn" :username="username" :profilePicture="userInfo.profile_picture" />
    <div class="update-profile">
      <h2>Update Profile</h2>
      <div class="profile-picture-container">
        <div class="profile-picture">
          <img :src="profilePictureUrl" alt="Profile Picture" class="profile-image" />
        </div>
        <div class="upload-button-container">
          <input type="file" @change="handleFileUpload" accept="image/*" ref="fileInput" style="display: none;" />
          <button @click="$refs.fileInput.click()" class="upload-btn">
            Upload New Picture
          </button>
        </div>
      </div>
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
  <Footer />
</template>

<script>
import { ref, onMounted, computed } from 'vue';
import { useRouter } from 'vue-router';
import Navbar from '../../components/Navbar.vue';
import axios from 'axios';
import Footer from "@/components/Footer.vue";

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
      program: '',
      profile_picture: ''
    });
    const router = useRouter();
    const isUpdating = ref(false);
    const updateMessage = ref(null);
    const fileInput = ref(null);

    const profilePictureUrl = computed(() => {
      if (userInfo.value.profile_picture) {
        return `http://localhost:5000${userInfo.value.profile_picture}`;
      }
      return require('@/assets/defaultProfile.png');
    });

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

    const handleFileUpload = async (event) => {
      const file = event.target.files[0];
      if (!file) return;

      const formData = new FormData();
      formData.append('profilePicture', file);

      try {
        const token = localStorage.getItem('token');
        const response = await axios.post('http://localhost:5000/user/profile-picture', formData, {
          headers: {
            'Content-Type': 'multipart/form-data',
            Authorization: `Bearer ${token}`,
          },
        });
        if (response.data && response.data.path) {
          userInfo.value.profile_picture = response.data.path;
          updateMessage.value = { type: 'success', text: 'Profile picture updated successfully!' };
        } else {
          throw new Error('Invalid response from server');
        }
      } catch (error) {
        console.error('Failed to upload profile picture:', error);
        updateMessage.value = { type: 'error', text: 'Failed to upload profile picture. Please try again.' };
      }
    };

    return {
      isLoggedIn,
      username,
      userInfo,
      updateProfile,
      isUpdating,
      updateMessage,
      profilePictureUrl,
      handleFileUpload,
      fileInput,
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
.profile-picture-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-bottom: 20px;
}
.profile-picture {
  width: 150px;
  height: 150px;
  border-radius: 50%;
  overflow: hidden;
  margin-bottom: 10px;
}
.profile-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
}
.upload-button-container {
  text-align: center;
}
.upload-btn {
  background-color: #0f6016;
  color: white;
  padding: 8px 16px;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  font-size: 14px;
  transition: background-color 0.3s;
}
.upload-btn:hover {
  background-color: #0d4f12;
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
  width: 100%;
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