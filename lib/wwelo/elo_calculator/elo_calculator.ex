defmodule Wwelo.EloCalculator.EloCalculator do
  @moduledoc """
  Wrestler Elo calculation module
  """
  require Logger

  alias Wwelo.Utils.GetEloConsts
  alias Wwelo.EloCalculator.EloDatabaseCalls

  @elo_consts GetEloConsts.get_elo_consts()

  @doc """
  Calculates the Elo for match participants for all matches with no elo information and adds these to the elo database.

  Returns a list (matches) of lists (participants) with ids to the newly created rows in the elo databse

  ## Examples

    iex> Wwelo.EloCalculator.EloCalculator.calculate_elos
    [[1, 2], [3, 4, 5]]

  """
  @spec calculate_elos :: :ok
  def calculate_elos do
    Logger.warn("Calculating Elos")

    EloDatabaseCalls.date_of_earliest_match_with_no_elo_calculation()
    |> EloDatabaseCalls.delete_elo_calculations_after_non_calculated_match()

    EloDatabaseCalls.list_of_matches_with_no_elo_calculation()
    |> Enum.each(&calculate_and_save_elo_for_match(&1))
  end

  @spec calculate_and_save_elo_for_match(match_info :: map) :: :ok
  def calculate_and_save_elo_for_match(%{id: match_id, upcoming: upcoming}) do
    match_id
    |> EloDatabaseCalls.participants_info_of_match()
    |> group_participants_by_team
    |> elo_change_for_match(upcoming)
    |> Enum.each(&EloDatabaseCalls.save_elo_to_database(&1))
  end

  @spec group_participants_by_team([]) :: []
  defp group_participants_by_team(participants) do
    participants
    |> Enum.group_by(&Map.get(&1, :match_team))
    |> Map.values()
  end

  @spec elo_change_for_match(list_of_teams :: [[map]], upcoming :: boolean) ::
          [[map]]
  def elo_change_for_match(list_of_teams, upcoming \\ false) do
    team_ratings = Enum.map(list_of_teams, &sum_team_rating(&1))

    list_of_teams
    |> Enum.zip(team_ratings)
    |> Enum.map(&assign_team_member_rating(&1))
    |> Enum.map(&assign_outcome_value(&1))
    |> List.flatten()
    |> assign_odds_to_participants()
    |> normalise_multiperson_match_results()
    |> Enum.map(&assign_participant_elo_change(&1, upcoming))
  end

  @spec sum_team_rating(participants :: [map]) :: number
  defp sum_team_rating(participants) do
    participants
    |> Enum.reduce(0, fn participant, team_rating_acc ->
      team_rating_acc +
        Math.pow(
          @elo_consts.elo_base,
          participant.previous_elo / @elo_consts.distribution_factor
        )
    end)
  end

  @spec assign_team_member_rating(parameters :: {[map], number}) :: [map]
  defp assign_team_member_rating({team, rating}) do
    team
    |> Enum.map(fn participant ->
      Map.put(participant, :rating, rating)
    end)
  end

  @spec assign_outcome_value(team :: [map]) :: [map]
  defp assign_outcome_value(team) do
    team
    |> Enum.map(fn participant ->
      result_value =
        case participant.match_outcome do
          :win -> 1
          :draw -> 0.5
          :loss -> 0
        end

      Map.put(participant, :result_value, result_value)
    end)
  end

  @spec assign_odds_to_participants(participants :: [map]) :: [map]
  defp assign_odds_to_participants(participants) do
    sum_of_ratings =
      participants
      |> Enum.reduce(0, fn particpant, acc -> acc + particpant.rating end)

    participants
    |> Enum.map(fn participant ->
      Map.put(
        participant,
        :odds,
        participant.rating / sum_of_ratings
      )
    end)
  end

  @spec normalise_multiperson_match_results(participants :: [map]) :: [map]
  defp normalise_multiperson_match_results(participants) do
    sum_of_results =
      participants
      |> Enum.reduce(0, fn particpant, acc -> acc + particpant.result_value end)

    cond do
      sum_of_results == 1 ->
        participants

      sum_of_results > 1 ->
        participants
        |> Enum.map(fn participant ->
          Map.put(
            participant,
            :result_value,
            participant.result_value / sum_of_results
          )
        end)

      true ->
        Logger.error(
          "Incorrect match result scenario" <> Poison.encode!(participants)
        )

        []
    end
  end

  @spec assign_participant_elo_change(participant :: map, upcoming :: boolean) ::
          map
  defp assign_participant_elo_change(participant, true) do
    participant
    |> Map.put(:elo, participant.previous_elo)
    |> Map.put(:elo_before, participant.previous_elo)
  end

  defp assign_participant_elo_change(participant, _) do
    new_elo =
      participant.previous_elo +
        @elo_consts.match_weight * (participant.result_value - participant.odds)

    participant
    |> Map.put(:elo, new_elo)
    |> Map.put(:elo_before, participant.previous_elo)
  end
end
