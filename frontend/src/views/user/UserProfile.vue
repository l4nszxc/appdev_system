<template>
  <div>
    <Navbar :isLoggedIn="isLoggedIn" :username="username" />
    <div class="user-profile">
      <h2>User Profile</h2>
      <form @submit.prevent="updateProfile" class="profile-form">
        <div class="form-group">
          <label for="firstname">First Name:</label>
          <input type="text" id="firstname" v-model="firstname" required />
        </div>
        <div class="form-group">
          <label for="middlename">Middle Name:</label>
          <input type="text" id="middlename" v-model="middlename" required />
        </div>
        <div class="form-group">
          <label for="lastname">Last Name:</label>
          <input type="text" id="lastname" v-model="lastname" required />
        </div>
        <div class="form-group">
          <label for="gender">Gender:</label>
          <select id="gender" v-model="gender" required>
            <option value="" disabled>Select Gender</option>
            <option value="Male">Male</option>
            <option value="Female">Female</option>
            <option value="Other">Other</option>
          </select>
        </div>
        <div class="form-group">
          <label for="birthdate">Birthdate:</label>
          <input type="date" id="birthdate" v-model="birthdate" required />
        </div>
        <div class="form-group">
          <label for="address">Address:</label>
          <input type="text" id="address" v-model="address" required />
        </div>
        <div class="form-group">
          <label for="course">Course:</label>
          <input type="text" id="course" v-model="course" required />
        </div>
        <div class="form-group">
          <label for="section">Section:</label>
          <input type="text" id="section" v-model="section" required />
        </div>
        <div class="form-group">
          <label for="id-number">ID Number:</label>
          <input type="text" id="id-number" v-model="idNumber" required />
        </div>
        <button type="submit" class="submit-button">Update Profile</button>
      </form>
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue';
import Navbar from '../../components/Navbar.vue';

export default {
  name: 'UserProfile',
  components: {
    Navbar,
  },
  setup() {
    const isLoggedIn = ref(false);
    const username = ref('');
    const firstname = ref('');
    const middlename = ref('');
    const lastname = ref('');
    const gender = ref('');
    const birthdate = ref('');
    const address = ref('');
    const course = ref('');
    const section = ref('');
    const idNumber = ref('');

    // Fetch user data from local storage (or API)
    onMounted(() => {
      isLoggedIn.value = localStorage.getItem('isLoggedIn') === 'true';
      username.value = localStorage.getItem('username') || '';
      firstname.value = localStorage.getItem('firstname') || '';
      middlename.value = localStorage.getItem('middlename') || '';
      lastname.value = localStorage.getItem('lastname') || '';
      gender.value = localStorage.getItem('gender') || '';
      birthdate.value = localStorage.getItem('birthdate') || '';
      address.value = localStorage.getItem('address') || '';
      course.value = localStorage.getItem('course') || '';
      section.value = localStorage.getItem('section') || '';
      idNumber.value = localStorage.getItem('idNumber') || '';
    });

    const updateProfile = () => {
      // Handle the profile update logic, like sending the data to an API
      const profileData = {
        firstname: firstname.value,
        middlename: middlename.value,
        lastname: lastname.value,
        gender: gender.value,
        birthdate: birthdate.value,
        address: address.value,
        course: course.value,
        section: section.value,
        idNumber: idNumber.value,
      };
      console.log('Profile Updated:', profileData);
      // Reset form or show success message as needed
    };

    return {
      isLoggedIn,
      username,
      firstname,
      middlename,
      lastname,
      gender,
      birthdate,
      address,
      course,
      section,
      idNumber,
      updateProfile,
    };
  },
};
</script>

<style scoped>
.user-profile {
  max-width: 600px;
  margin: 0 auto;
  padding: 20px;
  border: 1px solid #ddd;
  border-radius: 8px;
  background-color: #f9f9f9;
}

.profile-form {
  display: flex;
  flex-direction: column;
}

.form-group {
  margin-bottom: 15px;
}

.form-group label {
  margin-bottom: 5px;
}

.form-group input,
.form-group select {
  padding: 10px;
  border: 1px solid #ccc;
  border-radius: 4px;
}

.submit-button {
  background-color: #0f6016;
  color: white;
  border: none;
  padding: 10px;
  cursor: pointer;
  font-size: 16px;
  border-radius: 5px;
  transition: background-color 0.3s;
}

.submit-button:hover {
  background-color: #0d4a12;
}
</style>
