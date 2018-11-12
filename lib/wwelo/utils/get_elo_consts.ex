defmodule Wwelo.Utils.GetEloConsts do
  @moduledoc false

  def get_elo_consts do
    with {:ok, body} <- File.read("lib/wwelo/utils/elo_consts.json"),
         {:ok, json} <- body |> Poison.Parser.parse(%{keys: :atoms}),
         do: json
  end
end
