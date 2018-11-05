defmodule Wwelo.SiteScraper.Utils.WrestlerInfoConverterHelperTest do
  use Wwelo.DataCase
  alias Wwelo.SiteScraper.Utils.WrestlerInfoConverterHelper

  describe "It should correctly take information from desired fields" do
    test "Gender of the wrestler will map to gender" do
      wrestler_info = {"", "", [{"", "", ["Gender:"]}, {"", "", ["UNKNOWN"]}]}

      converted_wrestler_info =
        WrestlerInfoConverterHelper.convert_wrestler_info(
          wrestler_info,
          %{}
        )

      assert converted_wrestler_info == %{gender: :unknown}
    end

    test "Height of the wrestler will map to height" do
      wrestler_info =
        {"", "", [{"", "", ["Height:"]}, {"", "", ["72 (182 cm)"]}]}

      converted_wrestler_info =
        WrestlerInfoConverterHelper.convert_wrestler_info(
          wrestler_info,
          %{}
        )

      assert converted_wrestler_info == %{height: 182}
    end

    test "Weight of the wrestler will map to weight" do
      wrestler_info =
        {"", "", [{"", "", ["Weight:"]}, {"", "", ["154 (70 kg)"]}]}

      converted_wrestler_info =
        WrestlerInfoConverterHelper.convert_wrestler_info(
          wrestler_info,
          %{}
        )

      assert converted_wrestler_info == %{weight: 70}
    end

    test "Beginning of in-ring career of the wrestler will map to career_start_date" do
      wrestler_info =
        {"", "",
         [{"", "", ["Beginning of in-ring career:"]}, {"", "", ["25.12.2000"]}]}

      converted_wrestler_info =
        WrestlerInfoConverterHelper.convert_wrestler_info(
          wrestler_info,
          %{}
        )

      assert converted_wrestler_info == %{
               career_start_date: ~D[2000-12-25]
             }
    end

    test "End of in-ring career of the wrestler will map to career_end_date" do
      wrestler_info =
        {"", "",
         [
           {"", "", ["End of in-ring career:"]},
           {"", "", ["25.12.2000"]}
         ]}

      converted_wrestler_info =
        WrestlerInfoConverterHelper.convert_wrestler_info(
          wrestler_info,
          %{}
        )

      assert converted_wrestler_info == %{
               career_end_date: ~D[2000-12-25]
             }
    end

    test "Anything else will not be mapped" do
      wrestler_info = "nonsense"

      converted_wrestler_info =
        WrestlerInfoConverterHelper.convert_wrestler_info(
          wrestler_info,
          %{}
        )

      assert converted_wrestler_info == %{}
    end
  end

  describe "It should split up alter egos correctly" do
    test "No alter egos" do
      alter_ego_input = [
        {"a", [{"href", "?id=2&nr=13747&page=4&gimmick=Trent+Seven"}],
         ["Trent Seven"]}
      ]

      expected_alter_ego_output = %{"Trent Seven": ["Trent Seven"]}

      assert WrestlerInfoConverterHelper.get_names_and_aliases(alter_ego_input) ==
               expected_alter_ego_output
    end

    test "Multiple alter egos" do
      alter_ego_input = [
        {"a", [{"href", "?id=2&nr=16353&page=4&gimmick=Rick+Powers"}],
         ["Rick Powers"]},
        {"br", [], []},
        {"a", [{"href", "?id=2&nr=16353&page=4&gimmick=Slugger+Clark"}],
         ["Slugger Clark"]},
        {"br", [], []},
        "    ",
        {"span", [{"class", "TextLowlight"}], ["a.k.a."]},
        "  ",
        {"a", [{"href", "?id=2&nr=16353&page=4&gimmick=Patrick+Clark"}],
         ["Patrick Clark"]},
        {"br", [], []},
        {"a", [{"href", "?id=2&nr=16353&page=4&gimmick=Velveteen+Dream"}],
         ["Velveteen Dream"]}
      ]

      expected_alter_ego_output = %{
        "Rick Powers": ["Rick Powers"],
        "Slugger Clark": ["Slugger Clark", "Patrick Clark"],
        "Velveteen Dream": ["Velveteen Dream"]
      }

      assert WrestlerInfoConverterHelper.get_names_and_aliases(alter_ego_input) ==
               expected_alter_ego_output
    end
  end
end
