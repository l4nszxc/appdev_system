<template>
  <div>
    <Navbar />
    <div class="user-profile">
      <h2>User Profile</h2>
      <div class="profile-pic-section">
        <label for="profile-pic" class="profile-pic-label">
          <img :src="profilePic" alt="Profile Picture" class="profile-pic" />
          <input type="file" id="profile-pic" @change="uploadProfilePic" accept="image/*" hidden />
        </label>
      </div>
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
        <div class="form-group">
          <label for="school-id">Upload School ID:</label>
          <input type="file" id="school-id" @change="uploadSchoolID" accept="image/*" required />
        </div>
        <button type="submit" class="submit-button">Update Profile</button>
      </form>
    </div>
  </div>
</template>

<script>
import { ref } from 'vue';
import Navbar from '../../components/Navbar.vue'; // Corrected import path

export default {
  name: 'User Profile',
  components: {
    Navbar,
  },
  setup() {
    const profilePic = ref('../assets/default-profile.png'); // Default profile picture
    const firstname = ref('');
    const middlename = ref('');
    const lastname = ref('');
    const gender = ref('');
    const birthdate = ref('');
    const address = ref('');
    const course = ref('');
    const section = ref('');
    const idNumber = ref('');
    const schoolIdFile = ref(null); // To hold the uploaded school ID file

    const uploadProfilePic = (event) => {
      const file = event.target.files[0];
      if (file) {
        const reader = new FileReader();
        reader.onload = (e) => {
          profilePic.value = e.target.result; // Set the profile picture to the uploaded file
        };
        reader.readAsDataURL(file);
      }
    };

    const uploadSchoolID = (event) => {
      schoolIdFile.value = event.target.files[0]; // Store the uploaded school ID file
    };

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
        schoolIdFile: schoolIdFile.value, // This will need special handling for file upload
      };
      console.log('Profile Updated:', profileData);
      // Reset form or show success message as needed
    };

    return {
      profilePic,
      firstname,
      middlename,
      lastname,
      gender,
      birthdate,
      address,
      course,
      section,
      idNumber,
      uploadProfilePic,
      uploadSchoolID,
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

.profile-pic-section {
  display: flex;
  justify-content: center;
  margin-bottom: 20px;
}

.profile-pic-label {
  cursor: pointer;
}

.profile-pic {
  width: 120px;
  height: 120px;
  border-radius: 50%;
  object-fit: cover;
  border: 2px solid #0f6016;
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