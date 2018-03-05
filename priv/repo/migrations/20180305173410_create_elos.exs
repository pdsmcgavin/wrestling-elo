defmodule WweloApi.Repo.Migrations.CreateElos do
  use Ecto.Migration

  def change do
    create table(:elos) do
      add(:wrestler_id, :string)
      add(:match_id, :string)
      add(:elo, :string)

      timestamps()
    end

    create(unique_index(:elos, [:wrestler_id, :match_id]))
  end
end