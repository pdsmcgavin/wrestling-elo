defmodule Wwelo.Stats.Elo do
  use Ecto.Schema
  import Ecto.Changeset
  alias Wwelo.Stats.Elo

  schema "elos" do
    field(:elo, :float)
    field(:match_id, :integer)
    field(:wrestler_id, :integer)

    timestamps()
  end

  @doc false
  def changeset(%Elo{} = elo, attrs) do
    elo
    |> cast(attrs, [:wrestler_id, :match_id, :elo])
    |> validate_required([:wrestler_id, :match_id, :elo])
  end
end
