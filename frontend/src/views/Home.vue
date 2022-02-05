<template>
  <div class="home">
    <h1>Home</h1>
    <div v-if="showGame">
      <p>{{ token }}</p>
      <CurrentGame :gameUuid="gameUuid" :token="token"/>
    </div>
    <div v-else>
      <form @submit.prevent="enterGame" class="enter-form">
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
      username: '',
      token: null,
      gameUuid: null
    }
  },
  computed: {
    showGame() {
      return (this.gameUuid ? true : false)
    }
  },
  created() {
    this.token = localStorage.token
    this.username = localStorage.username
    if (this.token && this.username) {
      this.enterGame()
    }
  },
  methods: {
    enterGame() {
      ApiService.userEnters(this.username, this.token)
      .then(response => {
        this.token = localStorage.token = response.data["token"]
        this.username = localStorage.username = response.data["username"]
        this.gameUuid = response.data["game"]["uuid"]
      })
      .catch(error => {
        console.log(error)
      })

    }
  }
};
</script>
