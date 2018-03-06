defmodule WweloApi.Repo.Migrations.CreateElos do
  use Ecto.Migration

  def change do
    create table(:elos) do
      add(:wrestler_id, :integer)
      add(:match_id, :integer)
      add(:elo, :float)

      timestamps()
    end

    create(unique_index(:elos, [:wrestler_id, :match_id]))
  end
end
