defmodule Wwelo.Repo.Migrations.AddGenderEnums do
  use Ecto.Migration

  def up do
    GenderEnum.create_type()

    execute("""
     alter table wrestlers alter column gender type gender using (gender::gender)
    """)
  end

  def down do
    execute("""
    alter table wrestlers alter column gender type string
    """)

    GenderEnum.drop_type()
  end
end
