defmodule WweloApi.SiteScraper.ParticipantsTest do
  use WweloApi.DataCase
  alias WweloApi.SiteScraper.Participants

  describe "Match results split into winners and losers" do
    @singles_match_result %{
      match_id: 1337,
      match_result: [
        {"a", [{"href", "?id=2&nr=801&name=AJ+Styles"}], ["AJ Styles"]},
        " defeats ",
        {"a", [{"href", "?id=2&nr=12474&name=Baron+Corbin"}], ["Baron Corbin"]},
        " (11:33)"
      ]
    }

    @singles_outcome MapSet.new([
                       %{
                         alias: "AJ Styles",
                         profile_url: "?id=2&nr=801&name=AJ+Styles",
                         outcome: "win",
                         match_id: 1337,
                         match_team: 0
                       },
                       %{
                         alias: "Baron Corbin",
                         profile_url: "?id=2&nr=12474&name=Baron+Corbin",
                         outcome: "loss",
                         match_id: 1337,
                         match_team: 1
                       }
                     ])

    test "Singles match with wrestler's with profiles" do
      map_set_output =
        MapSet.new(
          Participants.convert_result_to_participant_info(@singles_match_result)
        )

      assert @singles_outcome = map_set_output
    end
  end
end
