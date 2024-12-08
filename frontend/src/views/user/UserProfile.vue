<template>
  <div>
    <Navbar :isLoggedIn="isLoggedIn" :username="username" :profilePicture="userInfo.profile_picture" />
    
    <!-- Profile Section -->
    <div class="user-profile">
      <div class="profile-header">
        <div class="profile-picture-container">
          <img :src="profilePictureUrl" alt="Profile Picture" class="profile-image" />
        </div>
        <div class="profile-info">
          <h2>{{ userInfo.username }}</h2>
          <p class="profile-bio">{{ userInfo.program }} | {{ userInfo.gender }}</p>
          <button @click="goToEditProfile" class="edit-profile-btn">Edit Profile</button>
        </div>
      </div>
      
     <!-- User Information Section -->
    <div class="user-details">
      <p><strong>Student ID:</strong> {{ userInfo.student_id }}</p>
      <p><strong>Full Name:</strong> {{ fullName }}</p>
      <p><strong>Email:</strong> {{ userInfo.email }}</p>
      <p><strong>Birthdate:</strong> {{ userInfo.birthdate }}</p>
    </div>

      <!-- QR Code Section -->
      <div class="qr-section">
        <button @click="generateQRCode" class="generate-qr-btn">Generate Profile QR Code</button>
        <div v-if="qrCodeData" class="qr-code-container">
          <img :src="qrCodeData" alt="QR Code" class="qr-code" />
        </div>
      </div>
    </div>

    <!-- User Posts Section -->
    <div class="user-posts">
      <h2>Your Posts</h2>
      <div v-for="post in userPosts" :key="post.id" class="post">
        <div class="post-header">
          <img :src="post.profile_picture ? `http://localhost:5000${post.profile_picture}` : require('@/assets/defaultProfile.png')" alt="Post Author" class="post-profile-image" />
          <span class="author-name">{{ post.username }}</span>
          <span class="text-gray-500 ml-2 text-sm">{{ formatDate(post.created_at) }}</span>
          <span v-if="post.emotion" class="emotion-badge">{{ post.emotion }}</span>
          <button @click="openEditModal(post)" class="edit-post-btn">Edit</button>
        </div>
        <p class="post-content">{{ post.content }}</p>
      </div>
    </div>
    <Footer />

    <!-- Edit Post Modal -->
    <Modal v-if="showEditModal" :show="showEditModal" @close="closeEditModal">
      <h3>Edit Post</h3>
      <textarea v-model="editPostContent" rows="5" class="edit-post-textarea"></textarea>
      
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
import QRCode from 'qrcode';  // Import QRCode library

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
    const qrCodeData = ref(null);  // Store QR Code data

    const profilePictureUrl = computed(() => {
      if (userInfo.value.profile_picture) {
        return `http://localhost:5000${userInfo.value.profile_picture}`;
      }
      return require('@/assets/defaultProfile.png');
    });

    // Computed property to concatenate first name, middle name, and last name
    const fullName = computed(() => {
      return `${userInfo.value.firstname} ${userInfo.value.middlename} ${userInfo.value.lastname}`.trim();
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

    const generateQRCode = async () => {
      try {
        const url = `http://localhost:5000/user/${userInfo.value.student_id}`;  // URL to user profile
        const qrCodeUrl = await QRCode.toDataURL(url);  // Generate QR code
        qrCodeData.value = qrCodeUrl;  // Store QR code data
      } catch (error) {
        console.error('Error generating QR code:', error);
      }
    };

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
      fullName,  // Added the fullName to be returned
      formatDate,
      showEditModal,
      editPostContent,
      editPostEmotion,
      openEditModal,
      closeEditModal,
      saveEditPost,
      generateQRCode,
      qrCodeData,
    };
  },
};
</script>

<style scoped>

/* Main Profile Section */
.user-profile {
  background-color: #f4f4f9;
  padding: 30px;
  border-radius: 10px;
  box-shadow: 0 2px 15px rgba(0, 0, 0, 0.1);
  max-width: 900px;
  margin: 20px auto;
}


/* Profile Header with Image and Info */
.profile-header {
  display: flex;
  align-items: center;
  margin-bottom: 30px;
}

.profile-picture-container {
  width: 120px;
  height: 120px;
  border-radius: 50%;
  overflow: hidden;
  margin-right: 20px;
}

.profile-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.profile-info {
  flex: 1;
}

.profile-info h2 {
  margin: 0;
  font-size: 28px;
  color: #333;
}

.profile-bio {
  color: #777;
  font-size: 14px;
}

.edit-profile-btn {
  background-color: #0b7c51;
  color: white;
  padding: 10px 20px;
  border-radius: 5px;
  border: none;
  cursor: pointer;
  font-size: 16px;
  margin-top: 10px;
}

.edit-profile-btn:hover {
  background-color: #5eb417;
}

/* User Details Section */
.user-details p {
  font-size: 1.5rem;
  margin: 8px 0;
}

.user-details strong {
  color: #555;
}

/* QR Code Section */
.qr-section {
  margin-top: 30px;
  text-align: center;
}

.generate-qr-btn {
  background-color: #28a745;
  color: white;
  padding: 12px 25px;
  border-radius: 5px;
  border: none;
  cursor: pointer;
  font-size: 16px;
}

.generate-qr-btn:hover {
  background-color: #218838;
}

.qr-code-container {
  margin-top: 20px;
}

.qr-code {
  width: 150px;
  height: 150px;
  margin: 0 auto;
  display: block;
}

/* Posts Section */
.user-posts {
  background-color: #fff;
  padding: 20px;
  margin-top: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

.post {
  background-color: #fff;
  border: 1px solid #eee;
  border-radius: 8px;
  padding: 20px;
  margin-bottom: 20px;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
}

.post-header {
  display: flex;
  align-items: center;
  margin-bottom: 15px;
}

.post-profile-image {
  width: 45px;
  height: 45px;
  border-radius: 50%;
  object-fit: cover;
  margin-right: 10px;
}

.author-name {
  font-size: 18px;
  font-weight: bold;
  color: #333;
}

.text-gray-500 {
  color: #777;
}

.emotion-badge {
  background-color: #f0f9f0;
  color: #3e8e41;
  padding: 5px 10px;
  border-radius: 15px;
  font-size: 12px;
  margin-left: 10px;
}

.edit-post-btn {
  background-color: #007bff;
  color: white;
  padding: 6px 12px;
  border-radius: 5px;
  border: none;
  cursor: pointer;
  font-size: 14px;
  margin-left: auto;
}

.edit-post-btn:hover {
  background-color: #0056b3;
}

.post-content {
  font-size: 16px;
  color: #333;
  line-height: 1.6;
}

/* Edit Post Modal */
.edit-post-textarea,
.edit-post-select {
  width: 100%;
  padding: 10px;
  margin: 10px 0;
  border: 1px solid #ddd;
  border-radius: 5px;
}

.save-edit-btn {
  background-color: #28a745;
  color: white;
  padding: 10px 20px;
  border-radius: 5px;
  border: none;
  cursor: pointer;
  font-size: 16px;
}

.save-edit-btn:hover {
  background-color: #218838;
}
</style>