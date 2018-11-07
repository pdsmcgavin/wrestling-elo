defmodule Wwelo.EloCalculator.EloCalculator do
  @moduledoc """
  Wrestler Elo calculation module
  """

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

  @doc """
  Calculates the Elo for match participants for all matches with no elo information and adds these to the elo database.

  Returns a list (matches) of lists (participants) with ids to the newly created rows in the elo databse

  ## Examples

    iex> Wwelo.EloCalculator.EloCalculator.calculate_elos
    [[1, 2], [3, 4, 5]]

  """
  @spec calculate_elos :: [[integer]]
  def calculate_elos do
    date_of_earlist_match_with_no_elo_calculation()
    |> delete_elo_calculations_after_non_calculated_match

    list_of_matches_with_no_elo_calculation()
    |> Enum.map(&calculate_and_save_elo_for_match(&1))
  end

  def calculate_and_save_elo_for_match(match_id) do
    match_id
    |> participants_info_of_match
    |> group_participants_by_team
    |> elo_change_for_match
    |> Enum.map(&save_elo_to_database(&1))
  end

  @spec elo_change_for_match(list_of_participants :: [[map]]) :: [[map]]
  def elo_change_for_match(list_of_participants) do
    elo_consts = GetEloConsts.get_elo_consts()

    rlist =
      list_of_participants
      |> Enum.map(fn participants ->
        participants
        |> Enum.reduce(0, fn x, acc ->
          acc +
            Math.pow(
              elo_consts.elo_base,
              x.previous_elo / elo_consts.distribution_factor
            )
        end)
      end)

    participants =
      list_of_participants
      |> Enum.zip(rlist)
      |> Enum.map(fn {participants, r_value} ->
        participants
        |> Enum.map(fn participant ->
          Map.put(participant, :r_value, r_value)
        end)
      end)
      |> List.flatten()

    r_total =
      participants
      |> Enum.reduce(0, fn particpant, acc -> acc + particpant.r_value end)

    participants =
      participants
      |> Enum.map(fn participant ->
        Map.put(participant, :e_value, participant.r_value / r_total)
      end)

    participants =
      participants
      |> Enum.map(fn participant ->
        s_value =
          case participant.match_outcome do
            :win -> 1
            :draw -> 0.5
            :loss -> 0
            _ -> nil
          end

        Map.put(participant, :s_value, s_value)
      end)

    s_total =
      participants
      |> Enum.reduce(0, fn particpant, acc -> acc + particpant.s_value end)

    participants =
      cond do
        s_total == 1 ->
          participants

        s_total > 1 ->
          participants
          |> Enum.map(fn participant ->
            Map.put(
              participant,
              :s_value,
              participant.s_value / s_total
            )
          end)

        true ->
          IO.puts("Incorrect match result scenario")
          # credo:disable-for-next-line
          IO.inspect(participants)
      end

    participants
    |> Enum.map(fn participant ->
      Map.put(
        participant,
        :elo,
        participant.previous_elo +
          elo_consts.match_weight * (participant.s_value - participant.e_value)
      )
    end)
  end

  @spec list_of_matches_with_no_elo_calculation :: []
  defp list_of_matches_with_no_elo_calculation do
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
        where: elos.id |> is_nil and e.date < ^Date.utc_today()
      )

    Repo.all(query)
  end

  @spec date_of_earlist_match_with_no_elo_calculation :: Date.t() | nil
  defp date_of_earlist_match_with_no_elo_calculation do
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
  defp delete_elo_calculations_after_non_calculated_match(nil) do
  end

  defp delete_elo_calculations_after_non_calculated_match(date) do
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
  defp participants_info_of_match(match_id) do
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
  defp get_most_recent_elo(wrestler_id) do
    elo_consts = GetEloConsts.get_elo_consts()

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

    if matches |> length > 0 do
      matches |> Enum.at(0) |> Map.get(:elo)
    else
      elo_consts.default_elo
    end
  end

  @spec group_participants_by_team([]) :: []
  defp group_participants_by_team(participants) do
    participants
    |> Enum.group_by(&Map.get(&1, :match_team))
    |> Map.values()
  end

  @spec save_elo_to_database(elo_info :: map) :: integer
  defp save_elo_to_database(elo_info) do
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
end
