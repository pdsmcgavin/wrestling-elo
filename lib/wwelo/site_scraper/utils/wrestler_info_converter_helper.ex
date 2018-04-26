defmodule Wwelo.SiteScraper.Utils.WrestlerInfoConverterHelper do
  alias Wwelo.SiteScraper.Utils.DateHelper

  def convert_wrestler_info(
        {_, _, [{_, _, ["Gender:"]}, {_, _, [gender]}]},
        acc
      ) do
    Map.put(acc, :gender, gender)
  end

  def convert_wrestler_info(
        {_, _, [{_, _, ["Height:"]}, {_, _, [height]}]},
        acc
      ) do
    Map.put(acc, :height, height |> convert_height_to_integer)
  end

  def convert_wrestler_info(
        {_, _, [{_, _, ["Weight:"]}, {_, _, [weight]}]},
        acc
      ) do
    Map.put(acc, :weight, weight |> convert_weight_to_integer)
  end

  def convert_wrestler_info(
        {_, _, [{_, _, ["Alter egos:"]}, {_, _, alter_egos}]},
        acc
      ) do
    Map.put(acc, :names, alter_egos |> get_names_and_aliases)
  end

  def convert_wrestler_info(
        {_, _, [{_, _, ["Beginning of in-ring career:"]}, {_, _, [date]}]},
        acc
      ) do
    case DateHelper.format_date(date) do
      {:ok, date} -> Map.put(acc, :career_start_date, date)
      _ -> acc
    end
  end

  def convert_wrestler_info(
        {_, _, [{_, _, ["End of in-ring career:"]}, {_, _, [date]}]},
        acc
      ) do
    case DateHelper.format_date(date) do
      {:ok, date} -> Map.put(acc, :career_end_date, date)
      _ -> acc
    end
  end

  def convert_wrestler_info(_, acc) do
    acc
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

  def get_names_and_aliases(alter_egos) do
    alter_egos
    |> Enum.map(fn alter_ego ->
      if is_tuple(alter_ego) && tuple_size(alter_ego) == 3 do
        elem(alter_ego, 2)
      else
        alter_ego
      end
    end)
    |> List.flatten()
    |> Enum.map(&String.trim(&1))
    |> Enum.filter(&(&1 != ""))
    |> Enum.map(&(&1 |> String.trim_leading() |> String.trim_trailing()))
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
          acc
          |> Map.put(String.to_atom(x), [x])
          |> Map.put(:current_name, x)
      end
      |> Map.put(:last_name, x)
    end)
    |> Map.delete(:current_name)
    |> Map.delete(:last_name)
  end
end
