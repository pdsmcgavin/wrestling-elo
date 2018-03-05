defmodule WweloApi.Repo.Migrations.CreateParticipants do
  use Ecto.Migration

  def change do
    create table(:participants) do
      add(:wrestler_id, :integer)
      add(:match_id, :integer)
      add(:outcome, :string)
      add(:elo_after, :float)
      add(:match_team, :integer)

      timestamps()
    end
  end
end
