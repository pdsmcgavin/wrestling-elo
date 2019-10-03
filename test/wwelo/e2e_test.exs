defmodule ScraperTest do
  use ExUnit.Case, async: false
  use Wwelo.DataCase
  alias Wwelo.EloCalculator.EloCalculator
  alias Wwelo.SiteScraper.Scraper
  alias Wwelo.SiteScraper.Utils.UrlHelper
  alias Wwelo.Stats
  import Mock

  test "SiteScraper" do
    mocked_year = 1000

    mocked_search_event_url = UrlHelper.wwe_events_results_url(mocked_year, 1)

    mocked_search_event_body = [
      {"div", [{"class", "TableContents"}],
       [
         {"div", [],
          [
            {"tr", [], [""]},
            {"tr", [],
             [
               {"td", [], [""]},
               {"td", [], ["01.01.1337"]},
               {"td", [],
                [
                  {"a", [{"href", "EVENT_URL"}], ["EVENT_NAME"]}
                ]},
               {"td", [], ["LOCATION, COUNTRY"]},
               {"td", [], [""]},
               {"td", [], [""]},
               {"td", [], [""]},
               {"td", [], [""]}
             ]}
          ]}
       ]},
      {"div", [{"class", "TableHeaderOff"}, {"id", "TableHeader"}],
       [
         "Displaying items 1 to 24 of total 24 items that match the search parameters."
       ]}
    ]

    mocked_event_page_url = "https://www.cagematch.net/EVENT_URL"

    mocked_event_page_body = [
      {"div", [{"class", "InformationBoxTable"}],
       [
         {"div", [],
          [
            {"div", [], ["Name of the event:"]},
            {"div", [], ["EVENT_NAME"]}
          ]},
         {"div", [],
          [
            {"div", [], ["Date:"]},
            {"div", [], [{"div", [], ["01.01.1337"]}]}
          ]},
         {"div", [],
          [
            {"div", [], ["Promotion:"]},
            {"div", [],
             [
               {"a", [], ["EVENT_PROMOTION"]}
             ]}
          ]},
         {"div", [],
          [
            {"div", [], ["Type:"]},
            {"div", [], [{"div", [], ["Pay Per View"]}]}
          ]},
         {"div", [],
          [
            {"div", [], ["Location:"]},
            {"div", [], [{"div", [], ["EVENT_LOCATION"]}]}
          ]},
         {"div", [],
          [
            {"div", [], ["Arena:"]},
            {"div", [], [{"div", [], ["EVENT_ARENA"]}]}
          ]}
       ]},
      {"div", [{"class", "Matches"}],
       [
         {"div", [{"class", "Match"}],
          [
            {"div", [{"class", "MatchType"}], ["MATCH_TYPE"]},
            {"div", [{"class", "MatchResults"}],
             [
               {"a", [{"href", "?id=2&WRESTLER_WINNER_URL"}],
                ["WRESTLER_WINNER"]},
               " defeats ",
               {"a", [{"href", "?id=2&WRESTLER_LOSER_URL"}], ["WRESTLER_LOSER"]}
             ]}
          ]}
       ]}
    ]

    mocked_winner_page_url =
      "https://www.cagematch.net/?id=2&WRESTLER_WINNER_URL"

    mocked_winner_page_body = [
      {"div", [],
       [
         {"div", [], ["Gender:"]},
         {"div", [], ["male"]}
       ]},
      {"div", [],
       [
         {"div", [], ["Height:"]},
         {"div", [], ["6' 0\" (183 cm)"]}
       ]},
      {"div", [],
       [
         {"div", [], ["Weight:"]},
         {"div", [], ["220 lbs (100 kg)"]}
       ]},
      {"div", [],
       [
         {"div", [], ["Alter egos:"]},
         {"div", [],
          [
            {"a", [], ["WINNER_NAME_1"]},
            {"br", [], []},
            "    ",
            {"span", [], ["a.k.a."]},
            "  ",
            {"a", [], ["WINNER_OTHER_NAME_1"]},
            {"br", [], []},
            {"a", [], ["WINNER_NAME_2"]},
            {"br", [], []},
            "    ",
            {"span", [], ["a.k.a."]},
            "  ",
            {"a", [], ["WINNER_OTHER_NAME_2"]}
          ]}
       ]},
      {"div", [],
       [
         {"div", [], ["Beginning of in-ring career:"]},
         {"div", [], ["01.01.1000"]}
       ]}
    ]

    mocked_loser_page_url = "https://www.cagematch.net/?id=2&WRESTLER_LOSER_URL"

    mocked_loser_page_body = [
      {"div", [],
       [
         {"div", [], ["Gender:"]},
         {"div", [], ["male"]}
       ]},
      {"div", [],
       [
         {"div", [], ["Height:"]},
         {"div", [], ["5' 11\" (180 cm)"]}
       ]},
      {"div", [],
       [
         {"div", [], ["Weight:"]},
         {"div", [], ["218 lbs (99 kg)"]}
       ]},
      {"div", [],
       [
         {"div", [], ["Alter egos:"]},
         {"div", [],
          [
            {"a", [], ["LOSER_NAME_1"]},
            {"br", [], []},
            "    ",
            {"span", [], ["a.k.a."]},
            "  ",
            {"a", [], ["LOSER_OTHER_NAME_1"]},
            {"br", [], []},
            {"a", [], ["LOSER_NAME_2"]},
            {"br", [], []},
            "    ",
            {"span", [], ["a.k.a."]},
            "  ",
            {"a", [], ["LOSER_OTHER_NAME_2"]}
          ]}
       ]},
      {"div", [],
       [
         {"div", [], ["Beginning of in-ring career:"]},
         {"div", [], ["02.01.1000"]}
       ]}
    ]

    with_mocks([
      {HTTPoison, [],
       [
         get!: fn
           ^mocked_search_event_url ->
             %HTTPoison.Response{
               body: mocked_search_event_body |> Floki.raw_html(),
               status_code: 200
             }

           ^mocked_event_page_url ->
             %HTTPoison.Response{
               body: mocked_event_page_body |> Floki.raw_html(),
               status_code: 200
             }

           ^mocked_winner_page_url ->
             %HTTPoison.Response{
               body: mocked_winner_page_body |> Floki.raw_html(),
               status_code: 200
             }

           ^mocked_loser_page_url ->
             %HTTPoison.Response{
               body: mocked_loser_page_body |> Floki.raw_html(),
               status_code: 200
             }
         end
       ]}
    ]) do
      Scraper.scrape_site(mocked_year..mocked_year)
      EloCalculator.calculate_elos()
      wrestler_stats = Stats.list_wrestlers_stats(0)

      expected_wrestler_stats = [
        %{
          aliases: [],
          current_elo: %{date: ~D[1337-01-01], elo: 1216.0},
          gender: nil,
          height: nil,
          id: 1,
          max_elo: %{date: ~D[1337-01-01], elo: 1216.0},
          min_elo: %{date: ~D[1337-01-01], elo: 1216.0},
          name: "WRESTLER_WINNER",
          weight: nil
        },
        %{
          aliases: [],
          current_elo: %{date: ~D[1337-01-01], elo: 1184.0},
          gender: nil,
          height: nil,
          id: 2,
          max_elo: %{date: ~D[1337-01-01], elo: 1184.0},
          min_elo: %{date: ~D[1337-01-01], elo: 1184.0},
          name: "WRESTLER_LOSER",
          weight: nil
        }
      ]

      assert wrestler_stats == expected_wrestler_stats
    end
  end
end
