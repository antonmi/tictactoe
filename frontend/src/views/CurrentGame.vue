<template>
  <div class="current-game">
    <h1>Current Game</h1>
    <Board :field="field" @perform-move="performMove"/>
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
    gameUuid: String,
    token: String
  },
  data() {
    return {
      game: null
    }
  },
  computed: {
    field() {
      if (this.game) {
        return this.game["field"].map(function (el) {
          if (el == 1) {
            return 'x'
          } else if (el == 0) {
            return 'o'
          } else {
            return ''
          }
        })
      } else {
        return ['', '', '', '', '', '', '', '', '']
      }
    }
  },
  methods: {
    performMove(position) {
      console.log("----------")
      console.log(position)
      ApiService.userMoves(this.game.uuid, position, this.token)
      .then(response => {
        this.game = response.data["game"]
      })
      .catch(error => {
        console.log(error)
      })
    },
    setGame() {
      ApiService.gameInfo(this.gameUuid)
      .then(response => {
        this.game = response.data["game"]
      })
      .catch(error => {
        console.log(error)
      })
    }
  },
  created() {
    this.setGame()
    setInterval(() => {
      this.setGame()
    }, 3000)
  }
};
</script>
