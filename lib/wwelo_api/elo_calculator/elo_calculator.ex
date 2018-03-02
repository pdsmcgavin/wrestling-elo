defmodule WweloApi.EloCalculator.EloCalculator do
  @match_weight 32
  @elo_base 10
  @distribution_factor 400

  def elo_change_for_match([list_of_participants, slist]) do
    rlist =
      list_of_participants
      |> Enum.map(fn participants ->
        participants
        |> Enum.reduce(0, fn x, acc ->
          acc + Math.pow(@elo_base, x / @distribution_factor)
        end)
      end)

    elist = rlist |> Enum.map(fn r -> r / Enum.sum(rlist) end)

    slist = slist |> Enum.map(&(&1 / Enum.sum(slist)))

    change =
      Enum.zip(elist, slist)
      |> Enum.map(fn {e, s} -> @match_weight * (s - e) end)

    Enum.zip(list_of_participants, change)
    |> Enum.map(fn {elos, change} ->
      Enum.map(elos, &(&1 + change / Enum.count(elos)))
    end)
  end
end