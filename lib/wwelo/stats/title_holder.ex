defmodule Wwelo.Stats.TitleHolder do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  alias Wwelo.Stats.TitleHolder

  schema "title_holders" do
    field(:brand, :string)
    field(:gender, GenderEnum)
    field(:holder_alias_id, :integer)
    field(:name, :string)

    timestamps()
  end

  @doc false
  def changeset(%TitleHolder{} = title_holder, attrs) do
    title_holder
    |> cast(attrs, [:brand, :gender, :holder_alias_id, :name])
    |> validate_required([:name])
  end
end
