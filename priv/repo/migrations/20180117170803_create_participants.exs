defmodule Wwelo.Repo.Migrations.CreateParticipants do
  use Ecto.Migration

  def change do
    create table(:participants) do
      add(:wrestler_id, references("wrestlers"))
      add(:match_id, references("matches"))
      add(:outcome, :string)
      add(:match_team, :integer)

      timestamps()
    end
  end
end
