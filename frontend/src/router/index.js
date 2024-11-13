// import { createRouter, createWebHistory } from 'vue-router';
// import HomeView from '../views/HomeView.vue';
// import Login from '../views/Login.vue';
// import Register from '../views/Register.vue';
// <<<<<<< HEAD
// import UserHome from '../views/user/userHome.vue'; // Import the UserHome component
// import MindfulnessExercises from '../views/MindfulnessExercises.vue'
// =======
// import UserHome from '../views/user/userHome.vue';
// import UserProfile from '../views/user/UserProfile.vue';
// import UserChat from '@/views/user/userChat.vue';   
// import UserHeartToHeartRoom from '@/views/user/userHeartToHeartRoom.vue';


// //Admin imports
// import AdminHome from '@/views/admin/adminHome.vue';
// import AdminEmpathyC from '@/views/admin/adminEmpathyC.vue';
// import AdminFeed from '@/views/admin/adminFeed.vue';
// import AdminMessages from '@/views/admin/adminMessages.vue';
// import HeartToHeartRoom from '@/views/admin/heartToHeartRoom.vue';
// import MoodReport from '@/views/admin/moodReport.vue';
// import Users from '@/views/admin/users.vue';
// >>>>>>> f4753cef5cfcf1d8d3356c1b5d037340b0cf2898

import { createRouter, createWebHistory } from 'vue-router';
import HomeView from '../views/HomeView.vue';
import Login from '../views/Login.vue';
import Register from '../views/Register.vue';
import UserHome from '../views/user/userHome.vue';
import UserProfile from '../views/user/UserProfile.vue';
import UserChat from '@/views/user/userChat.vue';   
import UserHeartToHeartRoom from '@/views/user/userHeartToHeartRoom.vue';
<<<<<<< HEAD
import MindfulnessExercises from '../views/MindfulnessExercises.vue';
=======
import TermsAndConditions from '../views/TermsAndConditions.vue';
import PrivacyPolicy from '../views/PrivacyPolicy.vue';
import OTPVerification from '../views/OTPVerification.vue';
import ForgotPassword from '../views/ForgotPassword.vue'; // Import the ForgotPassword component

>>>>>>> 0f2941a0bc1337b7083106f0e75ce9460af8ff9e
// Admin imports
import AdminHome from '@/views/admin/adminHome.vue';
import AdminEmpathyC from '@/views/admin/adminEmpathyC.vue';
import AdminFeed from '@/views/admin/adminFeed.vue';
import AdminMessages from '@/views/admin/adminMessages.vue';
import HeartToHeartRoom from '@/views/admin/heartToHeartRoom.vue';
import MoodReport from '@/views/admin/moodReport.vue';
import Users from '@/views/admin/users.vue';

const routes = [
  {
    path: '/',
    name: 'home',
    component: HomeView,
  },
  {
    path: '/login',
    name: 'login',
    component: Login,
<<<<<<< HEAD
    meta: { requiresGuest: true }, // Add meta field for guest requirement
=======
    meta: { requiresGuest: true },
>>>>>>> 0f2941a0bc1337b7083106f0e75ce9460af8ff9e
  },
  {
    path: '/register',
    name: 'register',
    component: Register,
<<<<<<< HEAD
    meta: { requiresGuest: true }, // Add meta field for guest requirement
=======
    meta: { requiresGuest: true },
  },
  {
    path: '/verify-otp',
    name: 'otpVerification',
    component: OTPVerification,
    meta: { requiresGuest: true },
  },
  {
    path: '/forgot-password', // Add this new route
    name: 'forgotPassword',
    component: ForgotPassword,
    meta: { requiresGuest: true },
>>>>>>> 0f2941a0bc1337b7083106f0e75ce9460af8ff9e
  },
  // {
  // //   path: '/forgot-password',
  // //   name: 'ForgotPassword',
  // //   component: () => import('../views/ForgotPassword.vue'), // Import your ForgotPassword component
  // // },
  {
    path: '/user-home',
    name: 'userHome',
    component: UserHome,
    meta: { requiresAuth: true },
  },
  {
    path: '/user/userprofile',
    name: 'userProfile',
    component: UserProfile,
    meta: { requiresAuth: true },
  },
  {
    path: '/user/userChat',
    name: 'userChat',
    component: UserChat,
<<<<<<< HEAD
    meta: { requiresAuth: true},
  },
  {
    path:'/user/userHeartToHeartRoom',
    name: 'userHeartToHeartRoom',
    component: UserHeartToHeartRoom,
    meta: {requiresAuth: true},
  },

  //ADMIN ROUTES
  {
    path: '/admin-home',
    name: 'adminHome',
    component: AdminHome,
  },
  {
=======
    meta: { requiresAuth: true },
  },
  {
    path: '/user/userHeartToHeartRoom',
    name: 'userHeartToHeartRoom',
    component: UserHeartToHeartRoom,
    meta: { requiresAuth: true },
  },
  {
    path: '/terms-and-conditions',
    name: 'termsAndConditions',
    component: TermsAndConditions,
  },
  {
    path: '/privacy-policy',
    name: 'privacyPolicy',
    component: PrivacyPolicy,
  },
  // ADMIN ROUTES
  {
>>>>>>> 0f2941a0bc1337b7083106f0e75ce9460af8ff9e
    path: '/admin-home',
    name: 'adminHome',
    component: AdminHome,
  },
  {
    path: '/admin/adminEmpathyC',
    name: 'adminEmpathyC',
    component: AdminEmpathyC,
  },
  {
    path: '/admin/adminFeed',
    name: 'adminFeed',
    component: AdminFeed,
  },
  {
    path: '/admin/adminMessages',
    name: 'adminMessages',
    component: AdminMessages,
  },
  {
    path: '/admin/heartToHeartRoom',
    name: 'heartToHeartRoom',
    component: HeartToHeartRoom,
  },
  {
    path: '/admin/moodReport',
    name: 'moodReport',
    component: MoodReport,
  },
  {
    path: '/admin/users',
    name: 'users',
    component: Users,
  },
  {
<<<<<<< HEAD

    path: '/feed',
    name: 'feed',
    component: () => import('../views/user/Feed.vue'), // Lazy-load the Feed component
    meta: { requiresAuth: true }, // Ensure this route requires authentication
  },
  {
    path: '/mindfulness',
    name: 'mindfulness',
    component: MindfulnessExercises,
=======
    path: '/feed',
    name: 'feed',
    component: () => import('../views/user/Feed.vue'),
    meta: { requiresAuth: true },
>>>>>>> 0f2941a0bc1337b7083106f0e75ce9460af8ff9e
  },
];

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
});

// Navigation guard to check authentication
router.beforeEach((to, from, next) => {
  const isLoggedIn = localStorage.getItem('isLoggedIn') === 'true';

  if (to.meta.requiresAuth && !isLoggedIn) {
<<<<<<< HEAD
    next({ name: 'login' }); // Redirect to login if not authenticated
  } else if (to.meta.requiresGuest && isLoggedIn) {
    next({ name: 'userHome' }); // Redirect to user home if already logged in
  } else {
    next(); // Proceed to the route
=======
    next({ name: 'login' });
  } else if (to.meta.requiresGuest && isLoggedIn) {
    next({ name: 'userHome' });
  } else if (isLoggedIn && (to.name === 'termsAndConditions' || to.name === 'privacyPolicy')) {
    next({ name: 'userHome' });
  } else {
    next();
>>>>>>> 0f2941a0bc1337b7083106f0e75ce9460af8ff9e
  }
});

export default router;