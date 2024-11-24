<template>
  <div class="body">
  <NavbarAdmin />
  <div class="d-flex align-items-center justify-content-center min-vh-100">
    <div class="container-fluid px-5">
      <div class="row">
        <!-- Left Side (Admin Dashboard & Empathy Challenges) -->
        <div class="col-12 col-md-6">
          <!-- Dashboard Card -->
          <div class="card mb-4 shadow-sm">
            <div class="card-body">
              <h1 class="text-center text-primary mb-5">Admin Dashboard</h1>
              <div class="d-grid gap-3">
                <button class="btn btn-primary" @click="createChallengeModal">Create New Challenge</button>
                <button class="btn btn-outline-primary" @click="viewChallenges">View Existing Challenges</button>
              </div>
            </div>
          </div>

          <!-- Challenge List -->
          <div class="card shadow-sm">
            <div class="card-header bg-primary text-white">
              <h2 class="h5 mb-0">Empathy Challenges</h2>
            </div>
            <div class="card-body">
              <div v-if="challenges.length > 0" class="list-group">
                <div v-for="challenge in challenges" :key="challenge.id" class="list-group-item mb-3">
                  <p class="text-primary mb-1">{{ challenge.description }}</p>
                  <p class="text-muted">{{ formatDate(challenge.startDate) }} - {{ formatDate(challenge.endDate) }}</p>
                </div>
              </div>
              <p v-else class="text-center text-muted">No challenges created yet.</p>
            </div>
          </div>
        </div>

        <!-- Right Side (Create New Challenge) -->
        <div class="col-12 col-md-6">
          <div class="card mb-4 shadow-sm">
            <div class="card-header bg-primary text-white">
              <h2 class="h5 mb-0">Create New Empathy Challenge</h2>
            </div>
            <div class="card-body">
              <form @submit.prevent="createChallenge" class="needs-validation" novalidate>
                <div class="mb-4">
                  <label for="challengeDescription" class="form-label">Challenge Description</label>
                  <textarea id="challengeDescription" v-model="newChallenge.description" rows="3" class="form-control" required></textarea>
                </div>

                <div class="mb-4">
                  <label for="startDate" class="form-label">Start Date</label>
                  <input type="date" id="startDate" v-model="newChallenge.startDate" class="form-control" required />
                </div>

                <div class="mb-4">
                  <label for="endDate" class="form-label">End Date</label>
                  <input type="date" id="endDate" v-model="newChallenge.endDate" class="form-control" required />
                </div>

                <button type="submit" class="btn btn-lg btn-primary w-100">Create Challenge</button>
              </form>
            </div>
          </div>
        </div>

      </div>
    </div>
  </div>
</div>
</template>

<script setup>
import NavbarAdmin from '@/components/NavbarAdmin.vue';
import { ref, onMounted } from 'vue';

const challenges = ref([]);
const newChallenge = ref({
  description: '',
  startDate: '',
  endDate: ''
});

const fetchChallenges = async () => {
  try {
    const response = await fetch('http://localhost:5000/api/admin/challenges');
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
    const response = await fetch('http://localhost:5000/api/admin/challenges', {
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

<style scoped>
.body{
  background-color: #84e8aa;
}
.card-body {
  background-color: #55b379;
  padding: 2rem;
}

.card-header {
  background-color: #128535;
  color: white;
}

.form-control {
  border-radius: .375rem;
}

.btn-primary {
  background-color: #128535;
  border-color: #128535;
  color: white;
}

.btn-outline-primary {
  color: #128535;
  border-color: #128535;
}

.btn-outline-primary:hover {
  background-color: #128535;
  color: white;
}

.list-group-item {
  background-color: #f8f9fa;
  border: 1px solid #e9ecef;
  border-radius: .375rem;
  transition: all 0.3s ease;
}

.list-group-item:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.container-fluid {
  max-width: 100%;
  padding: 0 2rem;
}

.shadow-sm {
  box-shadow: 0 .125rem .25rem rgba(0,0,0,.075)!important;
}

.mb-4 {
  margin-bottom: 2rem;
}

.d-flex {
  display: flex;
}

.align-items-center {
  align-items: center;
}

.justify-content-center {
  justify-content: center;
}

.min-vh-100 {
  min-height: 100vh;
}

@media (max-width: 768px) {
  .container-fluid {
    padding: 0 1rem;
  }

  .card-body {
    padding: 1.5rem;
  }
}
</style>
