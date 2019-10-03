defmodule Wwelo.Repo.Migrations.AddPreviousElo do
  use Ecto.Migration

  def change do
    alter table(:elos) do
      add(:elo_before, :float)
    end
  end
end
