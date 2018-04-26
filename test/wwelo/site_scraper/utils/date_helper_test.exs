defmodule Wwelo.SiteScraper.Utils.DateHelperTest do
  use Wwelo.DataCase
  alias Wwelo.SiteScraper.Utils.DateHelper
  # TODO: Add tests for invalid dates
  describe "Given a date, it should returns an EctoDate object" do
    test "Full valid date will remain the same" do
      test_date = "25.12.2000"

      assert DateHelper.format_date(test_date) == Ecto.Date.cast({2000, 12, 25})
    end

    test "Valid date missing the day will default to the 1st of the month" do
      test_date = "12.2000"

      assert DateHelper.format_date(test_date) == Ecto.Date.cast({2000, 12, 1})
    end

    test "Valid year will default to the first day of the year" do
      test_date = "2000"

      assert DateHelper.format_date(test_date) == Ecto.Date.cast({2000, 1, 1})
    end
  end
end
