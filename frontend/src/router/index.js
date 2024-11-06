import { createRouter, createWebHistory } from 'vue-router';
import HomeView from '../views/HomeView.vue';
import Login from '../views/Login.vue';
import Register from '../views/Register.vue';
import UserHome from '../views/user/userHome.vue'; // Import the UserHome component
import MindfulnessExercises from '../views/MindfulnessExercises.vue'

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
  },
  {
    path: '/register',
    name: 'register',
    component: Register,
  },
  {
    path: '/user-home',
    name: 'userHome', // Define a name for the route
    component: UserHome,
  },
  {
    path: '/mindfulness',
    name: 'mindfulness',
    component: MindfulnessExercises
  },
];

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
});

export default router;
