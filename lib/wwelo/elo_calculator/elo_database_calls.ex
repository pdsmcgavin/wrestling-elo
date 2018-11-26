defmodule Wwelo.EloCalculator.EloDatabaseCalls do
  @moduledoc false

  import Ecto.Query

  alias Wwelo.Repo
  alias Wwelo.Stats
  alias Wwelo.Stats.Alias
  alias Wwelo.Stats.Elo
  alias Wwelo.Stats.Event
  alias Wwelo.Stats.Match
  alias Wwelo.Stats.Participant
  alias Wwelo.Stats.Wrestler
  alias Wwelo.Utils.GetEloConsts

  @elo_consts GetEloConsts.get_elo_consts()

  @spec list_of_matches_with_no_elo_calculation :: []
  def list_of_matches_with_no_elo_calculation do
    query =
      from(
        [e, m, elos] in event_match_elo_join(),
        select: m.id,
        order_by: [
          asc: e.date,
          asc: e.id,
          asc: m.card_position
        ],
        where: elos.id |> is_nil and e.date < ^Date.utc_today()
      )

    Repo.all(query)
  end

  @spec date_of_earliest_match_with_no_elo_calculation :: Date.t() | nil
  def date_of_earliest_match_with_no_elo_calculation do
    query =
      from(
        [e, m, elos] in event_match_elo_join(),
        select: e.date,
        order_by: [
          asc: e.date
        ],
        where: elos.id |> is_nil
      )

    query |> Repo.all() |> Enum.at(0)
  end

  @spec delete_elo_calculations_after_non_calculated_match(
          date :: Date.t() | nil
        ) :: :ok | nil
  def delete_elo_calculations_after_non_calculated_match(nil) do
  end

  def delete_elo_calculations_after_non_calculated_match(date) do
    query =
      from(
        e in Event,
        join: m in Match,
        on: m.event_id == e.id,
        join: elos in Elo,
        on: m.id == elos.match_id
      )

    query =
      from(
        [e, m, elos] in query,
        select: elos,
        where: e.date >= ^date
      )

    query |> Repo.all() |> Enum.each(&Repo.delete(&1))
  end

  @spec participants_info_of_match(match_id :: integer) :: [map]
  def participants_info_of_match(match_id) do
    match_wrestlers =
      from(
        m in Match,
        join: p in Participant,
        on: p.match_id == m.id,
        join: a in Alias,
        on: a.id == p.alias_id,
        join: w in Wrestler,
        on: w.id == a.wrestler_id
      )

    match_result_info =
      from(
        [m, p, a, w] in match_wrestlers,
        select: %{
          match_id: m.id,
          name: w.name,
          wrestler_id: w.id,
          match_outcome: p.outcome,
          match_team: p.match_team
        },
        where: m.id == ^match_id
      )

    match_result_info
    |> Repo.all()
    |> Enum.map(fn wrestler ->
      Map.put(
        wrestler,
        :previous_elo,
        get_most_recent_elo(wrestler.wrestler_id)
      )
    end)
  end

  @spec get_most_recent_elo(wrestler_id :: integer) :: float
  def get_most_recent_elo(wrestler_id) do
    query =
      from(
        [e, m, elos] in event_match_elo_join(),
        select: %{elo: elos.elo},
        order_by: [
          desc: e.date,
          desc: e.id,
          desc: m.card_position
        ],
        where: elos.wrestler_id == ^wrestler_id
      )

    matches = Repo.all(query)

    if matches |> length > 0 do
      matches |> Enum.at(0) |> Map.get(:elo)
    else
      @elo_consts.default_elo
    end
  end

  @spec save_elo_to_database(elo_info :: map) :: integer
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

    elo_result =
      case elo_result do
        nil -> elo_info |> Stats.create_elo() |> elem(1)
        _ -> elo_result
      end

    elo_result |> Map.get(:id)
  end

  defp event_match_elo_join() do
    from(
      e in Event,
      join: m in Match,
      on: m.event_id == e.id,
      left_join: elos in Elo,
      on: m.id == elos.match_id
    )
  end
end
