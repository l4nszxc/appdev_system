<template>
  <div>
    <Navbar :isLoggedIn="isLoggedIn" :username="username" />
    <div class="bg-white rounded-lg shadow-md p-6">
      <h2 class="text-2xl font-semibold mb-4 text-green-800">Chat Support</h2>
      <div v-if="!chatId">
        <div class="mb-4">
          <label class="flex items-center">
            <input type="checkbox" v-model="isAnonymous" class="form-checkbox h-5 w-5 text-green-600">
            <span class="ml-2 text-gray-700">Stay anonymous</span>
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
        <div class="h-96 overflow-y-auto mb-4 p-4 bg-green-50 rounded-md">
          <div v-for="message in messages" :key="message.id" class="mb-2">
            <div
              :class="[
                'p-2 rounded-lg max-w-3/4',
                message.sender_id === userId ? 'bg-green-200 ml-auto' : 'bg-white'
              ]"
            >
              <p>{{ message.content }}</p>
              <p class="text-xs text-gray-500 mt-1">{{ formatDate(message.timestamp) }}</p>
            </div>
          </div>
        </div>
        <div class="flex">
          <input
            v-model="newMessage"
            @keyup.enter="sendMessage"
            type="text"
            placeholder="Type your message..."
            class="flex-grow p-2 border border-green-300 rounded-l-md focus:outline-none focus:ring-2 focus:ring-green-500"
          />
          <button
            @click="sendMessage"
            class="px-4 py-2 bg-green-600 text-white rounded-r-md hover:bg-green-700 transition-colors"
          >
            Send
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue';
import Navbar from '@/components/Navbar.vue'; // Import the Navbar component

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
});

const initiateChat = async () => {
  try {
    const response = await fetch('http://localhost:3000/api/chat/initiate', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ isAnonymous: isAnonymous.value }),
    });
    if (response.ok) {
      const data = await response.json();
      chatId.value = data.chatId;
      userId.value = data.userId;
      startPolling();
    }
  } catch (error) {
    console.error('Error initiating chat:', error);
  }
};

const sendMessage = async () => {
  if (!newMessage.value.trim()) return;

  try {
    await fetch(`http://localhost:3000/api/chat/${chatId.value}/message`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        content: newMessage.value,
        senderId: userId.value
      }),
    });
    newMessage.value = '';
  } catch (error) {
    console.error('Error sending message:', error);
  }
};

const fetchMessages = async () => {
  try {
    const response = await fetch(`http://localhost:3000/api/chat/${chatId.value}/messages`);
    if (response.ok) {
      messages.value = await response.json();
    }
  } catch (error) {
    console.error('Error fetching messages:', error);
  }
};

const formatDate = (timestamp) => {
  return new Date(timestamp).toLocaleString();
};

let pollingInterval;

const startPolling = () => {
  pollingInterval = setInterval(fetchMessages, 3000);
};

onUnmounted(() => {
  if (pollingInterval) {
    clearInterval(pollingInterval);
  }
});
</script>

<style scoped>
/* Add any additional styles you want here */
</style>