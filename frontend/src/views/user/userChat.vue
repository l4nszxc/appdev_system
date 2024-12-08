<template>
  <div>
    <Navbar :isLoggedIn="isLoggedIn" :username="username" :profilePicture="userInfo.profile_picture" />
    <div class="chat-container">
      <!-- Student List Section -->
      <div class="conversations-list">
        <h2>Student List</h2>
        <div class="search-bar">
          <input 
            type="text" 
            v-model="searchQuery"
            placeholder="Search students..."
          />
        </div>
        <div class="students-list">
          <div 
            v-for="student in displayedStudents" 
            :key="student.student_id"
            :class="['student-item', { active: selectedUser?.student_id === student.student_id }]"
            @click="selectStudent(student)"
          >
            <img 
              :src="getProfilePicture(student.profile_picture)"
              :alt="student.firstname"
              class="student-avatar"
            />
            <div class="student-info">
              <div class="student-name">{{ student.firstname }} {{ student.lastname }}</div>
              <div class="student-id">{{ student.student_id }}</div>
            </div>
          </div>
        </div>
      </div>

      <!-- Chat Section -->
      <div class="chat-section">
        <div v-if="selectedUser" class="chat-header">
          <img 
            :src="getProfilePicture(selectedUser.profile_picture)"
            :alt="selectedUser.firstname"
            class="header-avatar"
          />
          <div class="header-info">
            <div class="header-name">{{ selectedUser.firstname }} {{ selectedUser.lastname }}</div>
            <div class="header-status">{{ selectedUser.student_id }}</div>
          </div>
        </div>

        <div v-if="selectedUser" class="messages-container" ref="messagesContainer">
          <div 
            v-for="message in sortedMessages" 
            :key="message.id"
            :class="['message', message.sender_id === userInfo.student_id ? 'sent' : 'received']"
          >
            <div class="message-bubble">
              <div class="message-sender" v-if="message.sender_id !== userInfo.student_id">
                {{ message.firstname }} {{ message.lastname }}
              </div>
              <div class="message-content">{{ message.message }}</div>
              <div class="message-footer">
                <span class="message-time">{{ formatTime(message.created_at) }}</span>
                <span v-if="message.sender_id === userInfo.student_id" class="message-status">
                  {{ getMessageStatus(message) }}
                </span>
              </div>
            </div>
          </div>
        </div>

        <div v-if="selectedUser" class="message-input">
          <input 
            type="text" 
            v-model="newMessage" 
            @keyup.enter="sendMessage"
            placeholder="Type a message..."
          />
          <button @click="sendMessage" :disabled="!newMessage.trim()">
            Send
          </button>
        </div>

        <div v-else class="no-chat-selected">
          <p>Select a student to start chatting</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, onMounted, computed, onUnmounted } from 'vue';
import axios from 'axios';
import Navbar from '@/components/Navbar.vue';

export default {
  name: 'UserChat',
  components: { Navbar },
  setup() {
    const isLoggedIn = ref(false);
    const username = ref('');
    const userInfo = ref({});
    const students = ref([]);
    const selectedUser = ref(null);
    const messages = ref([]);
    const newMessage = ref('');
    const searchQuery = ref('');
    const selectedConversationId = ref(null);
    const messagesContainer = ref(null);
    const pollInterval = ref(null);

    const sortedMessages = computed(() => {
      return [...messages.value].sort((a, b) => 
        new Date(b.created_at) - new Date(a.created_at)
      );
    });

    const displayedStudents = computed(() => {
      if (!searchQuery.value) return students.value;
      const query = searchQuery.value.toLowerCase();
      return students.value.filter(student => 
        student.student_id.toLowerCase().includes(query) ||
        student.firstname.toLowerCase().includes(query) ||
        student.lastname.toLowerCase().includes(query)
      );
    });

    const fetchStudents = async () => {
      try {
        const token = localStorage.getItem('token');
        const response = await axios.get('http://localhost:5000/users/all', {
          headers: { Authorization: `Bearer ${token}` }
        });
        students.value = response.data;
      } catch (error) {
        console.error('Failed to fetch students:', error);
      }
    };

    const selectStudent = async (student) => {
      selectedUser.value = student;
      try {
        const token = localStorage.getItem('token');
        const response = await axios.get('http://localhost:5000/conversations', {
          headers: { Authorization: `Bearer ${token}` }
        });
        
        let conversation = response.data.find(conv => 
          (conv.student_id === userInfo.value.student_id && conv.participant_id === student.student_id) ||
          (conv.student_id === student.student_id && conv.participant_id === userInfo.value.student_id)
        );

        if (!conversation) {
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

    const getMessageStatus = (message) => {
      if (message.is_seen) {
        return 'Seen';
      }
      return 'Delivered';
    };

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
          console.error('Failed to fetch user info:', error);
        }
      }

      pollInterval.value = setInterval(() => {
        if (selectedConversationId.value) {
          fetchMessages();
        }
      }, 3000);
    });

    onUnmounted(() => {
      if (pollInterval.value) {
        clearInterval(pollInterval.value);
      }
    });

    return {
      isLoggedIn,
      username,
      userInfo,
      students,
      selectedUser,
      messages,
      newMessage,
      searchQuery,
      displayedStudents,
      sortedMessages,
      messagesContainer,
      selectStudent,
      sendMessage,
      getProfilePicture,
      formatTime,
      getMessageStatus
    };
  }
};
</script>

<style scoped>
.chat-container {
  display: flex;
  height: calc(100vh - 60px);
  padding: 20px;
  gap: 20px;
  background-color: #f5f5f5;
}

.conversations-list, .chat-section {
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  display: flex;
  flex-direction: column;
}

.conversations-list {
  width: 300px;
  padding: 20px;
}

.chat-section {
  flex-grow: 1;
  display: flex;
  flex-direction: column;
}

.search-bar {
  margin-bottom: 20px;
}

.search-bar input {
  width: 100%;
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 4px;
}

.student-item {
  display: flex;
  align-items: center;
  padding: 10px;
  cursor: pointer;
  border-radius: 4px;
  transition: background-color 0.2s;
}

.student-item:hover {
  background-color: #f5f5f5;
}

.student-item.active {
  background-color: #e8f5e9;
}

.student-avatar {
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

.chat-header {
  display: flex;
  align-items: center;
  padding: 15px;
  border-bottom: 1px solid #ddd;
}

.header-avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  margin-right: 10px;
}

.messages-container {
  flex-grow: 1;
  padding: 20px;
  overflow-y: auto;
  display: flex;
  flex-direction: column-reverse;
}

.message {
  max-width: 70%;
  margin: 5px 0;
}

.message-bubble {
  padding: 10px;
  border-radius: 15px;
  max-width: 100%;
}

.sent {
  align-self: flex-end;
}

.sent .message-bubble {
  background-color: #0f6016;
  color: white;
}

.received {
  align-self: flex-start;
}

.received .message-bubble {
  background-color: #f0f0f0;
}

.message-sender {
  font-size: 0.8em;
  margin-bottom: 4px;
  color: #666;
}

.message-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 0.7em;
  margin-top: 4px;
}

.message-status {
  color: #8e8e8e;
  margin-left: 8px;
}

.sent .message-status {
  color: #a8e6c3;
}

.message-input {
  padding: 15px;
  display: flex;
  gap: 10px;
  border-top: 1px solid #ddd;
}

.message-input input {
  flex-grow: 1;
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 4px;
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

.message-input button:disabled {
  background-color: #ccc;
  cursor: not-allowed;
}

.message-input button:hover:not(:disabled) {
  background-color: #0a4610;
}

.no-chat-selected {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #666;
}
</style>