defmodule Wwelo.Stats.Roster do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  alias Wwelo.Stats.Roster

  schema "rosters" do
    field(:alias, :string)
    field(:brand, :string)
    field(:wrestler_id, :integer)

    timestamps()
  end

  @doc false
  def changeset(%Roster{} = roster, attrs) do
    roster
    |> cast(attrs, [:wrestler_id, :brand, :alias])
    |> validate_required([:wrestler_id, :brand, :alias])
  end
end
