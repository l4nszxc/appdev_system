const api = {
    async fetchAvailability() {
      return { Monday: { 13: true }, 
      Tuesday: {}, 
      Wednesday: {}, 
      Thursday: {}, 
      Friday: {} };
    },
    async updateAvailability({ day, hour, available }) {
      console.log(`Updated availability for ${day} at ${hour}:00 to ${available}`);
    },
    async fetchSchedules() {
      return [{ id: 1, date: '2024-11-19', time: '13:00', User: { username: 'John' } }];
    },
    async updatePreferredTime(time) {
      console.log(`Updated preferred time to ${time}`);
    },
    async updateGoogleMeetLink(link) {
      console.log(`Updated Google Meet link to ${link}`);
    },
  };
  