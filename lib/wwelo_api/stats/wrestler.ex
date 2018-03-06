defmodule WweloApi.Stats.Wrestler do
  use Ecto.Schema
  import Ecto.Changeset
  alias WweloApi.Stats.Wrestler

  schema "wrestlers" do
    field(:career_end_date, :date)
    field(:career_start_date, :date)
    field(:gender, :string)
    field(:height, :integer)
    field(:name, :string)
    field(:weight, :integer)

    timestamps()
  end

  @doc false
  def changeset(%Wrestler{} = wrestler, attrs) do
    wrestler
    |> cast(attrs, [
      :name,
      :gender,
      :height,
      :weight,
      :career_start_date,
      :career_end_date
    ])
    |> validate_required([
      :name
    ])
    |> unique_constraint(:name)
  end
end
