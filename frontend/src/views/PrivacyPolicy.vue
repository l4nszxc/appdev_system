<template>
  <Navbar />
  <div class="privacy-container">
    <div class="container py-5">
      <div class="card shadow-lg border-0">
        <div class="card-body">
          <h1 class="text-center text-primary fw-bold mb-4">Privacy Policy</h1>
          <p>
            At <strong>MindConnect</strong>, safeguarding your privacy is a priority. This policy outlines how we collect, utilize, and protect your personal information to ensure transparency and trust.
          </p>
          <section>
            <h2 class="text-primary mt-4">1. Information We Collect</h2>
            <p>We collect information to enhance your experience, including:</p>
            <ul class="ps-4">
              <li><strong>Personal Data:</strong> Name, email, and account details provided during registration.</li>
              <li><strong>Interaction Data:</strong> Feedback and engagement metrics within the app.</li>
              <li><strong>Usage Data:</strong> Device type, operating system, and activity for analytics.</li>
            </ul>
          </section>
          <section>
            <h2 class="text-primary mt-4">2. How We Use Your Information</h2>
            <p>We use your data for the following purposes:</p>
            <ul class="ps-4">
              <li>Delivering and optimizing app features and services.</li>
              <li>Personalizing your user experience.</li>
              <li>Responding to inquiries and communicating updates.</li>
            </ul>
          </section>
          <section>
            <h2 class="text-primary mt-4">3. Data Sharing</h2>
            <p>
              Your data is not sold or shared with third parties unless required by law or with your consent.
            </p>
          </section>
          <section>
            <h2 class="text-primary mt-4">4. Security Measures</h2>
            <p>
              We implement robust encryption and secure servers to protect your data. However, no system is entirely secure, and absolute protection cannot be guaranteed.
            </p>
          </section>
          <section>
            <h2 class="text-primary mt-4">5. Your Rights</h2>
            <p>You are entitled to:</p>
            <ul class="ps-4">
              <li>Access, modify, or delete your personal information.</li>
              <li>Withdraw consent for data collection at any time.</li>
              <li>Contact us for any privacy-related concerns or clarifications.</li>
            </ul>
          </section>
          <section>
            <h2 class="text-primary mt-4">6. Changes to This Policy</h2>
            <p>
              Updates to this policy will be posted here, along with the effective date of changes.
            </p>
          </section>
          <section>
            <h2 class="text-primary mt-4">7. Contact Us</h2>
            <p>
              For questions or concerns about this policy, please email us at: 
              <a href="mailto:minsu.mindconnect@gmail.com" class="contact-link">minsu.mindconnect@gmail.com</a>.
            </p>
          </section>
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
  color: #0eab23;
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
