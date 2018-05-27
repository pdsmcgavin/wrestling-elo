defmodule Wwelo.Stats do
  @moduledoc """
  The Stats context.
  """

  import Ecto.Query, warn: false
  alias Wwelo.Repo

  alias Wwelo.Stats.Alias
  alias Wwelo.Stats.Elo
  alias Wwelo.Stats.Event
  alias Wwelo.Stats.Match
  alias Wwelo.Stats.Participant
  alias Wwelo.Stats.Wrestler

  def create_alias(attrs \\ %{}) do
    %Alias{}
    |> Alias.changeset(attrs)
    |> Repo.insert()
  end

  def create_elo(attrs \\ %{}) do
    %Elo{}
    |> Elo.changeset(attrs)
    |> Repo.insert()
  end

  def create_event(attrs \\ %{}) do
    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
  end

  def create_match(attrs \\ %{}) do
    %Match{}
    |> Match.changeset(attrs)
    |> Repo.insert()
  end

  def create_participant(attrs \\ %{}) do
    %Participant{}
    |> Participant.changeset(attrs)
    |> Repo.insert()
  end

  def create_wrestler(attrs \\ %{}) do
    %Wrestler{}
    |> Wrestler.changeset(attrs)
    |> Repo.insert()
  end

  def list_wrestlers_elos(min_matches \\ 10) do
    list_wrestlers_stats()
    |> Enum.filter(fn wrestler -> wrestler.elos |> length >= min_matches end)
    |> Enum.map(fn wrestler ->
      {min_elo_info, max_elo_info} =
        wrestler |> Map.get(:elos) |> Enum.min_max_by(&Map.get(&1, :elo))

      current_elo_info = wrestler |> Map.get(:elos) |> Enum.at(-1)

      %{
        name: wrestler.name,
        current_elo: current_elo_info.elo,
        max_elo: max_elo_info.elo,
        min_elo: min_elo_info.elo
      }
    end)
  end

  def list_wrestlers_stats do
    query =
      from(
        elos in Elo,
        join: m in Match,
        on: m.id == elos.match_id,
        join: e in Event,
        on: e.id == m.event_id,
        join: w in Wrestler,
        on: w.id == elos.wrestler_id
      )

    query =
      from(
        [elos, m, e, w] in query,
        select: %{name: w.name, date: e.date, elo: elos.elo},
        order_by: [
          asc: w.id,
          asc: e.date,
          asc: e.id,
          asc: m.card_position
        ]
      )

    query
    |> Repo.all()
    |> Enum.group_by(&Map.get(&1, :name), &Map.delete(&1, :name))
    |> Enum.map(fn {name, elos} -> %{name: name, elos: elos} end)
  end

  def list_wrestler_stats(id) do
    query =
      from(
        elos in Elo,
        join: m in Match,
        on: m.id == elos.match_id,
        join: e in Event,
        on: e.id == m.event_id,
        join: w in Wrestler,
        on: w.id == elos.wrestler_id
      )

    query =
      from(
        [elos, m, e, w] in query,
        select: %{name: w.name, date: e.date, elo: elos.elo},
        order_by: [
          asc: w.id,
          asc: e.date,
          asc: e.id,
          asc: m.card_position
        ],
        where: w.id == ^id
      )

    query
    |> Repo.all()
    |> Enum.group_by(&Map.get(&1, :name), &Map.delete(&1, :name))
    |> Enum.map(fn {name, elos} -> %{name: name, elos: elos} end)
  end
end
