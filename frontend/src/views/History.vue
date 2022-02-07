<template>
  <table class="history">
    <tr>
      <th>Opponent</th>
      <th>Status</th>
    </tr>
    <HistoryGameItem v-for="game in games" :key="game.uuid" :game="game" />
  </table>
</template>

<script>
import ApiService from "../services/ApiService";
import HistoryGameItem from "./HistoryGameItem"

export default {
  name: "History",
  components: {
    HistoryGameItem
  },
  data() {
    return {
      username: '',
      games: []
    }
  },
  created() {
    this.token = localStorage.token
    this.username = localStorage.username
    if (this.token && this.username) {
      this.fetchGamesList()
    }
  },
  methods: {
    fetchGamesList() {
      ApiService.userChecksTheirGames(this.token)
      .then(response => {
        this.games = response.data
      })
      .catch(error => {
        console.log(error)
      })
    },
  }
};
</script>

<style scoped>
  table.history {
    margin: auto;
  }
</style>
