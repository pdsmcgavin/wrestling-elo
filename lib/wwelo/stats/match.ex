defmodule Wwelo.Stats.Match do
  use Ecto.Schema
  import Ecto.Changeset
  alias Wwelo.Stats.Match

  schema "matches" do
    field(:card_position, :integer)
    field(:event_id, :integer)
    field(:stipulation, :string)

    timestamps()
  end

  @doc false
  def changeset(%Match{} = match, attrs) do
    match
    |> cast(attrs, [:event_id, :stipulation, :card_position])
    |> validate_required([:event_id, :stipulation, :card_position])
  end
end
