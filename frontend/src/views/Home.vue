<template>
  <div class="home">
    <h1>Home</h1>
    <div v-if="showGame">
      <p>{{ token }}</p>
      <CurrentGame :game="game" :token="token"/>
    </div>
    <div v-else>
      <form @submit.prevent="enterName" class="enter-form">
        <h3>Enter your name</h3>
        <label for="username">Name:</label>
        <input id="username" v-model="username">

        <input class="button" type="submit" value="Submit">
      </form>
    </div>
  </div>
</template>

<script>
// @ is an alias to /src
import ApiService from "../services/ApiService";
import CurrentGame from "./CurrentGame";

export default {
  name: "Home",
  components: {
    CurrentGame
  },
  data() {
    return {
      username: null,
      token: null,
      game: null
    }
  },
  computed: {
    showGame() {
      console.log(localStorage.gameUuid)
      return (localStorage.gameUuid ? true : false)
    }
  },
  created() {
    console.log(localStorage.token)
    this.token = localStorage.token
    this.enterName()
  },
  methods: {
    enterName() {
      ApiService.userEnters(this.username, this.token)
      .then(response => {
        this.token = localStorage.token = response.data["token"]
        this.username = localStorage.username = response.data["username"]
        this.game = response.data["game"]
      })
      .catch(error => {
        console.log(error)
      })

    }
  }
};
</script>
