defmodule WweloApi.EloCalculator.EloCalculator do
  import Ecto.Query

  alias WweloApi.Repo
  alias WweloApi.Stats
  alias WweloApi.Stats.Alias
  alias WweloApi.Stats.Elo
  alias WweloApi.Stats.Event
  alias WweloApi.Stats.Match
  alias WweloApi.Stats.Participant
  alias WweloApi.Stats.Wrestler

  @default_elo 1200
  @match_weight 32
  @elo_base 10
  @distribution_factor 400

  def calcualte_elos do
    list_of_matches_with_no_elo_calculation()
    |> Enum.map(fn match_id ->
      participants_info_of_match(match_id)
      |> group_participants_by_team
      |> elo_change_for_match
      |> List.flatten()
      |> Enum.map(fn elo_info ->
        save_elo_to_database(elo_info)
      end)
    end)
  end

  def elo_change_for_match(list_of_participants) do
    rlist =
      list_of_participants
      |> Enum.map(fn participants ->
        participants
        |> Enum.reduce(0, fn x, acc ->
          acc +
            Math.pow(
              @elo_base,
              x.previous_elo / @distribution_factor
            )
        end)
      end)

    elist = rlist |> Enum.map(fn r -> r / Enum.sum(rlist) end)

    slist =
      list_of_participants
      |> Enum.map(fn participant ->
        outcome = Enum.at(participant, 0) |> Map.get(:match_outcome)

        case outcome do
          "win" -> 1
          "loss" -> 0
          "draw" -> 0.5
          _ -> nil
        end
      end)

    slist =
      cond do
        Enum.sum(slist) > 1 -> slist |> Enum.map(&(&1 / Enum.sum(slist)))
        true -> slist
      end

    change =
      Enum.zip(elist, slist)
      |> Enum.map(fn {e, s} -> @match_weight * (s - e) end)

    Enum.zip(list_of_participants, change)
    |> Enum.map(fn {participants, change} ->
      participants
      |> Enum.map(fn participant ->
        Map.put(
          participant,
          :elo,
          participant.previous_elo + change / Enum.count(participants)
        )
      end)
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
        select: %{
          match_id: m.id,
          name: w.name,
          wrestler_id: w.id,
          match_outcome: p.outcome,
          match_team: p.match_team
        },
        where: m.id == ^match_id
      )

    Repo.all(query)
    |> Enum.map(fn wrestler ->
      Map.put(
        wrestler,
        :previous_elo,
        get_most_recent_elo(wrestler.wrestler_id)
      )
    end)
  end

  def get_most_recent_elo(wrestler_id) do
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
        select: %{elo: elos.elo},
        order_by: [
          desc: e.date,
          desc: e.id,
          desc: m.card_position
        ],
        where: elos.wrestler_id == ^wrestler_id
      )

    matches = Repo.all(query)

    cond do
      matches |> length > 0 -> matches |> Enum.at(0) |> Map.get(:elo)
      true -> @default_elo
    end
  end

  def group_participants_by_team(participants) do
    participants
    |> Enum.group_by(&Map.get(&1, :match_team))
    |> Map.values()
  end

  def save_elo_to_database(elo_info) do
    elo_query =
      from(
        e in Elo,
        where:
          e.match_id == ^elo_info.match_id and
            e.wrestler_id == ^elo_info.wrestler_id,
        select: e
      )

    elo_result = Repo.one(elo_query)

    case elo_result do
      nil -> Stats.create_elo(elo_info) |> elem(1)
      _ -> elo_result
    end
    |> Map.get(:id)
  end
end