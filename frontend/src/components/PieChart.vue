<template>
    <div>
      <Pie :data="chartData" :options="chartOptions" />
    </div>
  </template>
  
  <script>
  import { Pie } from 'vue-chartjs';
  import { Chart as ChartJS, Title, Tooltip, Legend, ArcElement, CategoryScale } from 'chart.js';
  
  ChartJS.register(Title, Tooltip, Legend, ArcElement, CategoryScale);
  
  export default {
    components: {
      Pie
    },
    props: {
      data: {
        type: Object,
        required: true
      }
    },
    computed: {
      chartData() {
        return {
          labels: ['Positive', 'Neutral', 'Negative'],
          datasets: [
            {
              label: 'Mood Distribution',
              backgroundColor: ['#36A2EB', '#FFCE56', '#FF6384'],
              data: [this.data.Positive, this.data.Neutral, this.data.Negative]
            }
          ]
        };
      },
      chartOptions() {
        return {
          responsive: true,
          maintainAspectRatio: false
        };
      }
    }
  };
  </script>
  
  <style scoped>
  .chart-container {
    position: relative;
    width: 100%;
    height: 400px;
  }
  </style>