defmodule Wwelo.Repo.Migrations.ModifyTableConstraints do
  use Ecto.Migration

  def up do
    drop(constraint(:aliases, "aliases_wrestler_id_fkey"))
    drop(constraint(:matches, "matches_event_id_fkey"))
    drop(constraint(:participants, "participants_alias_id_fkey"))
    drop(constraint(:participants, "participants_match_id_fkey"))
    drop(constraint(:elos, "elos_match_id_fkey"))
    drop(constraint(:elos, "elos_wrestler_id_fkey"))
    drop(constraint(:rosters, "rosters_wrestler_id_fkey"))
    drop(constraint(:title_holders, "title_holders_holder_alias_id_fkey"))

    alter table(:aliases) do
      modify(:wrestler_id, references(:wrestlers, on_delete: :delete_all))
    end

    alter table(:matches) do
      modify(:event_id, references(:events, on_delete: :delete_all))
    end

    alter table(:participants) do
      modify(:alias_id, references(:aliases, on_delete: :delete_all))
      modify(:match_id, references(:matches, on_delete: :delete_all))
    end

    alter table(:elos) do
      modify(:match_id, references(:matches, on_delete: :delete_all))
      modify(:wrestler_id, references(:wrestlers, on_delete: :delete_all))
    end

    alter table(:rosters) do
      modify(:wrestler_id, references(:wrestlers, on_delete: :delete_all))
    end

    alter table(:title_holders) do
      modify(:holder_alias_id, references(:aliases, on_delete: :delete_all))
    end
  end

  def down do
    drop(constraint(:aliases, "aliases_wrestler_id_fkey"))
    drop(constraint(:matches, "matches_event_id_fkey"))
    drop(constraint(:participants, "participants_alias_id_fkey"))
    drop(constraint(:participants, "participants_match_id_fkey"))
    drop(constraint(:elos, "elos_match_id_fkey"))
    drop(constraint(:elos, "elos_wrestler_id_fkey"))
    drop(constraint(:rosters, "rosters_wrestler_id_fkey"))
    drop(constraint(:title_holders, "title_holders_holder_alias_id_fkey"))

    alter table(:aliases) do
      modify(:wrestler_id, references(:wrestlers, on_delete: :nothing))
    end

    alter table(:matches) do
      modify(:event_id, references(:events, on_delete: :nothing))
    end

    alter table(:participants) do
      modify(:alias_id, references(:aliases, on_delete: :nothing))
      modify(:match_id, references(:matches, on_delete: :nothing))
    end

    alter table(:elos) do
      modify(:match_id, references(:matches, on_delete: :nothing))
      modify(:wrestler_id, references(:wrestlers, on_delete: :nothing))
    end

    alter table(:rosters) do
      modify(:wrestler_id, references(:wrestlers, on_delete: :nothing))
    end

    alter table(:title_holders) do
      modify(:holder_alias_id, references(:aliases, on_delete: :nothing))
    end
  end
end
