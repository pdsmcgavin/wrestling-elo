defmodule Mix.Tasks.MatchEloConstsJson do
  @moduledoc false
  use Mix.Task
  require Logger

  alias Wwelo.Utils.GetEloConsts

  @shortdoc "Checks front and back end elo consts match"
  def run(_) do
    "Running check on front and back end elo consts json" |> Logger.info()

    back_end_elo_consts = GetEloConsts.get_elo_consts()

    front_end_elo_consts_file = "assets/static/elo-consts.json"

    front_end_elo_consts =
      front_end_elo_consts_file
      |> File.read!()
      |> Poison.Parser.parse!(%{keys: :atoms})

    if back_end_elo_consts == front_end_elo_consts do
      "Front and back end elo consts json matches" |> Logger.info()
      exit(:normal)
    else
      %{
        back_end_elo_consts: back_end_elo_consts,
        front_end_elo_consts: front_end_elo_consts
      }
      |> Poison.encode!()
      |> Logger.error()

      exit({:elo_consts_mismatch, 1})
    end
  end
end
