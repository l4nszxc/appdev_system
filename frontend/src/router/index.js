import { createRouter, createWebHistory } from 'vue-router';
import HomeView from '../views/HomeView.vue';
import Login from '../views/Login.vue';
import Register from '../views/Register.vue';
import UserHome from '../views/user/userHome.vue';
import UserProfile from '../views/user/UserProfile.vue';
import AdminHome from '@/views/admin/adminHome.vue';

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
    meta: { requiresGuest: true }, // Add meta field for guest requirement
  },
  {
    path: '/register',
    name: 'register',
    component: Register,
    meta: { requiresGuest: true }, // Add meta field for guest requirement
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
    path: '/admin-home',
    name: 'adminHome',
    component: AdminHome,
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
    next({ name: 'login' }); // Redirect to login if not authenticated
  } else if (to.meta.requiresGuest && isLoggedIn) {
    next({ name: 'userHome' }); // Redirect to user home if already logged in
  } else {
    next(); // Proceed to the route
  }
});

export default router;