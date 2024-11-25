<template>
  <div>
    <Navbar :isLoggedIn="isLoggedIn" :username="username" />
<div class="chat-container bg-white rounded-lg shadow-md p-6 chat-content">
<h2 class="text-2xl font-semibold mb-4 text-green-800">Chat Support</h2>
      <div v-if="!chatId">
        <div class="mb-4">
          <label class="flex items-center">
<input type="checkbox" v-model="isAnonymous" class="form-checkbox h-5 w-5 text-green-600">
            <span class="ml-2 text-green-800">Stay anonymous</span>
          </label>
        </div>
        <button
          @click="initiateChat"
          class="px-4 py-2 bg-green-600 text-white rounded-md hover:bg-green-700 transition-colors"
        >
          Start Chat
        </button>
      </div>
      <div v-else>
<div class="messages-container h-96 overflow-y-auto mb-4 p-4 bg-green-900 rounded-t-lg shadow-lg">
          <div v-for="message in messages" :key="message.message_id" class="mb-2">
            <div
              :class="[
                'p-3 rounded-lg max-w-[70%] shadow-md',
                message.sender_type === 'admin' ? 'bg-green-100' : 'bg-white ml-auto text-right'
              ]"
            >
              <p class="text-sm font-semibold">
                {{ message.sender_type === 'admin' ? 'Admin' : 
                   (message.is_anonymous ? 'Anonymous User' : message.sender_name) }}
              </p>
              <p>{{ message.content }}</p>
              <p class="text-xs text-gray-500 mt-1">{{ formatDate(message.timestamp) }}</p>
            </div>
          </div>
        </div>
<div class="bg-green-950 p-4 rounded-b-lg">
          <div class="flex items-center">
            <input
              v-model="newMessage"
              @keyup.enter="sendMessage"
              type="text"
              placeholder="Type your message..."
              class="flex-grow p-2 bg-green-900 text-white border-none rounded-l-md focus:outline-none focus:ring-1 focus:ring-green-400"
            />
            <button
              @click="sendMessage"
              class="px-4 py-2 bg-green-600 text-white rounded-r-md hover:bg-green-700 transition-colors"
            >
              <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                <path d="M10.894 2.553a1 1 0 00-1.788 0l-7 14a1 1 0 001.169 1.409l5-1.429A1 1 0 009 15.571V11a1 1 0 112 0v4.571a1 1 0 00.725.962l5 1.428a1 1 0 001.17-1.408l-7-14z" />
              </svg>
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue';
import Navbar from '../../components/Navbar.vue';
import axios from 'axios';

const chatId = ref(null);
const userId = ref(null);
const messages = ref([]);
const newMessage = ref('');
const isAnonymous = ref(false);
const isLoggedIn = ref(false);
const username = ref('');

// Check login status on component mount
onMounted(() => {
  isLoggedIn.value = localStorage.getItem('isLoggedIn') === 'true';
  username.value = localStorage.getItem('username') || '';
  console.log('Username:', username.value);
});

const initiateChat = async () => {
  try {
    const token = localStorage.getItem('token');
    if (!token) {
      throw new Error('Authorization token is missing');
    }
    const response = await axios.post('http://localhost:5000/api/chat/initiate', {
      isAnonymous: isAnonymous.value,
    }, {
      headers: {
        'Authorization': `Bearer ${token}`
      }
    });

    if (response.status === 201) {
      const data = response.data;
      chatId.value = data.chatId;
      userId.value = data.studentId;
      startPolling();
    }
  } catch (error) {
    console.error('Error initiating chat:', error.response?.data || error.message);
  }
};

const sendMessage = async () => {
  const token = localStorage.getItem('token');
  if (!newMessage.value.trim()) return;

  try {
    await axios.post(
      `http://localhost:5000/api/chat/${chatId.value}/message`,
      { 
        content: newMessage.value,
        senderType: 'user'  // Explicitly set sender type
      },
      {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      }
    );
    newMessage.value = '';
    await fetchMessages(); // Fetch messages immediately after sending
  } catch (error) {
    console.error('Error sending message:', error.response?.data || error.message);
  }
};

const fetchMessages = async () => {
  try {
    const response = await axios.get(
      `http://localhost:5000/api/chat/${chatId.value}/messages`,
      {
        headers: {
          Authorization: `Bearer ${localStorage.getItem('token')}`,
        },
      }
    );
    messages.value = response.data;
  } catch (error) {
    console.error('Error fetching messages:', error.response?.data || error.message);
  }
};

const formatDate = (timestamp) => {
  return new Date(timestamp).toLocaleString();
};

let pollingInterval;

const startPolling = () => {
  pollingInterval = setInterval(async () => {
    await fetchMessages();
  }, 5000);
};

onUnmounted(() => {
  if (pollingInterval) {
    clearInterval(pollingInterval);
  }
});
</script>

<style>
.messages-container {
  display: flex;
  flex-direction: column;
  max-width: 800px;
  margin: auto;
}

.message-bubble {
  padding: 1rem;
  border-radius: 10px;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
  margin: 0.5rem 0;
}

.chat-container {
  max-width: 800px;
  margin: 2rem auto;
}
</style>
