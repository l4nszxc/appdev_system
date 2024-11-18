<template>
    <NavbarAdmin />
    <div class="announcement-form-container container py-5">
      <div class="row justify-content-center">
        <div class="col-md-8">
          <div class="card shadow-lg">
            <div class="card-body p-5">
              <h2 class="card-title text-center mb-4 text-success">Create Announcement</h2>
              <form @submit.prevent="submitAnnouncement">
                <div class="mb-4">
                  <label for="title" class="form-label">Title</label>
                  <input 
                    v-model="title" 
                    type="text" 
                    class="form-control form-control-lg" 
                    id="title" 
                    required
                    placeholder="Enter announcement title"
                  >
                </div>
                <div class="mb-4">
                  <label for="content" class="form-label">Content</label>
                  <textarea 
                    v-model="content" 
                    class="form-control form-control-lg" 
                    id="content" 
                    rows="5" 
                    required
                    placeholder="Enter announcement content"
                  ></textarea>
                </div>
                <button type="submit" class="btn btn-success btn-lg w-100">Post Announcement</button>
              </form>
            </div>
          </div>
        </div>
      </div>
    </div>
  </template>
  
  <script>
  import NavbarAdmin from '@/components/NavbarAdmin.vue';
  import { ref } from 'vue'
  import { useStore } from 'vuex'
  
  export default {
    components: {
      NavbarAdmin,
    },
    name: 'announcementForm',
    setup() {
      const store = useStore()
      const title = ref('')
      const content = ref('')
  
      const submitAnnouncement = async () => {
        await store.dispatch('createAnnouncement', { title: title.value, content: content.value })
        title.value = ''
        content.value = ''
      }
  
      return {
        title,
        content,
        submitAnnouncement
      }
    }
  }
  </script>
  
  <style scoped>
  .announcement-form-container {
    background-color: #f0f8f1;
    min-height: calc(100vh - 56px); /* Adjust based on your navbar height */
  }
  
  .card {
    border: none;
    border-radius: 15px;
    transition: transform 0.3s ease-in-out, box-shadow 0.3s ease-in-out;
  }
  
  .card:hover {
    transform: translateY(-5px);
    box-shadow: 0 1rem 3rem rgba(0, 0, 0, 0.175) !important;
  }
  
  .form-control {
    border: 2px solid #e9ecef;
    border-radius: 10px;
    transition: border-color 0.3s ease-in-out, box-shadow 0.3s ease-in-out;
  }
  
  .form-control:focus {
    border-color: #2ecc71;
    box-shadow: 0 0 0 0.25rem rgba(46, 204, 113, 0.25);
  }
  
  .btn-success {
    background-color: #2ecc71;
    border-color: #2ecc71;
    border-radius: 10px;
    transition: all 0.3s ease-in-out;
  }
  
  .btn-success:hover {
    background-color: #27ae60;
    border-color: #27ae60;
    transform: translateY(-2px);
    box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
  }
  
  .text-success {
    color: #2ecc71 !important;
  }
  
  .form-label {
    font-weight: 600;
    color: #34495e;
  }
  </style>