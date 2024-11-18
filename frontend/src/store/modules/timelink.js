import api from '@/services/api';

const state = {
    preferredTime: '13:00', // Default time
    googleMeetLink: '',
  };
  
  const getters = {
    preferredTime: (state) => state.preferredTime,
    googleMeetLink: (state) => state.googleMeetLink,
  };
  
  const mutations = {
    setPreferredTime(state, time) {
      state.preferredTime = time;
    },
    setGoogleMeetLink(state, link) {
      state.googleMeetLink = link;
    },
  };
  
  const actions = {
    async updatePreferredTime({ commit }, time) {
      await api.updatePreferredTime(time); // Mock API call
      commit('setPreferredTime', time);
    },
    async updateGoogleMeetLink({ commit }, link) {
      await api.updateGoogleMeetLink(link); // Mock API call
      commit('setGoogleMeetLink', link);
    },
  };
  
  export default {
    namespaced: true,
    state,
    getters,
    mutations,
    actions,
  };
  