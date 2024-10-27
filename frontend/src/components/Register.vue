<template>
  <div>
    <h2>Register</h2>
    <form @submit.prevent="register">
      <input v-model="username" placeholder="Username" required />
      <input v-model="firstname" placeholder="First Name" required />
      <input v-model="middlename" placeholder="Middle Name" />
      <input v-model="lastname" placeholder="Last Name" required />
      <input v-model="email" type="email" placeholder="Email" required />
      <input v-model="password" type="password" placeholder="Password" required />
      <input v-model="confirmPassword" type="password" placeholder="Confirm Password" required />
      <button type="submit">Register</button>
    </form>
    <p>{{ message }}</p>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      username: '',
      firstname: '',
      middlename: '',
      lastname: '',
      email: '',
      password: '',
      confirmPassword: '',
      message: ''
    };
  },
  methods: {
    async register() {
      try {
        const response = await axios.post('http://localhost:5000/register', {
          username: this.username,
          firstname: this.firstname,
          middlename: this.middlename,
          lastname: this.lastname,
          email: this.email,
          password: this.password,
          confirmPassword: this.confirmPassword
        });
        this.message = response.data.message;
      } catch (error) {
        this.message = error.response.data.message || 'Registration failed';
      }
    }
  }
};
</script>
