defmodule WweloApi.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add(:name, :string)
      add(:promotion, :string)
      add(:date, :date)
      add(:brand, :string)
      add(:event_type, :string)
      add(:location, :string)
      add(:arena, :string)

      timestamps()
    end

    create(unique_index(:events, [:name, :date, :location]))
  end
end
