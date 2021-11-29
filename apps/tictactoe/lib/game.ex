defmodule Tictactoe.Game do
  defstruct [
    uuid: "",
    state: [[nil,nil,nil], [nil,nil,nil], [nil,nil,nil]],
    user_x_uuid: "",
    user_o_uuid: "",
    turn: :user_x
  ]
end
