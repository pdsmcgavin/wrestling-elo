defmodule WweloApi.Stats.Elo do
  use Ecto.Schema
  import Ecto.Changeset
  alias WweloApi.Stats.Elo

  schema "elos" do
    timestamps()
  end

  @doc false
  def changeset(%Elo{} = elo, attrs) do
    elo
    |> cast(attrs, [])
    |> validate_required([])
  end
end
