<template>
    <div>
      <NavbarAdmin />
      <div class="container">
        <h1>Add User</h1>
        <!-- Add your content here -->
      </div>
    </div>
  </template>
  
  <script>
  import NavbarAdmin from '@/components/NavbarAdmin.vue';
  
  export default {
    name: 'AddUser',
    components: {
      NavbarAdmin,
    },
  };
  </script>
  
  <style scoped>
  .container {
    padding: 20px;
  }
  </style>