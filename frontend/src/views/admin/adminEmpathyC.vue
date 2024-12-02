<template>
  <div class="body">
    <NavbarAdmin />
    <div>
      <h2>Set Empathy Challenge</h2>
      <button @click="resetChallenges">Reset Challenges</button>
    </div>
  </div>
</template>

<script setup>
import NavbarAdmin from '@/components/NavbarAdmin.vue';
import axios from 'axios';

const resetChallenges = async () => {
  try {
    const token = localStorage.getItem('token');
    await axios.post('http://localhost:5000/admin/reset-empathy-challenges', {}, {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    });
    alert('Challenges have been reset.');
  } catch (error) {
    console.error('Failed to reset challenges:', error);
  }
};
</script>

<style scoped>
.body {
  background-color: #84e8aa;
}
</style>