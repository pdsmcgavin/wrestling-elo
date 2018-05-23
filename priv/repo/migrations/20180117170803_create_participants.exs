defmodule Wwelo.Repo.Migrations.CreateParticipants do
  use Ecto.Migration

  def change do
    create table(:participants) do
      add(:alias_id, references("aliases"))
      add(:match_id, references("matches"))
      add(:outcome, :string)
      add(:match_team, :integer)

      timestamps()
    end
  end
end
