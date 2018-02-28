defmodule WweloApi.SiteScraper.Wrestlers do
  import Ecto.Query

  alias WweloApi.Repo
  alias WweloApi.Stats
  alias WweloApi.Stats.Wrestler
  alias WweloApi.SiteScraper.Utils.DateHelper
  alias WweloApi.SiteScraper.Utils.UrlHelper

  @default_elo 1200

  @default_wrestler_info %{
    wins: 0,
    losses: 0,
    draws: 0,
    current_elo: @default_elo,
    maximum_elo: @default_elo,
    minimum_elo: @default_elo
  }

  def save_alter_egos_of_wrestler(%{wrestler_url_path: wrestler_url_path}) do
    wrestler_info =
      wrestler_url_path
      |> get_wrestler_info
      |> convert_wrestler_info

    Enum.map(Map.keys(wrestler_info.names), fn name ->
      Map.put(wrestler_info, :name, name |> Atom.to_string())
      |> save_wrestler_to_database()
    end)
  end

  def get_wrestler_info(wrestler_url_path) do
    wrestler_url = "https://www.cagematch.net/" <> wrestler_url_path

    UrlHelper.get_page_html_body(%{url: wrestler_url})
    |> Floki.find(".InformationBoxRow")
  end

  def convert_wrestler_info(wrestler_info) do
    Enum.reduce(wrestler_info, @default_wrestler_info, fn x, acc ->
      case x do
        {_, _, [{_, _, ["Gender:"]}, {_, _, [gender]}]} ->
          Map.put(acc, :gender, gender)

        {_, _, [{_, _, ["Height:"]}, {_, _, [height]}]} ->
          Map.put(acc, :height, height |> convert_height_to_integer)

        {_, _, [{_, _, ["Weight:"]}, {_, _, [weight]}]} ->
          Map.put(acc, :weight, weight |> convert_weight_to_integer)

        {_, _, [{_, _, ["Alter egos:"]}, {_, _, alter_egos}]} ->
          Map.put(acc, :names, alter_egos |> get_names_and_aliases)

        {_, _, [{_, _, ["Beginning of in-ring career:"]}, {_, _, [date]}]} ->
          case DateHelper.format_date(date) do
            {:ok, date} -> Map.put(acc, :career_start_date, date)
            _ -> acc
          end

        {_, _, [{_, _, ["End of in-ring career:"]}, {_, _, [date]}]} ->
          case DateHelper.format_date(date) do
            {:ok, date} -> Map.put(acc, :career_end_date, date)
            _ -> acc
          end

        _ ->
          acc
      end
    end)
  end

  def get_names_and_aliases(alter_egos) do
    alter_egos
    |> Enum.filter(&is_tuple(&1))
    |> Enum.map(&elem(&1, 2))
    |> Enum.filter(&(&1 != []))
    |> List.flatten()
    |> Enum.map(&(String.trim_leading(&1) |> String.trim_trailing()))
    |> Enum.reduce(%{}, fn x, acc ->
      cond do
        Map.get(acc, :last_name) == "a.k.a." ->
          Map.put(
            acc,
            String.to_atom(Map.get(acc, :current_name)),
            Map.get(acc, String.to_atom(Map.get(acc, :current_name))) ++ [x]
          )

        x == "a.k.a." ->
          acc

        true ->
          Map.put(acc, String.to_atom(x), [x])
          |> Map.put(:current_name, x)
      end
      |> Map.put(:last_name, x)
    end)
    |> Map.delete(:current_name)
    |> Map.delete(:last_name)
  end

  def convert_height_to_integer(height) do
    height
    |> String.split(["(", " cm)"])
    |> Enum.at(1)
    |> String.to_integer()
  end

  def convert_weight_to_integer(weight) do
    weight
    |> String.split(["(", " kg)"])
    |> Enum.at(1)
    |> String.to_integer()
  end

  def save_wrestler_to_database(wrestler_info) do
    wrestler_query =
      from(
        w in Wrestler,
        where: w.name == ^wrestler_info.name,
        select: w
      )

    wrestler_result = Repo.one(wrestler_query)

    case wrestler_result do
      nil -> Stats.create_wrestler(wrestler_info) |> elem(1)
      _ -> wrestler_result
    end
    |> Map.get(:id)
  end
end
