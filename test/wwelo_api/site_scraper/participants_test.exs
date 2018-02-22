defmodule WweloApi.SiteScraper.ParticipantsTest do
  use WweloApi.DataCase
  alias WweloApi.SiteScraper.Participants

  describe "Match results split into winners and losers" do
    @singles_match_result %{
      match_result: [
        {"a", [{"href", "?id=2&nr=801&name=AJ+Styles"}], ["AJ Styles"]},
        " defeats ",
        {"a", [{"href", "?id=2&nr=12474&name=Baron+Corbin"}], ["Baron Corbin"]},
        " (11:33)"
      ]
    }

    @singles_outcome %{winners: "AJ Styles", losers: "Baron Corbin"}

    test "Singles match with wrestler's with profiles" do
      assert @singles_outcome =
               Participants.split_result_into_winners_and_losers(
                 @singles_match_result
               )
    end
  end
end
