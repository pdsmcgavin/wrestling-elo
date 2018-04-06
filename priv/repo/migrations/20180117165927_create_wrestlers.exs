defmodule Wwelo.Repo.Migrations.CreateWrestlers do
  use Ecto.Migration

  def change do
    create table(:wrestlers) do
      add(:name, :string)
      add(:gender, :string)
      add(:height, :integer)
      add(:weight, :integer)
      add(:career_start_date, :date)
      add(:career_end_date, :date)

      timestamps()
    end

    create(unique_index(:wrestlers, [:name]))
  end
end
