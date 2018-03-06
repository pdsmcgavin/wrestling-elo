defmodule WweloApi.EloCalculator.EloCalculator do
  import Ecto.Query

  alias WweloApi.Repo
  alias WweloApi.Stats.Alias
  alias WweloApi.Stats.Elo
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

  def list_of_matches_with_no_elo_calculation do
    query =
      from(
        e in Event,
        join: m in Match,
        on: m.event_id == e.id,
        left_join: elos in Elo,
        on: m.id == elos.match_id
      )

    query =
      from(
        [e, m, elos] in query,
        select: m.id,
        order_by: [
          asc: e.date,
          asc: e.id,
          asc: m.card_position
        ],
        where: elos.id |> is_nil
      )

    Repo.all(query)
  end

  def participants_info_of_match(match_id) do
    query =
      from(
        m in Match,
        join: p in Participant,
        on: p.match_id == m.id,
        join: a in Alias,
        on: a.id == p.alias_id,
        join: w in Wrestler,
        on: w.id == a.wrestler_id
      )

    query =
      from(
        [m, p, a, w] in query,
        select: {m.id, w.name, w.id, p.outcome, p.match_team},
        where: m.id == ^match_id
      )

    Repo.all(query)
  end
end
