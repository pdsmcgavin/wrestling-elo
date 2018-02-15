defmodule WweloApi.Repo.Migrations.CreateAliases do
  use Ecto.Migration

  def change do
    create table(:aliases) do
      add(:name, :string)
      add(:wrestler_id, :integer)

      timestamps()
    end

    create(unique_index(:aliases, [:name]))
  end
end
