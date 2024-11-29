<template>
  <div>
    <Navbar :isLoggedIn="isLoggedIn" :username="username" :profilePicture="userInfo.profile_picture" />
    <div class="user-profile">
      <h2>User Profile</h2>
      <div class="profile-picture">
        <img :src="profilePictureUrl" alt="Profile Picture" class="profile-image" />
      </div>
      <p><strong>Student ID:</strong> {{ userInfo.student_id }}</p>
      <p><strong>Username:</strong> {{ userInfo.username }}</p>
      <p><strong>Email:</strong> {{ userInfo.email }}</p>
      <p><strong>First Name:</strong> {{ userInfo.firstname }}</p>
      <p><strong>Middle Name:</strong> {{ userInfo.middlename }}</p>
      <p><strong>Last Name:</strong> {{ userInfo.lastname }}</p>
      <p><strong>Gender:</strong> {{ userInfo.gender }}</p>
      <p><strong>Birthdate:</strong> {{ userInfo.birthdate }}</p>
      <p><strong>Program:</strong> {{ userInfo.program }}</p>
      <button @click="goToEditProfile" class="edit-profile-btn">EDIT PROFILE</button>
    </div>
    <div class="user-posts">
      <h2>Your Posts</h2>
      <div v-for="post in userPosts" :key="post.id" class="post">
        <div class="post-header">
          <img :src="post.profile_picture ? `http://localhost:5000${post.profile_picture}` : require('@/assets/defaultProfile.png')" alt="Profile Picture" class="post-profile-image" />
          <span class="author-name">{{ post.username }}</span>
          <span class="text-gray-500 ml-2 text-sm">{{ formatDate(post.created_at) }}</span>
          <span v-if="post.emotion" class="ml-2 px-2 py-1 bg-green-100 text-green-800 rounded-full text-xs">{{ post.emotion }}</span>
          <button @click="openEditModal(post)" class="edit-post-btn">Edit</button>
        </div>
        <p class="post-content">{{ post.content }}</p>
      </div>
    </div>
    <Footer />
    <Modal v-if="showEditModal" :show="showEditModal" @close="closeEditModal">
      <h3>Edit Post</h3>
      <textarea v-model="editPostContent" rows="5" class="edit-post-textarea"></textarea>
      <select v-model="editPostEmotion" class="edit-post-select">
        <option value="Happy">Happy</option>
        <option value="Sad">Sad</option>
        <option value="Anxious">Anxious</option>
        <option value="Calm">Calm</option>
        <option value="Stressed">Stressed</option>
      </select>
      <button @click="saveEditPost" class="save-edit-btn">Save</button>
    </Modal>
  </div>
</template>

<script>
import { ref, onMounted, computed } from 'vue';
import { useRouter } from 'vue-router';
import Navbar from '../../components/Navbar.vue';
import axios from 'axios';
import Footer from "@/components/Footer.vue";
import Modal from "@/components/Modal.vue";

export default {
  name: 'UserProfile',
  components: {
    Navbar,
    Modal,
  },
  setup() {
    const isLoggedIn = ref(false);
    const username = ref('');
    const userInfo = ref({});
    const userPosts = ref([]);
    const router = useRouter();
    const showEditModal = ref(false);
    const editPostContent = ref('');
    const editPostEmotion = ref('');
    const currentPostId = ref(null);

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

          const postsResponse = await axios.get('http://localhost:5000/posts/user', {
            headers: {
              Authorization: `Bearer ${token}`,
            },
          });
          userPosts.value = postsResponse.data;
        } catch (error) {
          console.error('Failed to fetch user details or posts:', error);
          alert('Failed to fetch user details or posts. Please try again later.');
        }
      }
    });

    const goToEditProfile = () => {
      router.push('/update-profile');
    };

    const formatDate = (dateString) => {
      const date = new Date(dateString);
      return date.toLocaleString();
    };

    const openEditModal = (post) => {
      currentPostId.value = post.id;
      editPostContent.value = post.content;
      editPostEmotion.value = post.emotion;
      showEditModal.value = true;
    };

    const closeEditModal = () => {
      showEditModal.value = false;
    };

    const saveEditPost = async () => {
      try {
        const token = localStorage.getItem('token');
        await axios.put(`http://localhost:5000/posts/${currentPostId.value}`, {
          content: editPostContent.value,
          emotion: editPostEmotion.value,
        }, {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        });
        const updatedPost = userPosts.value.find(post => post.id === currentPostId.value);
        if (updatedPost) {
          updatedPost.content = editPostContent.value;
          updatedPost.emotion = editPostEmotion.value;
        }
        closeEditModal();
      } catch (error) {
        console.error('Failed to save edited post:', error);
        alert('Failed to save edited post. Please try again later.');
      }
    };

    return {
      isLoggedIn,
      username,
      userInfo,
      userPosts,
      goToEditProfile,
      profilePictureUrl,
      formatDate,
      showEditModal,
      editPostContent,
      editPostEmotion,
      openEditModal,
      closeEditModal,
      saveEditPost,
    };
  },
};
</script>

<style scoped>
.user-profile {
  padding: 20px;
  background-color: #f9f9f9;
  border-radius: 10px;
  max-width: 600px;
  margin: 20px auto;
}
.edit-profile-btn {
  background-color: #0f6016;
  color: white;
  padding: 10px 20px;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  font-size: 16px;
  margin-top: 20px;
}
.edit-profile-btn:hover {
  background-color: #0d4f12;
}
.profile-picture {
  width: 150px;
  height: 150px;
  margin: 0 auto 20px;
  border-radius: 50%;
  overflow: hidden;
}

.profile-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.user-posts {
  padding: 20px;
  background-color: #f9f9f9;
  border-radius: 10px;
  max-width: 600px;
  margin: 20px auto;
}

.post {
  background-color: white;
  border: 1px solid #ddd;
  border-radius: 5px;
  padding: 15px;
  margin-bottom: 20px;
}

.post-header {
  display: flex;
  align-items: center;
  margin-bottom: 10px;
}

.post-profile-image {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  margin-right: 10px;
  object-fit: cover;
}

.author-name {
  font-weight: bold;
}

.post-content {
  margin-bottom: 10px;
}

.edit-post-btn {
  margin-left: auto;
  background-color: #0f6016;
  color: white;
  padding: 5px 10px;
  border: none;
  border-radius: 5px;
  cursor: pointer;
}

.edit-post-btn:hover {
  background-color: #0d4f12;
}

.edit-post-textarea {
  width: 100%;
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 5px;
  resize: none;
  margin-bottom: 10px;
}

.edit-post-select {
  width: 100%;
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 5px;
  margin-bottom: 10px;
}

.save-edit-btn {
  background-color: #0f6016;
  color: white;
  padding: 10px 20px;
  border: none;
  border-radius: 5px;
  cursor: pointer;
}

.save-edit-btn:hover {
  background-color: #0d4f12;
}
</style>