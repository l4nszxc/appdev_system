<template>
  <Navbar />
  <div class="terms-container">
    <div class="container py-5">
      <div class="card shadow-lg border-0">
        <div class="card-body">
          <h1 class="text-center text-success fw-bold mb-4">Terms and Conditions</h1>
          <p>
            Welcome to MindConnect! By accessing and using our app, you agree to abide by the following terms and conditions. If you do not agree, please refrain from using our services.
          </p>
          <h2 class="text-success mt-4">1. Eligibility</h2>
          <p>
            MindConnect is exclusively available to students and staff of Mindoro State University (MinSU). By using the app, you confirm that you are an active student or staff member of MinSU. Access may require verification through your university credentials.
          </p>
          <h2 class="text-success mt-4">2. Use of the App</h2>
          <p>
            MindConnect is designed to provide mental health support through human-powered interactions, mindfulness exercises, and peer-to-peer community features. It is not a substitute for professional medical advice or treatment.
          </p>
          <h2 class="text-success mt-4">3. User Responsibilities</h2>
          <ul class="ps-4">
            <li>You must be at least 18 years old to use the app.</li>
            <li>Provide accurate and truthful information when creating your account.</li>
            <li>Use the app responsibly and refrain from abusive or harmful behavior.</li>
          </ul>
          <h2 class="text-success mt-4">4. Prohibited Activities</h2>
          <p>When using MindConnect, you agree not to:</p>
          <ul class="ps-4">
            <li>Post or share inappropriate or offensive content.</li>
            <li>Engage in harassment, discrimination, or harmful behavior toward other users.</li>
            <li>Attempt to hack, exploit, or misuse the app in any way.</li>
          </ul>
          <h2 class="text-success mt-4">5. Intellectual Property</h2>
          <p>
            All content, designs, and trademarks associated with MindConnect are owned by us and protected by intellectual property laws. You may not reproduce, distribute, or use our materials without permission.
          </p>
          <h2 class="text-success mt-4">6. Limitation of Liability</h2>
          <p>
            MindConnect is provided "as is." We are not liable for any damages arising from the use of the app or its content.
          </p>
          <h2 class="text-success mt-4">7. Updates and Changes</h2>
          <p>
            We may modify these terms at any time. Continued use of the app after updates constitutes acceptance of the new terms.
          </p>
          <h2 class="text-success mt-4">8. Contact Us</h2>
          <p>
            If you have questions about these terms, please contact us at <a href="mailto:minsu.mindconnect@gmail.com" class="text-success fw-bold">minsu.mindconnect@gmail.com</a>.
          </p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import Navbar from '../components/Navbar.vue';
</script>

<style scoped>
/* General container styling */
.privacy-container {
  background: linear-gradient(135deg, #f0f9ff, #ffffff);
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
}

/* Card styling */
.card {
  border-radius: 15px;
  max-width: 800px;
  margin: 0 auto;
}

h1, h2 {
  font-family: 'Poppins', sans-serif;
  font-weight: bold;
}

p, ul, li {
  font-family: 'Roboto', sans-serif;
  font-size: 1rem;
  line-height: 1.6;
  color: #333;
}

ul {
  list-style-type: disc;
  padding-left: 1.5rem;
}

.contact-link {
  color: #0eab23;
  text-decoration: none;
}

.contact-link:hover {
  text-decoration: underline;
}

.text-primary {
  color: #0d5217;
}

/* Accessibility adjustments */
.card-body {
  padding: 2rem;
}

h1, h2 {
  color: #0d5217;
  margin-bottom: 1rem;
}

a {
  color: #0eab23;
}

a:focus, a:hover {
  text-decoration: underline;
}

/* Responsive design */
@media (max-width: 768px) {
  .card-body {
    padding: 1.5rem;
  }

  h1 {
    font-size: 1.8rem;
  }

  h2 {
    font-size: 1.5rem;
  }
}
</style>