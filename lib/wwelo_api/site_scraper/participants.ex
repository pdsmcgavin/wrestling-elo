defmodule WweloApi.SiteScraper.Participants do
  import Ecto.Query

  alias WweloApi.Repo
  alias WweloApi.Stats
  alias WweloApi.Stats.Participant

  def save_participants_of_match(%{
        match_id: match_id,
        match_result: match_result
      }) do
    participant_info = %{match_id: match_id}

    match_result
  end

  def save_participant_to_database(participant_info) do
    participant_query =
      from(
        p in Participant,
        where:
          p.match_id == ^participant_info.match_id and
            p.wrestler_id == ^participant_info.wrestler_id,
        select: p
      )

    participant_result = Repo.one(participant_query)

    case participant_result do
      nil -> Stats.create_participant(participant_info) |> elem(1)
      _ -> participant_result
    end
  end
end
