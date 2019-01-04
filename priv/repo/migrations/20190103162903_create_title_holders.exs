defmodule Wwelo.Repo.Migrations.CreateTitleHolders do
  use Ecto.Migration

  def change do
    create table(:title_holders) do
      add(:brand, :string)
      add(:gender, :gender)
      add(:holder_alias_id, references("aliases"))
      add(:name, :string)

      timestamps()
    end
  end
end
