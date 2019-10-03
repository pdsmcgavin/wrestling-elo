defmodule Wwelo.SiteScraper.ParticipantsTest do
  use Wwelo.DataCase
  alias Wwelo.SiteScraper.Participants
  alias Wwelo.SiteScraper.TestConsts.ParticipantConsts

  describe "Match results split into winners and losers with profiles" do
    test "Singles match with wrestlers" do
      singles_result = ParticipantConsts.singles_result()

      singles_outcome = ParticipantConsts.singles_outcome()

      map_set_output =
        MapSet.new(
          Participants.convert_result_to_participant_info(singles_result)
        )

      assert singles_outcome == map_set_output
    end

    test "Tag match with wrestlers" do
      tag_result = ParticipantConsts.tag_result()

      tag_outcome = ParticipantConsts.tag_outcome()

      map_set_output =
        MapSet.new(Participants.convert_result_to_participant_info(tag_result))

      assert tag_outcome == map_set_output
    end

    test "Triple threat match with wrestlers" do
      triple_threat_result = ParticipantConsts.triple_threat_result()

      triple_threat_outcome = ParticipantConsts.triple_threat_outcome()

      map_set_output =
        MapSet.new(
          Participants.convert_result_to_participant_info(triple_threat_result)
        )

      assert triple_threat_outcome == map_set_output
    end

    test "Singles match with wrestlers and managers" do
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

    test "Tag match with wrestlers and team names" do
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

    test "Singles match draw with a chmpion wrestler with manager" do
      singles_result_draw_champion_with_manager =
        ParticipantConsts.singles_result_draw_champion_with_manager()

      singles_outcome_draw_champion_with_manager =
        ParticipantConsts.singles_outcome_draw_champion_with_manager()

      map_set_output =
        MapSet.new(
          Participants.convert_result_to_participant_info(
            singles_result_draw_champion_with_manager
          )
        )

      assert singles_outcome_draw_champion_with_manager == map_set_output
    end

    test "Singles match with wrestlers with extra match info" do
      singles_result_extra_match_info =
        ParticipantConsts.singles_result_extra_match_info()

      singles_outcome_extra_match_info =
        ParticipantConsts.singles_outcome_extra_match_info()

      map_set_output =
        MapSet.new(
          Participants.convert_result_to_participant_info(
            singles_result_extra_match_info
          )
        )

      assert singles_outcome_extra_match_info == map_set_output
    end

    test "Champ v champ match with wrestlers" do
      champ_v_champ_result_match_info =
        ParticipantConsts.champ_v_champ_result_match_info()

      champ_v_champ_outcome_match_info =
        ParticipantConsts.champ_v_champ_outcome_match_info()

      map_set_output =
        MapSet.new(
          Participants.convert_result_to_participant_info(
            champ_v_champ_result_match_info
          )
        )

      assert champ_v_champ_outcome_match_info == map_set_output
    end

    test "Tag match double DQ with managers" do
      tag_result_double_dq_with_manager =
        ParticipantConsts.tag_result_double_dq_with_manager()

      tag_outcome_double_dq_with_manager =
        ParticipantConsts.tag_outcome_double_dq_with_manager()

      map_set_output =
        MapSet.new(
          Participants.convert_result_to_participant_info(
            tag_result_double_dq_with_manager
          )
        )

      assert tag_outcome_double_dq_with_manager == map_set_output
    end

    test "Tag match with champions" do
      tag_result_champions = ParticipantConsts.tag_result_champions()

      tag_outcome_champions = ParticipantConsts.tag_outcome_champions()

      map_set_output =
        MapSet.new(
          Participants.convert_result_to_participant_info(tag_result_champions)
        )

      assert tag_outcome_champions == map_set_output
    end

    test "Survivor Series match with managers" do
      survivor_series_result_with_managers =
        ParticipantConsts.survivor_series_result_with_managers()

      survivor_series_outcome_with_managers =
        ParticipantConsts.survivor_series_outcome_with_managers()

      map_set_output =
        MapSet.new(
          Participants.convert_result_to_participant_info(
            survivor_series_result_with_managers
          )
        )

      assert survivor_series_outcome_with_managers == map_set_output
    end
  end

  describe "Match results split into winners and losers without all having profiles" do
    test "Singles match with wrestlers neither with profiles" do
      singles_result_no_profile = ParticipantConsts.singles_result_no_profile()

      singles_outcome_no_profile =
        ParticipantConsts.singles_outcome_no_profile()

      map_set_output =
        MapSet.new(
          Participants.convert_result_to_participant_info(
            singles_result_no_profile
          )
        )

      assert singles_outcome_no_profile == map_set_output
    end

    test "Singles match with wrestlers neither with profiles with extra match info" do
      singles_result_no_profile_2_3_falls =
        ParticipantConsts.singles_result_no_profile_2_3_falls()

      singles_outcome_no_profile_2_3_falls =
        ParticipantConsts.singles_outcome_no_profile_2_3_falls()

      map_set_output =
        MapSet.new(
          Participants.convert_result_to_participant_info(
            singles_result_no_profile_2_3_falls
          )
        )

      assert singles_outcome_no_profile_2_3_falls == map_set_output
    end

    test "Singles match with wrestlers no loser profiles" do
      singles_result_no_loser_profile =
        ParticipantConsts.singles_result_no_loser_profile()

      singles_outcome_no_loser_profile =
        ParticipantConsts.singles_outcome_no_loser_profile()

      map_set_output =
        MapSet.new(
          Participants.convert_result_to_participant_info(
            singles_result_no_loser_profile
          )
        )

      assert singles_outcome_no_loser_profile == map_set_output
    end

    test "Singles match with wrestlers no winner profiles" do
      singles_result_no_winner_profile =
        ParticipantConsts.singles_result_no_winner_profile()

      singles_outcome_no_winner_profile =
        ParticipantConsts.singles_outcome_no_winner_profile()

      map_set_output =
        MapSet.new(
          Participants.convert_result_to_participant_info(
            singles_result_no_winner_profile
          )
        )

      assert singles_outcome_no_winner_profile == map_set_output
    end

    test "Singles match with wrestlers no winner profiles with_manager" do
      singles_result_no_winner_profile_with_manager =
        ParticipantConsts.singles_result_no_winner_profile_with_manager()

      singles_outcome_no_winner_profile_with_manager =
        ParticipantConsts.singles_outcome_no_winner_profile_with_manager()

      map_set_output =
        MapSet.new(
          Participants.convert_result_to_participant_info(
            singles_result_no_winner_profile_with_manager
          )
        )

      assert singles_outcome_no_winner_profile_with_manager == map_set_output
    end

    test "Tag match with wrestlers one winner profiles" do
      tag_result_one_winner_profile =
        ParticipantConsts.tag_result_one_winner_profile()

      tag_outcome_one_winner_profile =
        ParticipantConsts.tag_outcome_one_winner_profile()

      map_set_output =
        MapSet.new(
          Participants.convert_result_to_participant_info(
            tag_result_one_winner_profile
          )
        )

      assert tag_outcome_one_winner_profile == map_set_output
    end

    test "Tag match with wrestlers no losers profiles" do
      tag_result_no_losers_profile =
        ParticipantConsts.tag_result_no_losers_profile()

      tag_outcome_no_losers_profile =
        ParticipantConsts.tag_outcome_no_losers_profile()

      map_set_output =
        MapSet.new(
          Participants.convert_result_to_participant_info(
            tag_result_no_losers_profile
          )
        )

      assert tag_outcome_no_losers_profile == map_set_output
    end

    test "Handicap match with wrestlers no losers profiles" do
      handicap_result_no_losers_profile =
        ParticipantConsts.handicap_result_no_losers_profile()

      handicap_outcome_no_losers_profile =
        ParticipantConsts.handicap_outcome_no_losers_profile()

      map_set_output =
        MapSet.new(
          Participants.convert_result_to_participant_info(
            handicap_result_no_losers_profile
          )
        )

      assert handicap_outcome_no_losers_profile == map_set_output
    end

    test "Handicap match with wrestlers one loser profiles" do
      handicap_result_one_loser_profile =
        ParticipantConsts.handicap_result_one_loser_profile()

      handicap_outcome_one_loser_profile =
        ParticipantConsts.handicap_outcome_one_loser_profile()

      map_set_output =
        MapSet.new(
          Participants.convert_result_to_participant_info(
            handicap_result_one_loser_profile
          )
        )

      assert handicap_outcome_one_loser_profile == map_set_output
    end

    test "Multi-man match with wrestlers one missing loser profiles" do
      multi_man_result_one_missing_loser_profile =
        ParticipantConsts.multi_man_result_one_missing_loser_profile()

      multi_man_outcome_one_missing_loser_profile =
        ParticipantConsts.multi_man_outcome_one_missing_loser_profile()

      map_set_output =
        MapSet.new(
          Participants.convert_result_to_participant_info(
            multi_man_result_one_missing_loser_profile
          )
        )

      assert multi_man_outcome_one_missing_loser_profile == map_set_output
    end

    test "Singles match with wrestlers one drawer profiles" do
      singles_result_one_drawer_profile =
        ParticipantConsts.singles_result_one_drawer_profile()

      singles_outcome_one_drawer_profile =
        ParticipantConsts.singles_outcome_one_drawer_profile()

      map_set_output =
        MapSet.new(
          Participants.convert_result_to_participant_info(
            singles_result_one_drawer_profile
          )
        )

      assert singles_outcome_one_drawer_profile == map_set_output
    end
  end
end
