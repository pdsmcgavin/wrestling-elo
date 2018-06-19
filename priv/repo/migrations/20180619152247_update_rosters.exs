defmodule Wwelo.Repo.Migrations.UpdateRosters do
  use Ecto.Migration

  def change do
    alter table(:rosters) do
      add(:alias, :string)
    end
  end
end
