import { createStore } from 'vuex'

export default createStore({
  state: {
    auth: {
      email: null
    }
  },
  mutations: {
    setEmail(state, email) {
      state.auth.email = email
    }
  },
  actions: {
    setEmail({ commit }, email) {
      commit('setEmail', email)
    }
  },
  getters: {
    getEmail: state => state.auth.email
  }
})