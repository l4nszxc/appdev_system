UserProf

<template>
  <div>
    <Navbar :isLoggedIn="isLoggedIn" :username="username" :profilePicture="userInfo.profile_picture" />
    
    <!-- User Profile Section -->
    <div class="profile-container">
      <div class="profile-header">
        <h2 class="profile-title">User Profile</h2>
      </div>
      <div class="profile-content">
        <!-- Profile Picture Section -->
        <div class="profile-picture">
          <img :src="profilePictureUrl" alt="Profile Picture" class="profile-image" />
        </div>
        
        <!-- User Info Section -->
        <div class="profile-details">
          <p><strong>Student ID:</strong> {{ userInfo.student_id }}</p>
          <p><strong>Username:</strong> {{ userInfo.username }}</p>
          <p><strong>Email:</strong> {{ userInfo.email }}</p>
          <p><strong>First Name:</strong> {{ userInfo.firstname }}</p>
          <p><strong>Middle Name:</strong> {{ userInfo.middlename }}</p>
          <p><strong>Last Name:</strong> {{ userInfo.lastname }}</p>
          <p><strong>Gender:</strong> {{ userInfo.gender }}</p>
          <p><strong>Birthdate:</strong> {{ userInfo.birthdate }}</p>
          <p><strong>Program:</strong> {{ userInfo.program }}</p>
        </div>

        <!-- Edit Profile Button -->
        <button @click="goToEditProfile" class="edit-profile-btn">EDIT PROFILE</button>

        <!-- User Posts Section -->
        <div v-if="posts.length > 0" class="user-posts">
          <h3>User Posts</h3>
          <div v-for="(post, index) in posts" :key="index" class="post">
            <p><strong>{{ post.username }}</strong> - {{ post.date }}</p>
            <p>{{ post.content }}</p>
          </div>
        </div>
        
      </div>
    </div>
    
    <Footer />
  </div>
</template>

<script>
import { ref, onMounted, computed } from 'vue';
import { useRouter } from 'vue-router';
import Navbar from '../../components/Navbar.vue';
import axios from 'axios';
import Footer from "@/components/Footer.vue";
export default {
  name: 'UserProfile',
  components: {
    Navbar,
    Footer,
  },
  setup() {
    const isLoggedIn = ref(false);
    const username = ref('');
    const userInfo = ref({});
    const posts = ref([]);  // To store user posts
    const router = useRouter();

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
          const userResponse = await axios.get('http://localhost:5000/user', {
            headers: {
              Authorization: `Bearer ${token}`,
            },
          });
          userInfo.value = userResponse.data;

          // Fetch posts for the user
          const postsResponse = await axios.get('http://localhost:5000/user/posts', {
            headers: {
              Authorization: `Bearer ${token}`,
            },
          });
          posts.value = postsResponse.data;

        } catch (error) {
          console.error('Failed to fetch user details or posts:', error);
          alert('Failed to fetch user details or posts. Please try again later.');
        }
      }
    });

    const goToEditProfile = () => {
      router.push('/update-profile');
    };

    return {
      isLoggedIn,
      username,
      userInfo,
      posts,  // Bind the posts data to template
      goToEditProfile,
      profilePictureUrl,
    };
  },
};
</script>

<style scoped>
.profile-container {
  padding: 30px;
  background-color: #f4f6f9;
  border-radius: 15px;
  max-width: 700px;
  margin: 30px auto;
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
}

.profile-header {
  text-align: center;
  margin-bottom: 30px;
}

.profile-title {
  font-size: 2.5em;
  font-weight: 600;
  color: #333;
}

.profile-content {
  background-color: #fff;
  padding: 20px;
  border-radius: 10px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.profile-picture {
  width: 150px;
  height: 150px;
  margin: 0 auto 20px;
  border-radius: 50%;
  overflow: hidden;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.2);
}

.profile-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.profile-details {
  font-size: 1.1em;
  color: #555;
}

.profile-details p {
  margin-bottom: 10px;
}

.profile-details strong {
  color: #333;
}

.edit-profile-btn {
  background-color: #0f6016;
  color: white;
  padding: 12px 25px;
  border: none;
  border-radius: 25px;
  cursor: pointer;
  font-size: 1.2em;
  margin-top: 25px;
  width: 100%;
  transition: background-color 0.3s;
}

.edit-profile-btn:hover {
  background-color: #0d4f12;
}

.user-posts {
  margin-top: 30px;
}

.post {
  background-color: #f9f9f9;
  padding: 15px;
  margin-bottom: 15px;
  border-radius: 10px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.post p {
  margin: 5px 0;
}

.no-posts {
  color: #888;
  font-style: italic;
}

@media (max-width: 768px) {
  .profile-container {
    padding: 20px;
  }

  .profile-title {
    font-size: 2em;
  }

  .edit-profile-btn {
    font-size: 1.1em;
  }
}
</style>
