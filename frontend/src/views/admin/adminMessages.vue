<template>
  <NavbarAdmin />
  <div class="bg-white rounded-lg shadow-md p-6">
<h2 class="text-2xl font-semibold mb-4 text-green-800">Supporter Dashboard</h2>
    <div v-if="!activeChatId">
      <h3 class="text-lg font-semibold mb-2 text-green-700">Active Chats</h3>
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
<h3 class="text-lg font-semibold mb-2 text-green-700">Active Chat</h3>
<div class="h-96 overflow-y-auto mb-4 p-4 bg-green-900 rounded-t-lg shadow-lg">
        <div v-for="message in messages" :key="message.message_id" class="mb-2">
          <div
            :class="[
              'p-3 rounded-lg max-w-[70%] shadow-md',
              message.sender_type === 'admin' ? 'bg-white ml-auto text-right' : 'bg-green-100'
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
</template>

<script setup>
import NavbarAdmin from '../../components/NavbarAdmin.vue';
import { ref, onMounted, onUnmounted } from 'vue';

const waitingChats = ref([]);
const activeChatId = ref(null);
const supporterId = ref(null);
const messages = ref([]);
const newMessage = ref('');
const allMessages = ref([]);

const fetchWaitingChats = async () => {
  try {
    const token = localStorage.getItem('token');
    const response = await fetch('http://localhost:5000/api/chat/active', {
      headers: {
        'Authorization': `Bearer ${token}`
      }
    });
    if (response.ok) {
      waitingChats.value = await response.json();
    }
  } catch (error) {
    console.error('Error fetching active chats:', error);
  }
};

const joinChat = async (chatId) => {
  try {
    const token = localStorage.getItem('token');
    const chatResponse = await fetch(`http://localhost:5000/api/chat/${chatId}/info`, {
      headers: {
        'Authorization': `Bearer ${token}`
      }
    });
    if (chatResponse.ok) {
      const chatInfo = await chatResponse.json();
      activeChatId.value = chatId;
      supporterId.value = localStorage.getItem('student_id');
      startPolling();
    }
  } catch (error) {
    console.error('Error joining chat:', error);
  }
};

const sendMessage = async () => {
  if (!newMessage.value.trim()) return;

  try {
    const token = localStorage.getItem('token');
    await fetch(`http://localhost:5000/api/chat/${activeChatId.value}/message`, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${token}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        content: newMessage.value,
        senderType: 'admin'  // Explicitly set sender type
      }),
    });
    newMessage.value = '';
    await fetchMessages(); // Fetch messages immediately after sending
    await fetchAllMessages(); // Also update all messages
  } catch (error) {
    console.error('Error sending message:', error);
  }
};

const fetchMessages = async () => {
  try {
    const token = localStorage.getItem('token');
    const response = await fetch(`http://localhost:5000/api/chat/${activeChatId.value}/messages`, {
      headers: {
        'Authorization': `Bearer ${token}`
      }
    });
    if (response.ok) {
      messages.value = await response.json();
    }
  } catch (error) {
    console.error('Error fetching messages:', error);
  }
};

const fetchAllMessages = async () => {
  try {
    const token = localStorage.getItem('token');
    const chatsResponse = await fetch('http://localhost:5000/api/chat/active', {
      headers: {
        'Authorization': `Bearer ${token}`
      }
    });
    if (chatsResponse.ok) {
      const chats = await chatsResponse.json();
      const allMessagesPromises = chats.map(chat => 
        fetch(`http://localhost:5000/api/chat/${chat.chat_id}/messages`, {
          headers: {
            'Authorization': `Bearer ${token}`
          }
        }).then(res => res.json())
      );
      const allMessagesArrays = await Promise.all(allMessagesPromises);
      allMessages.value = allMessagesArrays.flat();
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
