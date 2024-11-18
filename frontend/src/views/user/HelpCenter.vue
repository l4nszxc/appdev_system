<template>
  <Navbar :isLoggedIn="isLoggedIn" :username="username" />
  <div class="help-center-wrapper">
    <div class="container">
      <h2 class="text-success mb-5 fw-bold text-center">MindConnect FAQs</h2>
      <div class="faq-list">
        <div
          v-for="(faq, index) in paginatedFaqs"
          :key="index"
          class="faq-item p-4 mb-4 border rounded shadow-lg"
        >
          <div
            class="faq-question d-flex justify-content-between align-items-center"
            @click="toggleAnswer(index)"
          >
            <h5 class="text-success fw-bold mb-0 fs-4">{{ faq.question }}</h5>
            <span
              class="toggle-icon"
              :class="{ 'rotate-180': activeIndex === index }"
            >
              ▼
            </span>
          </div>
          <p
            v-if="activeIndex === index"
            class="faq-answer text-secondary mt-2 fs-5"
          >
            {{ faq.answer }}
          </p>
        </div>
      </div>
      <div class="pagination d-flex justify-content-center mt-4">
        <button
          class="btn btn-success me-2 px-4 py-2"
          :disabled="currentPage === 1"
          @click="changePage(currentPage - 1)"
        >
          Previous
        </button>
        <span class="mt-2 mx-2 fs-5">
          Page {{ currentPage }} of {{ totalPages }}
        </span>
        <button
          class="btn btn-success ms-2 px-4 py-2"
          :disabled="currentPage === totalPages"
          @click="changePage(currentPage + 1)"
        >
          Next
        </button>
      </div>
    </div>
  </div>
</template>

<script>
import Navbar from '../../components/Navbar.vue';

export default {
  name: 'HelpCenter',
  components: {
    Navbar,
  },
  data() {
    return {
      faqs: [
        {
          question: 'What is MindConnect?',
          answer:
            'MindConnect is a mental health support app that prioritizes human interaction, offering real-time emotional support, mindfulness exercises, and a community for peer-to-peer interaction.',
        },
        {
          question: 'How do I join the community?',
          answer:
            'To join the community, create an account, then navigate to the "Community" section from your dashboard to start interacting with others.',
        },
        {
          question: 'What features does MindConnect offer?',
          answer:
            'MindConnect offers features like anonymous real-time chat, guided mindfulness exercises, empathy challenges, and secure teletherapy sessions.',
        },
        {
          question: 'Is MindConnect free to use?',
          answer:
            'Yes, MindConnect is free to use, with optional premium features for enhanced functionality.',
        },
        {
          question: 'How does the empathy challenge work?',
          answer:
            'The empathy challenge allows users to respond thoughtfully to others\' messages, earning badges and rewards for empathetic interactions.',
        },
        {
          question: 'Can I remain anonymous on MindConnect?',
          answer:
            'Yes, MindConnect provides anonymous login options to ensure your privacy and comfort while using the platform.',
        },
        {
          question: 'What is the "Heart-to-Heart" feature?',
          answer:
            'The "Heart-to-Heart" feature allows users to enter specific private rooms during scheduled times for direct communication with a support agent.',
        },
        {
          question: 'How secure is MindConnect?',
          answer:
            'MindConnect uses data encryption and privacy assurance measures to protect your information and maintain anonymity.',
        },
        {
          question: 'Can I access MindConnect on my phone?',
          answer:
            'Yes, MindConnect is mobile-friendly and accessible on all devices, including smartphones and tablets.',
        },
        {
          question: 'Does MindConnect support video consultations?',
          answer:
            'Yes, MindConnect includes teletherapy features with secure video conferencing for remote consultations.',
        },
        {
          question: 'How do I report a problem with the app?',
          answer:
            'You can report any issues by navigating to the "Support" section in the app or emailing us directly at support@mindconnect.com.',
        },
        {
          question: 'Does MindConnect offer professional therapy?',
          answer:
            'MindConnect connects users to professional therapists for teletherapy sessions while also offering peer-to-peer support and mindfulness exercises.',
        },
        {
          question: 'Can I customize my profile?',
          answer:
            'Yes, MindConnect allows profile customization, including avatars and mood indicators.',
        },
        {
          question: 'What is the purpose of the sentiment analysis feature?',
          answer:
            'The sentiment analysis feature analyzes your messages to provide tailored recommendations or connect you to appropriate resources.',
        },
        {
          question: 'How can I suggest new features for MindConnect?',
          answer:
            'We value user feedback! You can suggest new features via the "Feedback" section in the app.',
        },
        {
          question: 'How do I update my profile?',
          answer:
            'To update your profile, go to the "Profile" section in the app, where you can change your avatar, mood, and other personal details.',
        },
        {
          question: 'How do I create a profile?',
          answer:
            'To create a profile, download the app, click on "Sign Up," and fill out the required fields such as your name, email, and Mindoro State University student credentials.',
        },
        {
          question: 'I forgot my password. How can I reset it?',
          answer:
            'If you forget your password, click on the "Forgot Password" link on the login page. Follow the instructions to reset your password using your registered email address.',
        },
        {
          question: 'Who can use MindConnect?',
          answer:
            'MindConnect is exclusively for Mindoro State University students. To access the app, you must verify your enrollment through the university’s system.',
        },
      ],
      activeIndex: null, // Tracks the currently active FAQ
      currentPage: 1,
      itemsPerPage: 5,
      isLoggedIn: false,
      username: ''
    };
  },
  computed: {
    totalPages() {
      return Math.ceil(this.faqs.length / this.itemsPerPage);
    },
    paginatedFaqs() {
      const start = (this.currentPage - 1) * this.itemsPerPage;
      const end = start + this.itemsPerPage;
      return this.faqs.slice(start, end);
    },
  },
  created() {
    // Fetching username and login status from local storage
    this.isLoggedIn = localStorage.getItem('isLoggedIn') === 'true';
    this.username = localStorage.getItem('username') || '';
  },
  methods: {
    toggleAnswer(index) {
      this.activeIndex = this.activeIndex === index ? null : index;
    },
    changePage(page) {
      if (page >= 1 && page <= this.totalPages) {
        this.currentPage = page;
      }
    },
  },
};
</script>

<style scoped>
.container {
  max-width: 700px;
  margin: 0 auto;
  background: linear-gradient(135deg, #f0f9ff, #cbebff);
  padding: 2rem;
  border-radius: 15px;
  box-shadow: 0 6px 12px rgba(0, 0, 0, 0.1);
  animation: fadeIn 1s ease-out;
}

.card {
  border-radius: 15px;
  background-color: #ffffff;
  border: 1px solid #ddd;
  transition: transform 0.3s ease-in-out;
}

.card:hover {
  transform: translateY(-5px);
}

h2 {
  font-family: 'Poppins', sans-serif;
  font-weight: bold;
  letter-spacing: 1px;
  color: #28a745;
}

.btn-success {
  background-color: #28a745;
  border: none;
  font-weight: bold;
  border-radius: 6px;
  transition: background-color 0.3s ease;
}

.btn-success:hover {
  background-color: #218838;
}

.form-select,
.form-control {
  border: 1px solid #ced4da;
  border-radius: 8px;
  padding: 0.75rem;
  transition: border-color 0.3s ease;
}

.form-select:focus,
.form-control:focus {
  border-color: #28a745;
  box-shadow: 0 0 5px rgba(40, 167, 69, 0.3);
}

.alert-success {
  background-color: #d4edda;
  color: #155724;
  border-color: #c3e6cb;
  border-radius: 6px;
}

.alert-danger {
  background-color: #f8d7da;
  color: #721c24;
  border-color: #f5c6cb;
  border-radius: 6px;
}

.shadow-sm {
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.hover-shadow:hover {
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
}

@keyframes fadeIn {
  from {
    opacity: 0;
  }
  to {
    opacity: 1;
  }
}
.help-center {
  background: linear-gradient(to bottom right, #f2f7f4, #ffffff);
  height: 100vh; /* Full viewport height */
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 0; /* Remove any padding to make it full screen */
}

.container {
  max-width: 900px; /* Optional: Set a max-width for readability */
  padding: 0 15px;
  width: 100%; /* Ensure the container takes full width */
}

.faq-list {
  margin-top: 3rem;
}

.faq-item {
  background-color: #ffffff;
  padding: 2rem;
  box-shadow: 0 6px 12px rgba(0, 0, 0, 0.1);
  border-radius: 10px;
  cursor: pointer;
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.faq-item:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
}

.faq-question {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.toggle-icon {
  font-size: 1.5rem;
  color: #28a745;
  transition: transform 0.3s ease;
}

.rotate-180 {
  transform: rotate(180deg);
}

.faq-answer {
  font-size: 1.25rem;
  line-height: 1.8;
  margin-top: 1rem;
  color: #6c757d;
}

h2 {
  font-family: 'Arial', sans-serif;
  text-transform: uppercase;
  letter-spacing: 2px;
  font-size: 2.5rem;
}

.text-success {
  color: #28a745 !important;
}

.pagination button {
  padding: 0.75rem 1.5rem;
  font-size: 1.25rem;
  color:#1c7a34;
}

.pagination span {
  font-size: 1.2rem;
  color:#23512e
}

.pagination button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}
</style>
