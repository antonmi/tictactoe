ExUnit.start()

if String.ends_with?(File.cwd!(), "apps/web") do
  root_path = Path.expand("../../../..", __ENV__.file)
  Code.eval_file("apps/tictactoe/test/test_helper.exs", root_path)
end
