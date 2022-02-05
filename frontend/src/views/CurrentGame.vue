<template>
  <div class="current-game">
    <h1>Current Game</h1>
    <Board />
  </div>
</template>

<script>
// @ is an alias to /src
import Board from "@/components/Board.vue";
import ApiService from "../services/ApiService";

export default {
  name: "CurrentGame",
  components: {
    Board,
  },
  props: {
    game: Object,
    token: String
  },
  data() {
    return {
      uuid: null,
      field: null,
      turn_uuid: null,
      me: null,
      player_type: null,
      opponent: null
    }
  },
  created() {
    this.uuid = localStorage.gameUiid
    ApiService.gameInfo(this.uuid)
    .then(response => {
      console.log(response.data)
      // this.field = game["field"]
      // this.turn_uuid = game["turn_uuid"]
      // let user_x = JSON.parse(localStorage.currentGameUserX)
      // let user_o = JSON.parse(localStorage.currentGameUserO)
      // if (user_x["uuid"] == token) {
      //   this.me = user_x["name"]
      //   this.player_type = 'x'
      //   this.opponent = user_o["name"]
      // } else {
      //   this.me = user_o["name"]
      //   this.player_type = 'o'
      //   this.opponent = user_x["name"]
      // }
    })
    .catch(error => {
      console.log(error)
    })
  }
};
</script>
