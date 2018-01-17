defmodule WweloApi.Stats.Wrestler do
  use Ecto.Schema
  import Ecto.Changeset
  alias WweloApi.Stats.Wrestler


  schema "wrestlers" do
    field :career_end_date, :date
    field :career_start_date, :date
    field :current_elo, :integer
    field :draw, :integer
    field :gender, :string
    field :height, :integer
    field :losses, :integer
    field :maximum_elo, :integer
    field :minimum_elo, :integer
    field :name, :string
    field :weight, :integer
    field :wins, :integer

    timestamps()
  end

  @doc false
  def changeset(%Wrestler{} = wrestler, attrs) do
    wrestler
    |> cast(attrs, [:name, :gender, :height, :weight, :career_start_date, :career_end_date, :wins, :losses, :draw, :current_elo, :maximum_elo, :minimum_elo])
    |> validate_required([:name, :gender, :height, :weight, :career_start_date, :career_end_date, :wins, :losses, :draw, :current_elo, :maximum_elo, :minimum_elo])
    |> unique_constraint(:name)
  end
end
