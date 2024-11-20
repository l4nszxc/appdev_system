<template>
    <div>
      <NavbarAdmin />
      <h1>Welcome to Admin Home</h1>
      <!-- Add your admin home content here -->
    </div>
  </template>
  
  <script>
  import NavbarAdmin from '@/components/NavbarAdmin.vue';
  
  export default {
    name: 'AdminHome',
    components: {
      NavbarAdmin,
    },
  };
  </script>



