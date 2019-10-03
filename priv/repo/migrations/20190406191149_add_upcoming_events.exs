defmodule Wwelo.Repo.Migrations.AddUpcomingEvents do
  use Ecto.Migration

  def change do
    alter table(:events) do
      add(:upcoming, :boolean)
    end
  end
end
