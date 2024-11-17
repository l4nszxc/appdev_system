<template>
  <div class="help-center-wrapper d-flex align-items-center justify-content-center vh-100">
    <div class="container">
      <Navbar />
      <h2 class="text-success mb-4 fw-bold text-center">MindConnect FAQs</h2>
      <div class="faq-list">
        <div
          v-for="(faq, index) in faqs"
          :key="index"
          class="faq-item p-3 mb-3 border rounded shadow-sm"
        >
          <div
            class="faq-question d-flex justify-content-between align-items-center"
            @click="toggleAnswer(index)"
          >
            <h5 class="text-success fw-bold mb-0">{{ faq.question }}</h5>
            <span
              class="toggle-icon"
              :class="{ 'rotate-180': activeIndex === index }"
            >
              ▼
            </span>
          </div>
          <p
            v-if="activeIndex === index"
            class="faq-answer text-secondary mt-2"
          >
            {{ faq.answer }}
          </p>
        </div>
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
        // New FAQs added below:
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
    };
  },
  methods: {
    toggleAnswer(index) {
      this.activeIndex = this.activeIndex === index ? null : index;
    },
  },
};
</script>

<style scoped>
.help-center-wrapper {
  background: linear-gradient(to bottom right, #e6f5e6, #ffffff);
  padding: 2rem 0;
}

.container {
  max-width: 800px;
}

.faq-list {
  margin-top: 2rem;
}

.faq-item {
  background-color: #f9fdf9;
  cursor: pointer;
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.faq-item:hover {
  transform: scale(1.02);
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.15);
}

.faq-question {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.toggle-icon {
  font-size: 1.25rem;
  color: #28a745;
  transition: transform 0.3s ease;
}

.rotate-180 {
  transform: rotate(180deg);
}

.faq-answer {
  font-size: 1rem;
  line-height: 1.5;
  margin-top: 0.5rem;
  color: #6c757d;
}

h2 {
  font-family: 'Arial', sans-serif;
  text-transform: uppercase;
  letter-spacing: 1.5px;
}

.text-success {
  color: #28a745 !important;
}
</style>
