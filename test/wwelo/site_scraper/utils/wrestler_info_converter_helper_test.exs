defmodule Wwelo.SiteScraper.Utils.WrestlerInfoConverterHelperTest do
  use Wwelo.DataCase
  alias Wwelo.SiteScraper.Utils.WrestlerInfoConverterHelper

  describe "It should correctly take information from desired fields" do
    test "Gender of the wrestler will map to gender" do
      wrestler_info =
        {"", "", [{"", "", ["Gender:"]}, {"", "", ["wrestler_gender"]}]}

      converted_wrestler_info =
        WrestlerInfoConverterHelper.convert_wrestler_info(
          wrestler_info,
          %{}
        )

      assert converted_wrestler_info == %{gender: "wrestler_gender"}
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
               career_start_date: Ecto.Date.cast!("2000-12-25")
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
               career_end_date: Ecto.Date.cast!("2000-12-25")
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
end
