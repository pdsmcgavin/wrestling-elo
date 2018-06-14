defmodule Wwelo.Repo.Migrations.CreateRosters do
  use Ecto.Migration

  def change do
    create table(:rosters) do
      add(:wrestler_id, references("wrestlers"))
      add(:brand, :string)

      timestamps()
    end
  end
end
