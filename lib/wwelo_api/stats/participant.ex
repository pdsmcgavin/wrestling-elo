defmodule WweloApi.Stats.Participant do
  use Ecto.Schema
  import Ecto.Changeset
  alias WweloApi.Stats.Participant


  schema "participants" do
    field :elo_after, :integer
    field :match_id, :integer
    field :match_team, :integer
    field :outcome, :string
    field :wrestler_id, :integer

    timestamps()
  end

  @doc false
  def changeset(%Participant{} = participant, attrs) do
    participant
    |> cast(attrs, [:wrestler_id, :match_id, :outcome, :elo_after, :match_team])
    |> validate_required([:wrestler_id, :match_id, :outcome, :elo_after, :match_team])
  end
end
