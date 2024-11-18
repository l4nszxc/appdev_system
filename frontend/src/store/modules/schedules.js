import api from '@/services/api';

const state = {
    schedules: [],
  };
  
  const getters = {
    sortedSchedules: (state) => [...state.schedules].sort((a, b) => new Date(a.date) - new Date(b.date)),
  };
  
  const mutations = {
    setSchedules(state, schedules) {
      state.schedules = schedules;
    },
  };
  
  const actions = {
    async fetchSchedules({ commit }) {
      const schedules = await api.fetchSchedules(); // Mock API call
      commit('setSchedules', schedules);
    },
  };
  
  export default {
    namespaced: true,
    state,
    getters,
    mutations,
    actions,
  };
  