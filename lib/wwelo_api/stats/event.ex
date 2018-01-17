defmodule WweloApi.Stats.Event do
  use Ecto.Schema
  import Ecto.Changeset
  alias WweloApi.Stats.Event


  schema "events" do
    field :arena, :string
    field :brand, :string
    field :date, :date
    field :event_type, :string
    field :location, :string
    field :name, :string
    field :promotion, :string

    timestamps()
  end

  @doc false
  def changeset(%Event{} = event, attrs) do
    event
    |> cast(attrs, [:name, :promotion, :date, :brand, :event_type, :location, :arena])
    |> validate_required([:name, :promotion, :date, :brand, :event_type, :location, :arena])
    |> unique_constraint(:name)
  end
end
