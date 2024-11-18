import { createStore } from 'vuex'
import axios from 'axios'
import availability from './modules/availability';
import schedules from './modules/schedules';
import timelink from './modules/timelink';


export default createStore({
  state: {
    modules: {
      availability,
      schedules,
      timelink,
    },
    auth: {
      email: null,
      isLoggedIn: false,
      username: '',
      userInfo: {}
    },
    heartToHeart: {
      availableSlots: [],
      userSchedule: null,
      announcements: []
    }
  },
  mutations: {
    setEmail(state, email) {
      state.auth.email = email
    },
    setLoggedIn(state, isLoggedIn) {
      state.auth.isLoggedIn = isLoggedIn
    },
    setUsername(state, username) {
      state.auth.username = username
    },
    setUserInfo(state, userInfo) {
      state.auth.userInfo = userInfo
    },
    setAvailableSlots(state, slots) {
      state.heartToHeart.availableSlots = slots
    },
    setUserSchedule(state, schedule) {
      state.heartToHeart.userSchedule = schedule
    },
    setAnnouncements(state, announcements) {
      state.heartToHeart.announcements = announcements
    }
  },
  actions: {
    setEmail({ commit }, email) {
      commit('setEmail', email)
    },
    login({ commit }, { email, username }) {
      commit('setEmail', email)
      commit('setLoggedIn', true)
      commit('setUsername', username)
      localStorage.setItem('isLoggedIn', 'true')
      localStorage.setItem('username', username)
    },
    logout({ commit }) {
      commit('setEmail', null)
      commit('setLoggedIn', false)
      commit('setUsername', '')
      commit('setUserInfo', {})
      localStorage.removeItem('isLoggedIn')
      localStorage.removeItem('username')
      localStorage.removeItem('token')
    },
    async fetchUserInfo({ commit }) {
      try {
        const token = localStorage.getItem('token')
        const response = await axios.get('http://localhost:5000/user', {
          headers: {
            Authorization: `Bearer ${token}`
          }
        })
        commit('setUserInfo', response.data)
      } catch (error) {
        console.error('Failed to fetch user details:', error)
      }
    },
    async fetchAvailableSlots({ commit }, date) {
      try {
        const response = await axios.get(`http://localhost:5000/heart-to-heart/available-slots?date=${date}`)
        commit('setAvailableSlots', response.data)
      } catch (error) {
        console.error('Failed to fetch available slots:', error)
      }
    },
    async scheduleSession({ commit }, slot) {
      try {
        const token = localStorage.getItem('token')
        const response = await axios.post('http://localhost:5000/heart-to-heart/schedule', slot, {
          headers: {
            Authorization: `Bearer ${token}`
          }
        })
        commit('setUserSchedule', response.data)
      } catch (error) {
        console.error('Failed to schedule session:', error)
        throw error
      }
    },
    async fetchUserSchedule({ commit }) {
      try {
        const token = localStorage.getItem('token')
        const response = await axios.get('http://localhost:5000/heart-to-heart/user-schedule', {
          headers: {
            Authorization: `Bearer ${token}`
          }
        })
        commit('setUserSchedule', response.data)
      } catch (error) {
        console.error('Failed to fetch user schedule:', error)
      }
    },
    async fetchAnnouncements({ commit }) {
      try {
        const response = await axios.get('http://localhost:5000/announcements')
        commit('setAnnouncements', response.data)
      } catch (error) {
        console.error('Failed to fetch announcements:', error)
      }
    }
  },
  getters: {
    getEmail: state => state.auth.email,
    isLoggedIn: state => state.auth.isLoggedIn,
    getUsername: state => state.auth.username,
    getUserInfo: state => state.auth.userInfo,
    getAvailableSlots: state => state.heartToHeart.availableSlots,
    getUserSchedule: state => state.heartToHeart.userSchedule,
    getAnnouncements: state => state.heartToHeart.announcements
  }
})