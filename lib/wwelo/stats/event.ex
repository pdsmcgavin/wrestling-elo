defmodule Wwelo.Stats.Event do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  alias Wwelo.Stats.Event

  schema "events" do
    field(:arena, :string)
    field(:date, :date)
    field(:event_type, EventTypeEnum)
    field(:location, :string)
    field(:name, :string)
    field(:promotion, :string)
    field(:upcoming, :boolean)

    timestamps()
  end

  @doc false
  def changeset(%Event{} = event, attrs) do
    event
    |> cast(attrs, [
      :name,
      :promotion,
      :date,
      :event_type,
      :location,
      :arena,
      :upcoming
    ])
    |> validate_required([
      :name,
      :date,
      :event_type,
      :location
    ])
    |> unique_constraint(:name)
  end
end
