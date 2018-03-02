defmodule WweloApi.EloCalculator.EloCalculator do
  import Ecto.Query

  alias WweloApi.Repo
  alias WweloApi.Stats.Alias
  alias WweloApi.Stats.Event
  alias WweloApi.Stats.Match
  alias WweloApi.Stats.Participant
  alias WweloApi.Stats.Wrestler

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

  # TODO. Separate into smaller functions
  def event_match_participant_join(amount) do
    query =
      from(
        e in Event,
        join: m in Match,
        where: m.event_id == e.id,
        join: p in Participant,
        where: p.match_id == m.id,
        join: a in Alias,
        where: a.id == p.alias_id,
        join: w in Wrestler,
        where: w.id == a.wrestler_id
      )

    query =
      from(
        [e, m, p, a, w] in query,
        select:
          {e.name, e.date, m.card_position, p.outcome, a.name, w.current_elo},
        order_by: [
          asc: e.date,
          asc: e.id,
          asc: m.card_position,
          desc: p.outcome
        ],
        where: p.elo_after |> is_nil
      )

    Repo.all(query) |> Enum.slice(0, amount)
  end
end
