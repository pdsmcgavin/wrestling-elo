defmodule Wwelo.Repo.Migrations.AddMatchOutcomeEnums do
  use Ecto.Migration

  def up do
    MatchOutcomeEnum.create_type()

    execute("""
      alter table participants alter column outcome type match_outcome using (outcome::match_outcome)
    """)
  end

  def down do
    execute("""
      alter table participants alter column outcome type string
    """)

    MatchOutcomeEnum.drop_type()
  end
end
