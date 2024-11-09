<template>
    <div>
      <h1 class="green--text">Heart-to-Heart Room</h1>
  
      <v-card class="mt-5">
        <v-card-title>Add Available Schedule</v-card-title>
        <v-card-text>
          <v-form ref="form" v-model="valid">
            <v-row>
              <v-col cols="12" md="4">
                <v-text-field
                  label="Date"
                  v-model="newSchedule.date"
                  type="date"
                  required
                />
              </v-col>
              <v-col cols="12" md="4">
                <v-text-field
                  label="Start Time"
                  v-model="newSchedule.startTime"
                  type="time"
                  required
                />
              </v-col>
              <v-col cols="12" md="4">
                <v-text-field
                  label="End Time"
                  v-model="newSchedule.endTime"
                  type="time"
                  required
                />
              </v-col>
            </v-row>
            <v-btn color="green" @click="addSchedule">Add Schedule</v-btn>
          </v-form>
        </v-card-text>
      </v-card>
  
      <v-card class="mt-5">
        <v-card-title>Available Schedules</v-card-title>
        <v-data-table :headers="headers" :items="schedules" class="elevation-1">
          <template v-slot:item.actions="{ item }">
            <v-btn color="red" @click="removeSchedule(item._id)">Delete</v-btn>
          </template>
        </v-data-table>
      </v-card>
    </div>
  </template>
  
  <script>
  import axios from 'axios';
  
  export default {
    data() {
      return {
        newSchedule: { date: '', startTime: '', endTime: '' },
        schedules: [],
        headers: [
          { text: 'Date', value: 'date' },
          { text: 'Start Time', value: 'startTime' },
          { text: 'End Time', value: 'endTime' },
          { text: 'Actions', value: 'actions', sortable: false },
        ],
      };
    },
    methods: {
      async fetchSchedules() {
        const response = await axios.get('http://localhost:3000/api/schedule');
        this.schedules = response.data;
      },
      async addSchedule() {
        await axios.post('http://localhost:3000/api/schedule/add', this.newSchedule);
        this.newSchedule = { date: '', startTime: '', endTime: '' };
        this.fetchSchedules();
      },
      async removeSchedule(id) {
        await axios.delete(`http://localhost:3000/api/schedule/${id}`);
        this.fetchSchedules();
      },
    },
    created() {
      this.fetchSchedules();
    },
  };
  </script>
  
  <style scoped>
  .green--text {
    color: #4caf50 !important;
  }
  </style>
  