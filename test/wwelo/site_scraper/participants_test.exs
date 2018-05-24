defmodule Wwelo.SiteScraper.ParticipantsTest do
  use Wwelo.DataCase
  alias Wwelo.SiteScraper.Participants
  alias Wwelo.SiteScraper.TestConsts.ParticipantConsts

  describe "Match results split into winners and losers" do
    test "Singles match with wrestlers with profiles" do
      singles_result = ParticipantConsts.singles_result()

      singles_outcome = ParticipantConsts.singles_outcome()

      map_set_output =
        MapSet.new(
          Participants.convert_result_to_participant_info(singles_result)
        )

      assert singles_outcome == map_set_output
    end

    test "Tag match with wrestlers with profiles" do
      tag_result = ParticipantConsts.tag_result()

      tag_outcome = ParticipantConsts.tag_outcome()

      map_set_output =
        MapSet.new(Participants.convert_result_to_participant_info(tag_result))

      assert tag_outcome == map_set_output
    end

    test "Triple threat match with wrestlers with profiles" do
      triple_threat_result = ParticipantConsts.triple_threat_result()

      triple_threat_outcome = ParticipantConsts.triple_threat_outcome()

      map_set_output =
        MapSet.new(
          Participants.convert_result_to_participant_info(triple_threat_result)
        )

      assert triple_threat_outcome == map_set_output
    end

    test "Singles match with wrestlers with profiles and managers" do
      singles_with_managers_result =
        ParticipantConsts.singles_with_managers_result()

      singles_with_managers_outcome =
        ParticipantConsts.singles_with_managers_outcome()

      map_set_output =
        MapSet.new(
          Participants.convert_result_to_participant_info(
            singles_with_managers_result
          )
        )

      assert singles_with_managers_outcome == map_set_output
    end

    test "Tag match with wrestlers with profiles and team names" do
      tag_with_team_names_result =
        ParticipantConsts.tag_with_team_names_result()

      tag_with_team_names_outcome =
        ParticipantConsts.tag_with_team_names_outcome()

      map_set_output =
        MapSet.new(
          Participants.convert_result_to_participant_info(
            tag_with_team_names_result
          )
        )

      assert tag_with_team_names_outcome == map_set_output
    end

    test "No contest match" do
      no_contest_result = ParticipantConsts.no_contest_result()

      no_contest_outcome = ParticipantConsts.no_contest_outcome()

      map_set_output =
        MapSet.new(
          Participants.convert_result_to_participant_info(no_contest_result)
        )

      assert no_contest_outcome == map_set_output
    end
  end
end
