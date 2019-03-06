defmodule Wwelo.Stats do
  @moduledoc """
  The Stats context.
  """

  import Ecto.Query, warn: false
  require Logger

  alias Wwelo.Repo
  alias Wwelo.Stats.Alias
  alias Wwelo.Stats.Elo
  alias Wwelo.Stats.Event
  alias Wwelo.Stats.Match
  alias Wwelo.Stats.Participant
  alias Wwelo.Stats.Roster
  alias Wwelo.Stats.TitleHolder
  alias Wwelo.Stats.Wrestler
  alias Wwelo.Utils.GetEloConsts

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

  def create_roster(attrs \\ %{}) do
    %Roster{}
    |> Roster.changeset(attrs)
    |> Repo.insert()
  end

  def create_title_holder(attrs \\ %{}) do
    %TitleHolder{}
    |> TitleHolder.changeset(attrs)
    |> Repo.insert()
  end

  def create_wrestler(attrs \\ %{}) do
    %Wrestler{}
    |> Wrestler.changeset(attrs)
    |> Repo.insert()
  end

  def get_wrestler(id) do
    Wrestler
    |> Repo.get(id)
  end

  def get_wrestler_aliases(wrestler_id) do
    Repo.all(
      from(a in Alias, where: a.wrestler_id == ^wrestler_id, select: a.name)
    )
  end

  def list_wrestlers_stats(min_matches) do
    wrestler_elos_by_id()
    |> Enum.filter(fn wrestler -> wrestler.elos |> length >= min_matches end)
    |> Enum.map(fn wrestler ->
      {min_elo_info, max_elo_info} =
        wrestler |> Map.get(:elos) |> Enum.min_max_by(&Map.get(&1, :elo))

      current_elo_info = wrestler |> Map.get(:elos) |> Enum.at(-1)

      wrestler_info = get_wrestler(wrestler |> Map.get(:id))

      aliases =
        wrestler
        |> Map.get(:id)
        |> get_wrestler_aliases()
        |> List.delete(wrestler_info.name)

      %{
        id: wrestler_info.id,
        name: wrestler_info.name,
        aliases: aliases,
        gender: wrestler_info.gender,
        height: wrestler_info.height,
        weight: wrestler_info.weight,
        current_elo: current_elo_info,
        max_elo: max_elo_info,
        min_elo: min_elo_info
      }
    end)
  end

  def list_current_wrestlers_stats(
        min_matches,
        last_match_within_days,
        date
      ) do
    Roster
    |> Repo.all()
    |> Enum.map(fn %{alias: alias, brand: brand, wrestler_id: wrestler_id} ->
      %{
        alias: alias,
        brand: brand,
        wrestler: wrestler_elos_by_id(wrestler_id, date)
      }
    end)
    |> Enum.filter(fn %{alias: _, brand: _, wrestler: wrestler} ->
      elos = wrestler |> Map.get(:elos)

      elos |> length >= min_matches &&
        elos |> Enum.at(-1) |> Map.get(:date) |> Date.diff(Date.utc_today()) >
          -last_match_within_days
    end)
    |> Enum.map(fn %{alias: alias, brand: brand, wrestler: wrestler} ->
      {min_elo_info, max_elo_info} =
        wrestler |> Map.get(:elos) |> Enum.min_max_by(&Map.get(&1, :elo))

      current_elo_info = wrestler |> Map.get(:elos) |> Enum.at(-1)

      wrestler_info = get_wrestler(wrestler |> Map.get(:id))

      %{
        id: wrestler_info.id,
        name: alias,
        gender: wrestler_info.gender,
        height: wrestler_info.height,
        weight: wrestler_info.weight,
        current_elo: current_elo_info,
        max_elo: max_elo_info,
        min_elo: min_elo_info,
        brand: brand
      }
    end)
  end

  def wrestler_elos_by_id do
    query =
      from(
        elos in Elo,
        join: m in Match,
        on: m.id == elos.match_id,
        join: e in Event,
        on: e.id == m.event_id
      )

    query =
      from(
        [elos, m, e] in query,
        select: %{id: elos.wrestler_id, date: e.date, elo: elos.elo},
        order_by: [
          asc: elos.wrestler_id,
          asc: e.date,
          asc: e.id,
          asc: m.card_position
        ]
      )

    query
    |> Repo.all()
    |> Enum.group_by(&Map.get(&1, :id), &Map.delete(&1, :id))
    |> Enum.map(fn {id, elos} -> %{id: id, elos: elos} end)
  end

  def wrestler_elos_by_id(wrestler_id) do
    query =
      from(
        elos in Elo,
        join: m in Match,
        on: m.id == elos.match_id,
        join: e in Event,
        on: e.id == m.event_id
      )

    query =
      from(
        [elos, m, e] in query,
        select: %{date: e.date, elo: elos.elo},
        order_by: [
          asc: elos.wrestler_id,
          asc: e.date,
          asc: e.id,
          asc: m.card_position
        ],
        where: elos.wrestler_id == ^wrestler_id
      )

    %{
      id: wrestler_id,
      elos:
        query
        |> Repo.all()
    }
  end

  def wrestler_elos_by_id(wrestler_id, date) do
    query =
      from(
        elos in Elo,
        join: m in Match,
        on: m.id == elos.match_id,
        join: e in Event,
        on: e.id == m.event_id
      )

    query =
      from(
        [elos, m, e] in query,
        select: %{date: e.date, elo: elos.elo},
        order_by: [
          asc: elos.wrestler_id,
          asc: e.date,
          asc: e.id,
          asc: m.card_position
        ],
        where: elos.wrestler_id == ^wrestler_id and e.date <= ^date
      )

    %{
      id: wrestler_id,
      elos:
        query
        |> Repo.all()
    }
  end

  def replace_dates_with_years(elo_info) do
    elo_info
    |> Enum.map(fn elo ->
      elo
      |> Map.put(:year, elo |> Map.get(:date) |> Date.to_erl() |> elem(0))
      |> Map.delete(:date)
    end)
  end

  def max_min_elo_differences_by_year(elo_info) do
    elo_info
    |> Enum.group_by(fn x ->
      x |> Map.get(:id)
    end)
    |> Enum.map(fn {id, elos} ->
      %{
        id: id,
        elos:
          elos
          |> Enum.group_by(fn x ->
            x |> Map.get(:date) |> Date.to_erl() |> elem(0)
          end)
          |> Enum.map(fn {year, elos} ->
            %{
              year: year,
              elo:
                elos
                |> Enum.max_by(fn elo ->
                  elo |> Map.get(:date) |> Date.to_iso8601()
                end)
                |> Map.get(:elo)
            }
          end)
      }
    end)
    |> Enum.map(fn %{elos: elos, id: id} ->
      [
        %{elo: GetEloConsts.get_elo_consts() |> Map.get(:default_elo), year: 0}
        | elos
      ]
      |> Enum.zip(elos)
      |> Enum.map(fn {elo_before, elo_after} ->
        %{
          year: elo_after |> Map.get(:year),
          elo_difference: Map.get(elo_after, :elo) - Map.get(elo_before, :elo),
          id: id
        }
      end)
    end)
    |> List.flatten()
  end

  def get_elo_stats_by_year do
    elo_info = get_all_elos_and_dates()

    max_min_elos = replace_dates_with_years(elo_info)
    max_min_elo_differences = max_min_elo_differences_by_year(elo_info)

    (max_min_elos ++ max_min_elo_differences)
    |> Enum.group_by(&Map.get(&1, :year))
    |> Enum.map(fn {year, elos} ->
      {min_elo_info, max_elo_info} =
        elos
        |> Enum.filter(&Map.has_key?(&1, :elo))
        |> Enum.min_max_by(&Map.get(&1, :elo))

      {min_elo_difference_info, max_elo_difference_info} =
        elos
        |> Enum.filter(&Map.has_key?(&1, :elo_difference))
        |> Enum.min_max_by(&Map.get(&1, :elo_difference))

      %{
        year: year,
        max_elo: %{
          elo: max_elo_info.elo,
          name: Map.get(get_wrestler(max_elo_info.id), :name)
        },
        min_elo: %{
          elo: min_elo_info.elo,
          name: Map.get(get_wrestler(min_elo_info.id), :name)
        },
        max_elo_difference: %{
          elo_difference: max_elo_difference_info.elo_difference,
          name: Map.get(get_wrestler(max_elo_difference_info.id), :name)
        },
        min_elo_difference: %{
          elo_difference: min_elo_difference_info.elo_difference,
          name: Map.get(get_wrestler(min_elo_difference_info.id), :name)
        }
      }
    end)
  end

  def get_all_elos_and_dates do
    query =
      from(
        elos in Elo,
        join: m in Match,
        on: m.id == elos.match_id,
        join: e in Event,
        on: e.id == m.event_id
      )

    query =
      from(
        [elos, m, e] in query,
        select: %{
          id: elos.wrestler_id,
          date: e.date,
          elo: elos.elo
        }
      )

    query
    |> Repo.all()
  end

  def get_title_holders do
    query =
      from(t in TitleHolder, join: a in Alias, on: a.id == t.holder_alias_id)

    query =
      from([t, a] in query,
        select: %{
          name: a.name,
          belt_name: t.name,
          brand: t.brand,
          gender: t.gender
        }
      )

    query |> Repo.all()
  end

  def get_events(event_type) do
    query =
      from(e in Event,
        where: e.event_type == ^event_type,
        select: %{
          name: e.name,
          date: e.date,
          event_type: e.event_type,
          id: e.id
        }
      )

    query |> Repo.all()
  end

  def get_event(event_id) do
    query =
      from(
        m in Match,
        join: p in Participant,
        on: p.match_id == m.id,
        join: a in Alias,
        on: a.id == p.alias_id,
        join: e in Elo,
        on: e.match_id == m.id and e.wrestler_id == a.wrestler_id
      )

    query =
      from(
        [m, p, a, e] in query,
        select: %{
          match: m,
          participant: p,
          alias: a,
          elo: e
        },
        where: m.event_id == ^event_id
      )

    matches_and_participants =
      query
      |> Repo.all()
      |> Enum.group_by(fn %{match: match} -> match end)
      |> Enum.map(fn {match, participants} ->
        match
        |> Map.put(
          :participants,
          participants
          |> Enum.map(fn %{alias: alias, participant: participant, elo: elo} ->
            participant
            |> Map.put(:name, alias.name)
            |> Map.put(:elo_after, elo.elo)
            |> Map.put(:elo_before, elo.elo_before)
          end)
        )
      end)

    event = Event |> Repo.get!(event_id)

    event |> Map.put(:matches, matches_and_participants)
  end
end
