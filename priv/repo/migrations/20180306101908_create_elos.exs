defmodule Wwelo.Repo.Migrations.CreateElos do
  use Ecto.Migration

  def change do
    create table(:elos) do
      add(:wrestler_id, references("wrestlers"))
      add(:match_id, references("matches"))
      add(:elo, :float)

      timestamps()
    end

    create(unique_index(:elos, [:wrestler_id, :match_id]))
  end
end
