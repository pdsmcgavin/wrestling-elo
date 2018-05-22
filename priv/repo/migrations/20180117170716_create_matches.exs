defmodule Wwelo.Repo.Migrations.CreateMatches do
  use Ecto.Migration

  def change do
    create table(:matches) do
      add(:event_id, references("events"))
      add(:stipulation, :string)
      add(:card_position, :integer)

      timestamps()
    end
  end
end
