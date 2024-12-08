<template>
  <div class="chat-app">
    <Navbar :isLoggedIn="isLoggedIn" :username="username" :profilePicture="userInfo.profile_picture" />
    <div class="chat-container">
      <!-- Student List Section -->
      <div class="conversations-list">
        <h2 class="section-title">Student List</h2>
        <div class="search-bar">
          <input 
            type="text" 
            v-model="searchQuery"
            placeholder="Search students..."
          />
          <SearchIcon class="search-icon" />
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
            <SendIcon class="send-icon" />
          </button>
        </div>

        <div v-else class="no-chat-selected">
          <MessageSquareIcon class="no-chat-icon" />
          <p>Select a student to start chatting</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed, onUnmounted, nextTick } from 'vue';
import axios from 'axios';
import Navbar from '@/components/Navbar.vue';
import { SearchIcon, SendIcon, MessageSquareIcon } from 'lucide-vue-next';

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
    new Date(a.created_at) - new Date(b.created_at)
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
    await nextTick();
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
  if (messagesContainer.value) {
    messagesContainer.value.scrollTop = messagesContainer.value.scrollHeight;
  }
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
  return message.is_seen ? 'Seen' : 'Delivered';
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
</script>

<style scoped>
.chat-app {
  height: 100vh;
  display: flex;
  flex-direction: column;
  background-color: #f0f2f5;
}

.chat-container {
  display: flex;
  flex: 1;
  overflow: hidden;
}

.conversations-list, .chat-section {
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  display: flex;
  flex-direction: column;
  margin: 1rem;
}

.conversations-list {
  width: 300px;
  padding: 1rem;
}

.chat-section {
  flex-grow: 1;
  display: flex;
  flex-direction: column;
}

.section-title {
  font-size: 1.2rem;
  font-weight: 600;
  margin-bottom: 1rem;
  color: #333;
}

.search-bar {
  position: relative;
  margin-bottom: 1rem;
}

.search-bar input {
  width: 87%;
  padding: 0.5rem 2rem 0.5rem 0.5rem;
  border: 1px solid #ddd;
  border-radius: 20px;
  font-size: 0.9rem;
}

.search-icon {
  position: absolute;
  right: 1em;
  top: 50%;
  transform: translateY(-50%);
  color: #666;
}

.students-list {
  overflow-y: auto;
  flex: 1;
}

.student-item {
  display: flex;
  align-items: center;
  padding: 0.75rem;
  cursor: pointer;
  border-radius: 8px;
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
  margin-right: 0.75rem;
  object-fit: cover;
}

.student-info {
  flex-grow: 1;
}

.student-name {
  font-weight: 600;
  color: #333;
}

.student-id {
  font-size: 0.8rem;
  color: #666;
}

.chat-header {
  display: flex;
  align-items: center;
  padding: 1rem;
  border-bottom: 1px solid #eee;
}

.header-avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  margin-right: 0.75rem;
}

.header-name {
  font-weight: 600;
  color: #333;
}

.header-status {
  font-size: 0.8rem;
  color: #666;
}

.messages-container {
  flex-grow: 1;
  padding: 1rem;
  overflow-y: auto;
  display: flex;
  flex-direction: column;
}

.message {
  max-width: 70%;
  margin: 0.5rem 0;
}

.message-bubble {
  padding: 0.75rem;
  border-radius: 18px;
  max-width: 100%;
  word-wrap: break-word;
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
  color: #333;
}

.message-sender {
  font-size: 0.8rem;
  margin-bottom: 0.25rem;
  color: #666;
}

.message-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 0.7rem;
  margin-top: 0.25rem;
}

.message-status {
  color: #a8e6c3;
  margin-left: 4px;
}

.message-input {
  padding: 1rem;
  display: flex;
  gap: 0.5rem;
  border-top: 1px solid #eee;
}

.message-input input {
  flex-grow: 1;
  padding: 0.75rem;
  border: 1px solid #ddd;
  border-radius: 20px;
  font-size: 0.9rem;
}

.message-input button {
  padding: 0.75rem;
  background-color: #0f6016;
  color: white;
  border: none;
  border-radius: 50%;
  cursor: pointer;
  transition: background-color 0.2s;
  display: flex;
  align-items: center;
  justify-content: center;
}

.message-input button:disabled {
  background-color: #ccc;
  cursor: not-allowed;
}

.message-input button:hover:not(:disabled) {
  background-color: #0a4610;
}

.send-icon {
  width: 1.2rem;
  height: 1.2rem;
}

.no-chat-selected {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  color: #666;
}

.no-chat-icon {
  width: 4rem;
  height: 4rem;
  color: #ccc;
  margin-bottom: 1rem;
}
</style>