<template>
    <div class="min-h-screen bg-green-50 p-6">
      <div class="max-w-4xl mx-auto bg-white rounded-lg shadow-md p-6">
        <h1 class="text-3xl font-bold text-green-800 mb-6">Admin Dashboard</h1>
        
        <div class="mb-8">
          <h2 class="text-2xl font-semibold text-green-700 mb-4">Create New Empathy Challenge</h2>
          <form @submit.prevent="createChallenge" class="space-y-4">
            <div>
              <label for="challengeDescription" class="block text-sm font-medium text-gray-700">Challenge Description</label>
              <textarea
                id="challengeDescription"
                v-model="newChallenge.description"
                rows="3"
                class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring focus:ring-green-500 focus:ring-opacity-50"
                placeholder="Enter the empathy challenge description"
                required
              ></textarea>
            </div>
            <div>
              <label for="challengeStartDate" class="block text-sm font-medium text-gray-700">Start Date</label>
              <input
                type="date"
                id="challengeStartDate"
                v-model="newChallenge.startDate"
                class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring focus:ring-green-500 focus:ring-opacity-50"
                required
              >
            </div>
            <div>
              <label for="challengeEndDate" class="block text-sm font-medium text-gray-700">End Date</label>
              <input
                type="date"
                id="challengeEndDate"
                v-model="newChallenge.endDate"
                class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring focus:ring-green-500 focus:ring-opacity-50"
                required
              >
            </div>
            <button
              type="submit"
              class="px-4 py-2 bg-green-600 text-white rounded-md hover:bg-green-700 transition-colors"
            >
              Create Challenge
            </button>
          </form>
        </div>
        
        <div>
          <h2 class="text-2xl font-semibold text-green-700 mb-4">Empathy Challenges</h2>
          <div v-if="challenges.length > 0" class="space-y-4">
            <div v-for="challenge in challenges" :key="challenge.id" class="bg-green-50 p-4 rounded-md">
              <p class="text-green-800 font-medium">{{ challenge.description }}</p>
              <p class="text-sm text-gray-600">
                {{ formatDate(challenge.startDate) }} - {{ formatDate(challenge.endDate) }}
              </p>
            </div>
          </div>
          <p v-else class="text-gray-500">No challenges created yet.</p>
        </div>
      </div>
    </div>
  </template>
  
  <script setup>
  import { ref, onMounted } from 'vue';
  
  const challenges = ref([]);
  const newChallenge = ref({
    description: '',
    startDate: '',
    endDate: ''
  });
  
  const fetchChallenges = async () => {
    try {
      const response = await fetch('http://localhost:3000/api/admin/challenges');
      if (response.ok) {
        challenges.value = await response.json();
      } else {
        console.error('Failed to fetch challenges');
      }
    } catch (error) {
      console.error('Error fetching challenges:', error);
    }
  };
  
  const createChallenge = async () => {
    try {
      const response = await fetch('http://localhost:3000/api/admin/challenges', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(newChallenge.value),
      });
  
      if (response.ok) {
        const createdChallenge = await response.json();
        challenges.value.unshift(createdChallenge);
        newChallenge.value = { description: '', startDate: '', endDate: '' };
      } else {
        console.error('Failed to create challenge');
      }
    } catch (error) {
      console.error('Error creating challenge:', error);
    }
  };
  
  const formatDate = (dateString) => {
    return new Date(dateString).toLocaleDateString();
  };
  
  onMounted(() => {
    fetchChallenges();
  });
  </script>