defmodule Tictactoe.Move do
  defstruct [
    user_uuid: "",
    movement: 0,
    result: nil, #continue, victory, draw
    error: nil
  ]
end
