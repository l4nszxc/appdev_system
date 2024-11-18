import api from '@/services/api';

const state = {
    availability: {},
  };
  
  const getters = {
    getAvailability: (state) => state.availability,
  };
  
  const mutations = {
    setAvailability(state, availability) {
      state.availability = availability;
    },
  };
  
  const actions = {
    async fetchAvailability({ commit }) {
      const availability = await api.fetchAvailability(); // Mock API call
      commit('setAvailability', availability);
    },
    async updateAvailability({ commit }, { day, hour, available }) {
      await api.updateAvailability({ day, hour, available }); // Mock API call
      commit('setAvailability', { ...state.availability, [day]: { ...state.availability[day], [hour]: available } });
    },
  };
  
  export default {
    namespaced: true,
    state,
    getters,
    mutations,
    actions,
  };
  