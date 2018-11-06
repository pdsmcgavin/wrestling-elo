defmodule Wwelo.SiteScraper.Utils.EventInfoConverterHelperTest do
  use Wwelo.DataCase
  alias Wwelo.SiteScraper.Utils.EventInfoConverterHelper

  describe "It should correctly take information from desired fields" do
    test "Name of the event will map to name" do
      event_info =
        {"", "", [{"", "", ["Name of the event:"]}, {"", "", ["event_name"]}]}

      converted_event_info =
        EventInfoConverterHelper.convert_event_info(
          event_info,
          %{}
        )

      assert converted_event_info == %{name: "event_name"}
    end

    test "Promotion will map to promotion" do
      event_info =
        {"", "",
         [{"", "", ["Promotion:"]}, {"", "", [{"", "", ["event_promotion"]}]}]}

      converted_event_info =
        EventInfoConverterHelper.convert_event_info(
          event_info,
          %{}
        )

      assert converted_event_info == %{promotion: "event_promotion"}
    end

    test "Type will map to type" do
      event_info = {"", "", [{"", "", ["Type:"]}, {"", "", ["Pay Per View"]}]}

      converted_event_info =
        EventInfoConverterHelper.convert_event_info(
          event_info,
          %{}
        )

      assert converted_event_info == %{event_type: :ppv}
    end

    test "Location will map to location" do
      event_info =
        {"", "", [{"", "", ["Location:"]}, {"", "", ["event_location"]}]}

      converted_event_info =
        EventInfoConverterHelper.convert_event_info(
          event_info,
          %{}
        )

      assert converted_event_info == %{location: "event_location"}
    end

    test "Arena will map to arena" do
      event_info = {"", "", [{"", "", ["Arena:"]}, {"", "", ["event_arena"]}]}

      converted_event_info =
        EventInfoConverterHelper.convert_event_info(
          event_info,
          %{}
        )

      assert converted_event_info == %{arena: "event_arena"}
    end

    test "Date will map to date" do
      event_info = {"", "", [{"", "", ["Date:"]}, {"", "", ["21.11.2000"]}]}

      converted_event_info =
        EventInfoConverterHelper.convert_event_info(
          event_info,
          %{}
        )

      assert converted_event_info == %{
               date: ~D[2000-11-21]
             }
    end

    test "Broadcast date will map to date" do
      event_info =
        {"", "", [{"", "", ["Broadcast date:"]}, {"", "", ["21.11.2000"]}]}

      converted_event_info =
        EventInfoConverterHelper.convert_event_info(
          event_info,
          %{}
        )

      assert converted_event_info == %{
               date: ~D[2000-11-21]
             }
    end

    test "Broadcast date will trump date and map to date" do
      event_info = {"", "", [{"", "", ["Date:"]}, {"", "", ["15.11.2001"]}]}

      converted_event_info =
        EventInfoConverterHelper.convert_event_info(
          event_info,
          %{}
        )

      second_event_info =
        {"", "", [{"", "", ["Broadcast date:"]}, {"", "", ["21.11.2000"]}]}

      converted_event_info =
        EventInfoConverterHelper.convert_event_info(
          second_event_info,
          converted_event_info
        )

      assert converted_event_info == %{
               date: ~D[2000-11-21]
             }
    end

    test "Date will not trump broadcast date and map to date" do
      event_info =
        {"", "", [{"", "", ["Broadcast date:"]}, {"", "", ["15.11.2001"]}]}

      converted_event_info =
        EventInfoConverterHelper.convert_event_info(
          event_info,
          %{}
        )

      second_event_info =
        {"", "", [{"", "", ["Date:"]}, {"", "", ["21.11.2000"]}]}

      converted_event_info =
        EventInfoConverterHelper.convert_event_info(
          second_event_info,
          converted_event_info
        )

      assert converted_event_info == %{
               date: ~D[2001-11-15]
             }
    end

    test "An invalid date will not be mapped" do
      event_info = {"", "", [{"", "", ["Date:"]}, {"", "", ["Invalid Date"]}]}

      converted_event_info =
        EventInfoConverterHelper.convert_event_info(
          event_info,
          %{}
        )

      assert converted_event_info == %{}
    end

    test "An invalid broadcast date will not be mapped" do
      event_info =
        {"", "", [{"", "", ["Broadcast date:"]}, {"", "", ["Invalid Date"]}]}

      converted_event_info =
        EventInfoConverterHelper.convert_event_info(
          event_info,
          %{}
        )

      assert converted_event_info == %{}
    end

    test "Anything else will not be mapped" do
      event_info = "nonsense"

      converted_event_info =
        EventInfoConverterHelper.convert_event_info(
          event_info,
          %{}
        )

      assert converted_event_info == %{}
    end
  end
end
