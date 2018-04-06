defmodule Wwelo.Stats.Alias do
  use Ecto.Schema
  import Ecto.Changeset
  alias Wwelo.Stats.Alias

  schema "aliases" do
    field(:name, :string)
    field(:wrestler_id, :integer)

    timestamps()
  end

  @doc false
  def changeset(%Alias{} = alias, attrs) do
    alias
    |> cast(attrs, [:name, :wrestler_id])
    |> validate_required([:name, :wrestler_id])
    |> unique_constraint(:name)
  end
end
