defmodule WweloApi.Stats do
  @moduledoc """
  The Stats context.
  """

  import Ecto.Query, warn: false
  alias WweloApi.Repo

  alias WweloApi.Stats.Wrestler

  def list_wrestlers do
    Repo.all(Wrestler)
  end

  def get_wrestler!(id), do: Repo.get!(Wrestler, id)

  def create_wrestler(attrs \\ %{}) do
    %Wrestler{}
    |> Wrestler.changeset(attrs)
    |> Repo.insert()
  end

  def update_wrestler(%Wrestler{} = wrestler, attrs) do
    wrestler
    |> Wrestler.changeset(attrs)
    |> Repo.update()
  end

  def delete_wrestler(%Wrestler{} = wrestler) do
    Repo.delete(wrestler)
  end

  def change_wrestler(%Wrestler{} = wrestler) do
    Wrestler.changeset(wrestler, %{})
  end

  alias WweloApi.Stats.Alias

  def list_aliases do
    Repo.all(Alias)
  end

  def get_alias!(id), do: Repo.get!(Alias, id)

  def create_alias(attrs \\ %{}) do
    %Alias{}
    |> Alias.changeset(attrs)
    |> Repo.insert()
  end

  def update_alias(%Alias{} = alias, attrs) do
    alias
    |> Alias.changeset(attrs)
    |> Repo.update()
  end

  def delete_alias(%Alias{} = alias) do
    Repo.delete(alias)
  end

  def change_alias(%Alias{} = alias) do
    Alias.changeset(alias, %{})
  end

  alias WweloApi.Stats.Event

  def list_events do
    Repo.all(Event)
  end

  def get_event!(id), do: Repo.get!(Event, id)

  def create_event(attrs \\ %{}) do
    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
  end

  def update_event(%Event{} = event, attrs) do
    event
    |> Event.changeset(attrs)
    |> Repo.update()
  end

  def delete_event(%Event{} = event) do
    Repo.delete(event)
  end

  def change_event(%Event{} = event) do
    Event.changeset(event, %{})
  end

  alias WweloApi.Stats.Match

  def list_matches do
    Repo.all(Match)
  end

  def get_match!(id), do: Repo.get!(Match, id)

  def create_match(attrs \\ %{}) do
    %Match{}
    |> Match.changeset(attrs)
    |> Repo.insert()
  end

  def update_match(%Match{} = match, attrs) do
    match
    |> Match.changeset(attrs)
    |> Repo.update()
  end

  def delete_match(%Match{} = match) do
    Repo.delete(match)
  end

  def change_match(%Match{} = match) do
    Match.changeset(match, %{})
  end

  alias WweloApi.Stats.Participant

  def list_participants do
    Repo.all(Participant)
  end

  def get_participant!(id), do: Repo.get!(Participant, id)

  def create_participant(attrs \\ %{}) do
    %Participant{}
    |> Participant.changeset(attrs)
    |> Repo.insert()
  end

  def update_participant(%Participant{} = participant, attrs) do
    participant
    |> Participant.changeset(attrs)
    |> Repo.update()
  end

  def delete_participant(%Participant{} = participant) do
    Repo.delete(participant)
  end

  def change_participant(%Participant{} = participant) do
    Participant.changeset(participant, %{})
  end

  alias WweloApi.Stats.Elo

  def list_elos do
    Repo.all(Elo)
  end

  def get_elo!(id), do: Repo.get!(Elo, id)

  def create_elo(attrs \\ %{}) do
    %Elo{}
    |> Elo.changeset(attrs)
    |> Repo.insert()
  end

  def update_elo(%Elo{} = elo, attrs) do
    elo
    |> Elo.changeset(attrs)
    |> Repo.update()
  end

  def delete_elo(%Elo{} = elo) do
    Repo.delete(elo)
  end

  def change_elo(%Elo{} = elo) do
    Elo.changeset(elo, %{})
  end
end