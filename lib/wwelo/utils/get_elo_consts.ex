defmodule Wwelo.Utils.GetEloConsts do
  @moduledoc false

  def get_elo_consts do
    with {:ok, body} <- File.read(elo_consts_location()),
         {:ok, json} <- body |> Poison.Parser.parse(%{keys: :atoms}),
         do: json
  end

  defp elo_consts_location do
    if Application.get_env(:wwelo, :environment) == :prod do
      "priv/static/elo-consts.json"
    else
      "assets/static/elo-consts.json"
    end
  end
end
