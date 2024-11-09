<template>
    <div class="bg-white rounded-lg shadow-md p-6">
      <h2 class="text-2xl font-semibold mb-4 text-green-800">Supporter Dashboard</h2>
      <div v-if="!activeChatId">
        <h3 class="text-lg font-semibold mb-2">Waiting Chats</h3>
        <ul class="space-y-2">
          <li v-for="chat in waitingChats" :key="chat.chat_id" class="flex justify-between items-center">
            <span>Chat {{ chat.chat_id.substr(0, 8) }}... ({{ chat.is_anonymous ? 'Anonymous' : 'Identified' }})</span>
            <button
              @click="joinChat(chat.chat_id)"
              class="px-3 py-1 bg-green-600 text-white rounded-md hover:bg-green-700 transition-colors"
            >
              Join
            </button>
          </li>
        </ul>
      </div>
      <div v-else>
        <h3 class="text-lg font-semibold mb-2">Active Chat</h3>
        <div class="h-96 overflow-y-auto mb-4 p-4 bg-green-50 rounded-md">
          <div v-for="message in messages" :key="message.id" class="mb-2">
            <div
              :class="[
                'p-2 rounded-lg max-w-3/4',
                message.sender_id === supporterId ? 'bg-green-200 ml-auto' : 'bg-white'
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
      
      <h3 class="text-lg font-semibold mt-8 mb-2">All Messages</h3>
      <div class="h-96 overflow-y-auto p-4 bg-green-50 rounded-md">
        <div v-for="message in allMessages" :key="message.id" class="mb-2">
          <div class="p-2 rounded-lg bg-white">
            <p class="font-semibold">
              {{ message.is_anonymous ? 'Anonymous User' : `User ${message.sender_id.substr(0, 8)}...` }}
            </p>
            <p>{{ message.content }}</p>
            <p class="text-xs text-gray-500 mt-1">{{ formatDate(message.timestamp) }}</p>
          </div>
        </div>
      </div>
    </div>
  </template>
  
  <script setup>
  import { ref, onMounted, onUnmounted } from 'vue';
  
  const waitingChats = ref([]);
  const activeChatId = ref(null);
  const supporterId = ref(null);
  const messages = ref([]);
  const newMessage = ref('');
  const allMessages = ref([]);
  
  const fetchWaitingChats = async () => {
    try {
      const response = await fetch('http://localhost:3000/api/chat/waiting');
      if (response.ok) {
        waitingChats.value = await response.json();
      }
    } catch (error) {
      console.error('Error fetching waiting chats:', error);
    }
  };
  
  const joinChat = async (chatId) => {
    try {
      const response = await fetch(`http://localhost:3000/api/chat/join/${chatId}`, {
        method: 'POST'
      });
      if (response.ok) {
        const data = await response.json();
        activeChatId.value = chatId;
        supporterId.value = data.supporterId;
        startPolling();
      }
    } catch (error) {
      console.error('Error joining chat:', error);
    }
  };
  
  const sendMessage = async () => {
    if (!newMessage.value.trim()) return;
  
    try {
      await fetch(`http://localhost:3000/api/chat/${activeChatId.value}/message`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          content: newMessage.value,
          senderId: supporterId.value
        }),
      });
      newMessage.value = '';
    } catch (error) {
      console.error('Error sending message:', error);
    }
  };
  
  const fetchMessages = async () => {
    try {
      const response = await fetch(`http://localhost:3000/api/chat/${activeChatId.value}/messages`);
      if (response.ok) {
        messages.value = await response.json();
      }
    } catch (error) {
      console.error('Error fetching messages:', error);
    }
  };
  
  const fetchAllMessages = async () => {
    try {
      const response = await fetch('http://localhost:3000/api/supporter/all-messages');
      if (response.ok) {
        allMessages.value = await response.json();
      }
    } catch (error) {
      console.error('Error fetching all messages:', error);
    }
  };
  
  const formatDate = (timestamp) => {
    return new Date(timestamp).toLocaleString();
  };
  
  let pollingInterval;
  
  const startPolling = () => {
    pollingInterval = setInterval(() => {
      if (activeChatId.value) {
        fetchMessages();
      } else {
        fetchWaitingChats();
      }
      fetchAllMessages();
    }, 3000);
  };
  
  onMounted(() => {
    fetchWaitingChats();
    fetchAllMessages();
    startPolling();
  });
  
  onUnmounted(() => {
    if (pollingInterval) {
      clearInterval(pollingInterval);
    }
  });
  </script>