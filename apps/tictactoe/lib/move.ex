defmodule Tictactoe.Move do
  defstruct user_uuid: "",
            position: 0,
            result: nil,
            error: nil

  @type t :: %__MODULE__{
          user_uuid: String.t(),
          position: 0,
          result: :continue | :victory | :draw,
          error: atom()
        }
end
