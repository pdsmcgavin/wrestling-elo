defmodule WweloApi.Repo.Migrations.ChangeParticipantColumnName do
  use Ecto.Migration

  def change do
    rename(table(:participants), :wrestler_id, to: :alias_id)
  end
end
