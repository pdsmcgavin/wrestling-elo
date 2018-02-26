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

    test "Singles match with wrestlers with profiles" do
      map_set_output =
        MapSet.new(
          Participants.convert_result_to_participant_info(@singles_match_result)
        )

      assert @singles_outcome = map_set_output
    end

    @singles_match_with_managers_result %{
      match_id: 2020,
      match_result: [
        {"a", [{"href", "?id=2&nr=6171&name=Jinder+Mahal"}], ["Jinder Mahal"]},
        " (w/",
        {"a", [{"href", "?id=2&nr=6304&name=Samir+Singh"}], ["Samir Singh"]},
        " & ",
        {"a", [{"href", "?id=2&nr=6303&name=Sunil+Singh"}], ["Sunil Singh"]},
        ") defeats ",
        {"a", [{"href", "?id=2&nr=3190&name=Tye+Dillinger"}], ["Tye Dillinger"]},
        " (9:00)"
      ]
    }

    @singles_with_managers_outcome MapSet.new([
                                     %{
                                       alias: "Jinder Mahal",
                                       profile_url:
                                         "?id=2&nr=801&name=AJ+Styles",
                                       outcome: "win",
                                       match_id: 2020,
                                       match_team: 0
                                     },
                                     %{
                                       alias: "Tye Dillinger",
                                       profile_url:
                                         "?id=2&nr=3190&name=Tye+Dillinger",
                                       outcome: "loss",
                                       match_id: 2020,
                                       match_team: 1
                                     }
                                   ])

    test "Singles match with wrestlers with profiles and managers" do
      map_set_output =
        MapSet.new(
          Participants.convert_result_to_participant_info(
            @singles_match_with_managers_result
          )
        )

      assert @singles_with_managers_outcome = map_set_output
    end
  end
end
