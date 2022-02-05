<template>
  <div class="tictactoe-board">
    <div v-for="(n, i) in 3" :key="{ i }">
      <div v-for="(n, j) in 3" :key="{ j }" >
        <Cell :value="board[i][j]" :key="123"></Cell>
      </div>
    </div>
  </div>
</template>

<script>
import Cell from "./Cell";

export default {
  name: "Board",
  components: {
    Cell
  },
  data() { return {
    board: [
      ['', '', ''],
      ['', 'x', ''],
      ['', '', '']
    ]
  } },

}
</script>

<style>
.tictactoe-board {
  display: flex;
  flex-wrap: wrap;
  width: 204px;
  height: 204px;
}
</style>
