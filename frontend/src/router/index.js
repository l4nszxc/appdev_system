import { createRouter, createWebHistory } from 'vue-router';
import HomeView from '../views/HomeView.vue';
import Login from '../views/Login.vue';
import Register from '../views/Register.vue';
import UserHome from '../views/user/userHome.vue';
import UserProfile from '../views/user/UserProfile.vue';
import UpdateUserProfile from '../views/user/UpdateUserProfile.vue';
import UserChat from '@/views/user/userChat.vue';   
import TermsAndConditions from '../views/TermsAndConditions.vue';
import PrivacyPolicy from '../views/PrivacyPolicy.vue';
import OTPVerification from '../views/OTPVerification.vue';
import ForgotPassword from '../views/ForgotPassword.vue';
import FeedbackForm from '../views/user/FeedbackForm.vue';
import HelpCenter from '@/views/user/HelpCenter.vue';
import DailyExercise from '@/views/user/DailyExercise.vue'
import userHeartToHeartRoom from '@/views/user/userHeartToHeartRoom.vue';



// Admin imports
import AdminHome from '@/views/admin/adminHome.vue';
import AdminEmpathyC from '@/views/admin/adminEmpathyC.vue';
import AdminFeed from '@/views/admin/adminFeed.vue';
import AdminMessages from '@/views/admin/adminMessages.vue';
import MoodReport from '@/views/admin/moodReport.vue';
import Users from '@/views/admin/users.vue';
import adminDashboard from '@/views/admin/adminDashboard.vue';
import heartToHeartRoom from '@/views/admin/heartToHeartRoom.vue';
import announcementForm from '@/views/admin/announcementForm.vue';


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
    meta: { requiresGuest: true },
  },
  {
    path: '/register',
    name: 'register',
    component: Register,
    meta: { requiresGuest: true },
  },
  {
    path: '/verify-otp',
    name: 'otpVerification',
    component: OTPVerification,
    meta: { requiresGuest: true },
  },
  {
    path: '/forgot-password',
    name: 'forgotPassword',
    component: ForgotPassword,
    meta: { requiresGuest: true },
  },
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
    path: '/update-profile',
    name: 'updateProfile',
    component: UpdateUserProfile,
    meta: { requiresAuth: true },
  },
  {
    path: '/user/userChat',
    name: 'userChat',
    component: UserChat,
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
  {
    path: '/feedback',
    name: 'feedbackForm',
    component: FeedbackForm,
    meta: { requiresAuth: true },
  },
  {
    path: '/help-center',
    name: 'helpCenter',
    component: HelpCenter,
    meta: { requiresAuth: true },
  },
  {
    path: '/daily-exercise',
    name: 'dailyExercise',
    component: DailyExercise,
    meta: { requiresAuth: true },
  },
  {
    path: '/user/userHeartToHeartRoom',
    name: 'userHeartToHeartRoom',
    component: userHeartToHeartRoom,
    meta: { requiresAuth: true },
  },
  // ADMIN ROUTES
  {
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
    path: '/feed',
    name: 'feed',
    component: () => import('../views/user/Feed.vue'),
    meta: { requiresAuth: true },
  },
  {
    path: '/admin/adminDashboard',
    name: 'dashboard',
    component: adminDashboard,
  },
  {
    path: '/admin/heartToHeartRoom',
    name: 'heartToHeartRoom',
    component: heartToHeartRoom,
  },
  {
    path: '/admin/announcementForm',
    name: 'announcementForm',
    component: announcementForm,
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
    next({ name: 'login' });
  } else if (to.meta.requiresGuest && isLoggedIn) {
    next({ name: 'userHome' });
  } else if (isLoggedIn && (to.name === 'termsAndConditions' || to.name === 'privacyPolicy')) {
    next({ name: 'userHome' });
  } else {
    next();
  }
});

export default router;