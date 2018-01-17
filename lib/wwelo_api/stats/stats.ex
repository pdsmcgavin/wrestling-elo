defmodule WweloApi.Stats do
  @moduledoc """
  The Stats context.
  """

  import Ecto.Query, warn: false
  alias WweloApi.Repo

  alias WweloApi.Stats.Wrestler

  @doc """
  Returns the list of wrestlers.

  ## Examples

      iex> list_wrestlers()
      [%Wrestler{}, ...]

  """
  def list_wrestlers do
    Repo.all(Wrestler)
  end

  @doc """
  Gets a single wrestler.

  Raises `Ecto.NoResultsError` if the Wrestler does not exist.

  ## Examples

      iex> get_wrestler!(123)
      %Wrestler{}

      iex> get_wrestler!(456)
      ** (Ecto.NoResultsError)

  """
  def get_wrestler!(id), do: Repo.get!(Wrestler, id)

  @doc """
  Creates a wrestler.

  ## Examples

      iex> create_wrestler(%{field: value})
      {:ok, %Wrestler{}}

      iex> create_wrestler(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_wrestler(attrs \\ %{}) do
    %Wrestler{}
    |> Wrestler.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a wrestler.

  ## Examples

      iex> update_wrestler(wrestler, %{field: new_value})
      {:ok, %Wrestler{}}

      iex> update_wrestler(wrestler, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_wrestler(%Wrestler{} = wrestler, attrs) do
    wrestler
    |> Wrestler.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Wrestler.

  ## Examples

      iex> delete_wrestler(wrestler)
      {:ok, %Wrestler{}}

      iex> delete_wrestler(wrestler)
      {:error, %Ecto.Changeset{}}

  """
  def delete_wrestler(%Wrestler{} = wrestler) do
    Repo.delete(wrestler)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking wrestler changes.

  ## Examples

      iex> change_wrestler(wrestler)
      %Ecto.Changeset{source: %Wrestler{}}

  """
  def change_wrestler(%Wrestler{} = wrestler) do
    Wrestler.changeset(wrestler, %{})
  end

  alias WweloApi.Stats.Alias

  @doc """
  Returns the list of aliases.

  ## Examples

      iex> list_aliases()
      [%Alias{}, ...]

  """
  def list_aliases do
    Repo.all(Alias)
  end

  @doc """
  Gets a single alias.

  Raises `Ecto.NoResultsError` if the Alias does not exist.

  ## Examples

      iex> get_alias!(123)
      %Alias{}

      iex> get_alias!(456)
      ** (Ecto.NoResultsError)

  """
  def get_alias!(id), do: Repo.get!(Alias, id)

  @doc """
  Creates a alias.

  ## Examples

      iex> create_alias(%{field: value})
      {:ok, %Alias{}}

      iex> create_alias(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_alias(attrs \\ %{}) do
    %Alias{}
    |> Alias.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a alias.

  ## Examples

      iex> update_alias(alias, %{field: new_value})
      {:ok, %Alias{}}

      iex> update_alias(alias, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_alias(%Alias{} = alias, attrs) do
    alias
    |> Alias.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Alias.

  ## Examples

      iex> delete_alias(alias)
      {:ok, %Alias{}}

      iex> delete_alias(alias)
      {:error, %Ecto.Changeset{}}

  """
  def delete_alias(%Alias{} = alias) do
    Repo.delete(alias)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking alias changes.

  ## Examples

      iex> change_alias(alias)
      %Ecto.Changeset{source: %Alias{}}

  """
  def change_alias(%Alias{} = alias) do
    Alias.changeset(alias, %{})
  end

  alias WweloApi.Stats.Event

  @doc """
  Returns the list of events.

  ## Examples

      iex> list_events()
      [%Event{}, ...]

  """
  def list_events do
    Repo.all(Event)
  end

  @doc """
  Gets a single event.

  Raises `Ecto.NoResultsError` if the Event does not exist.

  ## Examples

      iex> get_event!(123)
      %Event{}

      iex> get_event!(456)
      ** (Ecto.NoResultsError)

  """
  def get_event!(id), do: Repo.get!(Event, id)

  @doc """
  Creates a event.

  ## Examples

      iex> create_event(%{field: value})
      {:ok, %Event{}}

      iex> create_event(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_event(attrs \\ %{}) do
    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a event.

  ## Examples

      iex> update_event(event, %{field: new_value})
      {:ok, %Event{}}

      iex> update_event(event, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_event(%Event{} = event, attrs) do
    event
    |> Event.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Event.

  ## Examples

      iex> delete_event(event)
      {:ok, %Event{}}

      iex> delete_event(event)
      {:error, %Ecto.Changeset{}}

  """
  def delete_event(%Event{} = event) do
    Repo.delete(event)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event changes.

  ## Examples

      iex> change_event(event)
      %Ecto.Changeset{source: %Event{}}

  """
  def change_event(%Event{} = event) do
    Event.changeset(event, %{})
  end

  alias WweloApi.Stats.Match

  @doc """
  Returns the list of matches.

  ## Examples

      iex> list_matches()
      [%Match{}, ...]

  """
  def list_matches do
    Repo.all(Match)
  end

  @doc """
  Gets a single match.

  Raises `Ecto.NoResultsError` if the Match does not exist.

  ## Examples

      iex> get_match!(123)
      %Match{}

      iex> get_match!(456)
      ** (Ecto.NoResultsError)

  """
  def get_match!(id), do: Repo.get!(Match, id)

  @doc """
  Creates a match.

  ## Examples

      iex> create_match(%{field: value})
      {:ok, %Match{}}

      iex> create_match(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_match(attrs \\ %{}) do
    %Match{}
    |> Match.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a match.

  ## Examples

      iex> update_match(match, %{field: new_value})
      {:ok, %Match{}}

      iex> update_match(match, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_match(%Match{} = match, attrs) do
    match
    |> Match.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Match.

  ## Examples

      iex> delete_match(match)
      {:ok, %Match{}}

      iex> delete_match(match)
      {:error, %Ecto.Changeset{}}

  """
  def delete_match(%Match{} = match) do
    Repo.delete(match)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking match changes.

  ## Examples

      iex> change_match(match)
      %Ecto.Changeset{source: %Match{}}

  """
  def change_match(%Match{} = match) do
    Match.changeset(match, %{})
  end

  alias WweloApi.Stats.Participant

  @doc """
  Returns the list of participants.

  ## Examples

      iex> list_participants()
      [%Participant{}, ...]

  """
  def list_participants do
    Repo.all(Participant)
  end

  @doc """
  Gets a single participant.

  Raises `Ecto.NoResultsError` if the Participant does not exist.

  ## Examples

      iex> get_participant!(123)
      %Participant{}

      iex> get_participant!(456)
      ** (Ecto.NoResultsError)

  """
  def get_participant!(id), do: Repo.get!(Participant, id)

  @doc """
  Creates a participant.

  ## Examples

      iex> create_participant(%{field: value})
      {:ok, %Participant{}}

      iex> create_participant(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_participant(attrs \\ %{}) do
    %Participant{}
    |> Participant.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a participant.

  ## Examples

      iex> update_participant(participant, %{field: new_value})
      {:ok, %Participant{}}

      iex> update_participant(participant, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_participant(%Participant{} = participant, attrs) do
    participant
    |> Participant.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Participant.

  ## Examples

      iex> delete_participant(participant)
      {:ok, %Participant{}}

      iex> delete_participant(participant)
      {:error, %Ecto.Changeset{}}

  """
  def delete_participant(%Participant{} = participant) do
    Repo.delete(participant)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking participant changes.

  ## Examples

      iex> change_participant(participant)
      %Ecto.Changeset{source: %Participant{}}

  """
  def change_participant(%Participant{} = participant) do
    Participant.changeset(participant, %{})
  end
end
