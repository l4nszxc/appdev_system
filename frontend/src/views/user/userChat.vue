<template>
  <div>
    <Navbar :isLoggedIn="isLoggedIn" :username="username" :profilePicture="userInfo.profile_picture" />
    <div class="chat-container">
      <!-- Student List Section -->
      <div class="conversations-list">
        <h2>Student List</h2>
        <div class="search-container">
          <input 
            v-model="searchQuery" 
            placeholder="Search by name or student ID..." 
            class="search-input"
            @input="handleSearch"
          />
        </div>
        <div class="students-list">
          <div 
            v-for="student in displayedStudents" 
            :key="student.student_id"
            @click="selectStudent(student)"
            class="student-item"
            :class="{ 'selected': selectedUser?.student_id === student.student_id }"
          >
            <img 
              :src="getProfilePicture(student.profile_picture)" 
              class="student-avatar"
              alt="Profile"
            />
            <div class="student-info">
              <div class="student-name">
                {{ student.firstname }} {{ student.lastname }}
              </div>
              <div class="student-id">{{ student.student_id }}</div>
            </div>
          </div>
        </div>
      </div>

      <!-- Messages Section -->
      <div class="messages-list" v-if="selectedUser">
        <div class="messages-header">
          <div class="selected-user-info">
            <img 
              :src="getProfilePicture(selectedUser.profile_picture)" 
              class="selected-user-avatar"
              alt="Selected Profile"
            />
            <div>
              <h3>{{ selectedUser.firstname }} {{ selectedUser.lastname }}</h3>
              <span class="student-id">{{ selectedUser.student_id }}</span>
            </div>
          </div>
        </div>

        <div class="messages-container" ref="messagesContainer">
  <div 
    v-for="message in messages" 
    :key="message.id"
    :class="['message', message.sender_id === userInfo.student_id ? 'sent' : 'received']"
  >
    <div class="message-bubble">
      <div class="message-sender" v-if="message.sender_id !== userInfo.student_id">
        {{ message.firstname }} {{ message.lastname }}
      </div>
      <div class="message-content">{{ message.message }}</div>
      <div class="message-time">{{ formatTime(message.created_at) }}</div>
    </div>
  </div>
</div>

        <div class="message-input">
          <input 
            v-model="newMessage" 
            @keyup.enter="sendMessage"
            placeholder="Type a message..." 
          />
          <button @click="sendMessage" :disabled="!newMessage.trim()">
            Send
          </button>
        </div>
      </div>
      
      <div v-else class="no-chat-selected">
        <p>Select a student to start chatting</p>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, computed, onMounted, watch } from 'vue';
import axios from 'axios';
import Navbar from '@/components/Navbar.vue';

export default {
  name: 'UserChat',
  components: { Navbar },
  
  setup() {
    const searchQuery = ref('');
    const students = ref([]);
    const selectedUser = ref(null);
    const messages = ref([]);
    const newMessage = ref('');
    const userInfo = ref({});
    const isLoggedIn = ref(false);
    const username = ref('');
    const selectedConversationId = ref(null);
    const messagesContainer = ref(null);

    // Computed property for filtered students
    const displayedStudents = computed(() => {
      if (!searchQuery.value) return students.value;
      const query = searchQuery.value.toLowerCase();
      return students.value.filter(student => 
        student.student_id.toLowerCase().includes(query) ||
        `${student.firstname} ${student.lastname}`.toLowerCase().includes(query)
      );
    });

    // Handle search with debounce
    let searchTimeout;
    const handleSearch = () => {
      clearTimeout(searchTimeout);
      searchTimeout = setTimeout(fetchStudents, 300);
    };

    const fetchStudents = async () => {
      try {
        const token = localStorage.getItem('token');
        const response = await axios.get('http://localhost:5000/users/all', {
          headers: { Authorization: `Bearer ${token}` }
        });
        students.value = response.data.filter(student => 
          student.role !== 'admin' && 
          student.student_id !== userInfo.value?.student_id
        );
      } catch (error) {
        console.error('Failed to fetch students:', error);
      }
    };

    const selectStudent = async (student) => {
  selectedUser.value = student;
  try {
    const token = localStorage.getItem('token');
    // First check if conversation exists
    const response = await axios.get('http://localhost:5000/conversations', {
      headers: { Authorization: `Bearer ${token}` }
    });
    
    let conversation = response.data.find(conv => 
      (conv.student_id === userInfo.value.student_id && conv.participant_id === student.student_id) ||
      (conv.student_id === student.student_id && conv.participant_id === userInfo.value.student_id)
    );

    if (!conversation) {
      // Create new conversation if none exists
      const createResponse = await axios.post('http://localhost:5000/conversations', 
        { participantId: student.student_id },
        { headers: { Authorization: `Bearer ${token}` }}
      );
      selectedConversationId.value = createResponse.data.conversationId;
    } else {
      selectedConversationId.value = conversation.id;
    }
    
    await fetchMessages();
  } catch (error) {
    console.error('Failed to handle conversation:', error);
  }
};

    const fetchMessages = async () => {
      if (!selectedConversationId.value) return;
      try {
        const token = localStorage.getItem('token');
        const response = await axios.get(
          `http://localhost:5000/messages/${selectedConversationId.value}`,
          { headers: { Authorization: `Bearer ${token}` }}
        );
        messages.value = response.data;
        scrollToBottom();
      } catch (error) {
        console.error('Failed to fetch messages:', error);
      }
    };

    const sendMessage = async () => {
      if (!newMessage.value.trim() || !selectedConversationId.value) return;
      try {
        const token = localStorage.getItem('token');
        await axios.post('http://localhost:5000/messages', {
          conversationId: selectedConversationId.value,
          message: newMessage.value.trim()
        }, {
          headers: { Authorization: `Bearer ${token}` }
        });
        newMessage.value = '';
        await fetchMessages();
      } catch (error) {
        console.error('Failed to send message:', error);
      }
    };

    const scrollToBottom = () => {
      setTimeout(() => {
        if (messagesContainer.value) {
          messagesContainer.value.scrollTop = messagesContainer.value.scrollHeight;
        }
      }, 100);
    };

    const getProfilePicture = (profilePicture) => {
      return profilePicture 
        ? `http://localhost:5000${profilePicture}` 
        : require('@/assets/defaultProfile.png');
    };

    const formatTime = (timestamp) => {
      return new Date(timestamp).toLocaleTimeString([], { 
        hour: '2-digit', 
        minute: '2-digit' 
      });
    };

    // Initialize component
    onMounted(async () => {
      isLoggedIn.value = localStorage.getItem('isLoggedIn') === 'true';
      username.value = localStorage.getItem('username') || '';
      
      if (isLoggedIn.value) {
        try {
          const token = localStorage.getItem('token');
          const response = await axios.get('http://localhost:5000/user', {
            headers: { Authorization: `Bearer ${token}` }
          });
          userInfo.value = response.data;
          await fetchStudents();
        } catch (error) {
          console.error('Failed to fetch user details:', error);
        }
      }
    });

    // Watch for new messages to scroll to bottom
    watch(messages, scrollToBottom);

    return {
      searchQuery,
      displayedStudents,
      selectedUser,
      messages,
      newMessage,
      userInfo,
      isLoggedIn,
      username,
      handleSearch,
      selectStudent,
      sendMessage,
      getProfilePicture,
      formatTime,
      messagesContainer
    };
  }
};
</script>

<style scoped>
.chat-container {
  display: flex;
  gap: 20px;
  padding: 20px;
  height: calc(100vh - 100px);
}

.conversations-list, .messages-list {
  flex: 1;
  background: white;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  display: flex;
  flex-direction: column;
}

.search-container {
  margin-bottom: 15px;
}

.search-input {
  width: 100%;
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
}

.students-list {
  overflow-y: auto;
  flex-grow: 1;
}

.student-item {
  display: flex;
  align-items: center;
  padding: 10px;
  border-bottom: 1px solid #eee;
  cursor: pointer;
  transition: background-color 0.2s;
}

.student-item:hover {
  background-color: #f5f5f5;
}

.student-item.selected {
  background-color: #e8f5e9;
}

.student-avatar, .selected-user-avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  margin-right: 10px;
  object-fit: cover;
}

.student-info {
  flex-grow: 1;
}

.student-name {
  font-weight: bold;
}

.student-id {
  font-size: 0.8em;
  color: #666;
}

.messages-header {
  border-bottom: 1px solid #eee;
  padding-bottom: 15px;
  margin-bottom: 15px;
}

.selected-user-info {
  display: flex;
  align-items: center;
}

.messages-container {
  flex-grow: 1;
  overflow-y: auto;
  padding: 10px;
  margin: 10px 0;
}

.message {
  max-width: 70%;
  margin: 10px 0;
  position: relative;
}

.message-content {
  padding: 10px;
  border-radius: 10px;
}

.message.sent {
  margin-left: auto;
}

.message.sent .message-content {
  background-color: #0f6016;
  color: white;
}

.message.received .message-content {
  background-color: #f0f0f0;
}

.message-time {
  font-size: 0.7em;
  color: #666;
  margin-top: 4px;
  text-align: right;
}

.message-input {
  display: flex;
  gap: 10px;
  padding-top: 15px;
  border-top: 1px solid #eee;
}

.message-input input {
  flex-grow: 1;
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
}

.message-input button {
  padding: 10px 20px;
  background-color: #0f6016;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  transition: background-color 0.2s;
}

.message-input button:hover:not(:disabled) {
  background-color: #0a4610;
}

.message-input button:disabled {
  background-color: #ccc;
  cursor: not-allowed;
}

.no-chat-selected {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #666;
  font-size: 1.1em;
  .messages-container {
  flex-grow: 1;
  overflow-y: auto;
  padding: 10px;
  margin: 10px 0;
  display: flex;
  flex-direction: column;
}

.message {
  max-width: 70%;
  margin: 5px 0;
  padding: 8px 12px;
  border-radius: 15px;
}

.message.sent {
  align-self: flex-end;
  background-color: #0f6016;
  color: white;
}

.message.received {
  align-self: flex-start;
  background-color: #f0f0f0;
  color: black;
}

.message-time {
  font-size: 0.7em;
  opacity: 0.7;
  margin-top: 4px;
}
.message-bubble {
  padding: 10px;
  border-radius: 15px;
  max-width: 70%;
  margin: 5px 0;
}

.sent .message-bubble {
  background-color: #0f6016;
  color: white;
  margin-left: auto;
}

.received .message-bubble {
  background-color: #f0f0f0;
  margin-right: auto;
}

.message-sender {
  font-size: 0.8em;
  margin-bottom: 4px;
  color: #666;
}
}
</style>



