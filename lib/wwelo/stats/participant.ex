defmodule Wwelo.Stats.Participant do
  use Ecto.Schema
  import Ecto.Changeset
  alias Wwelo.Stats.Participant

  schema "participants" do
    field(:match_id, :integer)
    field(:match_team, :integer)
    field(:outcome, :string)
    field(:alias_id, :integer)

    timestamps()
  end

  @doc false
  def changeset(%Participant{} = participant, attrs) do
    participant
    |> cast(attrs, [:alias_id, :match_id, :outcome, :match_team])
    |> validate_required([
      :alias_id,
      :match_id,
      :outcome
    ])
  end
end
