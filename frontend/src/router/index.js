import { createRouter, createWebHistory } from 'vue-router';
import HomeView from '../views/HomeView.vue';
import Login from '../views/Login.vue';
import Register from '../views/Register.vue';
import UserHome from '../views/user/userHome.vue';
import UserProfile from '../views/user/UserProfile.vue';
import UpdateUserProfile from '../views/user/UpdateUserProfile.vue';
import UserChat from '@/views/user/userChat.vue';   
import UserHeartToHeartRoom from '@/views/user/userHeartToHeartRoom.vue';
import TermsAndConditions from '../views/TermsAndConditions.vue';
import PrivacyPolicy from '../views/PrivacyPolicy.vue';
import OTPVerification from '../views/OTPVerification.vue';
import ForgotPassword from '../views/ForgotPassword.vue';
import FeedbackForm from '../views/user/FeedbackForm.vue';
import HelpCenter from '@/views/user/HelpCenter.vue';
import DailyExercise from '@/views/user/DailyExercise.vue'
import MoodTracker from '@/views/user/MoodTracker.vue';

// Admin imports
import AdminHome from '@/views/admin/adminHome.vue';
import AdminEmpathyC from '@/views/admin/adminEmpathyC.vue';
import AdminFeed from '@/views/admin/adminFeed.vue';
import AdminMessages from '@/views/admin/adminMessages.vue';
import HeartToHeartRoom from '@/views/admin/heartToHeartRoom.vue';
import MoodReport from '@/views/admin/moodReport.vue';
import Users from '@/views/admin/users.vue';
import AdminDashboard from '@/views/admin/adminDashboard.vue';
import SuspendedUsers from '@/views/admin/SuspendedUsers.vue';
import AddUser from '@/views/admin/AddUser.vue';

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
    meta: { requiresAuth: true, requiresUser: true },
  },
  {
    path: '/user/userprofile',
    name: 'userProfile',
    component: UserProfile,
    meta: { requiresAuth: true, requiresUser: true },
  },
  {
    path: '/update-profile',
    name: 'updateProfile',
    component: UpdateUserProfile,
    meta: { requiresAuth: true, requiresUser: true },
  },
  {
    path: '/user/userChat',
    name: 'userChat',
    component: UserChat,
    meta: { requiresAuth: true, requiresUser: true },
  },
  {
    path: '/user/userHeartToHeartRoom',
    name: 'userHeartToHeartRoom',
    component: UserHeartToHeartRoom,
    meta: { requiresAuth: true, requiresUser: true },   
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
    meta: { requiresAuth: true, requiresUser: true },
  },
  {
    path: '/help-center',
    name: 'helpCenter',
    component: HelpCenter,
    meta: { requiresAuth: true, requiresUser: true },
  },
  {
    path: '/daily-exercise',
    name: 'dailyExercise',
    component: DailyExercise,
    meta: { requiresAuth: true, requiresUser: true },
  },
  {
    path: '/feed',
    name: 'feed',
    component: () => import('../views/user/Feed.vue'),
    meta: { requiresAuth: true, requiresUser: true },
  },
  {
    path: '/mood-tracker',
    name: 'moodTracker',
    component: MoodTracker,
    meta: { requiresAuth: true, requiresUser: true },
  },
  // ADMIN ROUTES
  {
    path: '/admin-home',
    name: 'adminHome',
    component: AdminHome,
    meta: { requiresAuth: true, requiresAdmin: true },
  },
  {
    path: '/admin/adminEmpathyC',
    name: 'adminEmpathyC',
    component: AdminEmpathyC,
    meta: { requiresAuth: true, requiresAdmin: true },
  },
  {
    path: '/admin/adminFeed',
    name: 'adminFeed',
    component: AdminFeed,
    meta: { requiresAuth: true, requiresAdmin: true },
  },
  {
    path: '/admin/adminMessages',
    name: 'adminMessages',
    component: AdminMessages,
    meta: { requiresAuth: true, requiresAdmin: true },
  },
  {
    path: '/admin/heartToHeartRoom',
    name: 'heartToHeartRoom',
    component: HeartToHeartRoom,
    meta: { requiresAuth: true, requiresAdmin: true },
  },
  {
    path: '/admin/moodReport',
    name: 'moodReport',
    component: MoodReport,
    meta: { requiresAuth: true, requiresAdmin: true },
  },
  {
    path: '/admin/users',
    name: 'users',
    component: Users,
    meta: { requiresAuth: true, requiresAdmin: true },
  },
  {
    path: '/admin/suspended-users',
    name: 'suspendedUsers',
    component: SuspendedUsers,
    meta: { requiresAuth: true, requiresAdmin: true },
  },
  {
    path: '/admin/add-user',
    name: 'addUser',
    component: AddUser,
    meta: { requiresAuth: true, requiresAdmin: true },
  },
  {
    path: '/admin/adminDashboard',
    name: 'adminDashboard',
    component: AdminDashboard,
    meta: { requiresAuth: true, requiresAdmin: true },
  },
];

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
});

router.beforeEach((to, from, next) => {
  const isLoggedIn = localStorage.getItem('isLoggedIn') === 'true';
  const userRole = localStorage.getItem('role');

  if (to.meta.requiresAuth && !isLoggedIn) {
    next({ name: 'login' });
  } else if (to.meta.requiresGuest && isLoggedIn) {
    next({ name: userRole === 'admin' ? 'adminHome' : 'userHome' });
  } else if (to.meta.requiresAdmin && userRole !== 'admin') {
    next({ name: 'userHome' });
  } else if (to.meta.requiresUser && userRole === 'admin') {
    next({ name: 'adminHome' });
  } else {
    next();
  }
});

export default router;