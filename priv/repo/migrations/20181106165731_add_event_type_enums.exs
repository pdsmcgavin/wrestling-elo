defmodule Wwelo.Repo.Migrations.AddEventTypeEnums do
  use Ecto.Migration

  def up do
    EventTypeEnum.create_type()

    execute("""
      alter table events alter column event_type type event_type using (event_type::event_type)
    """)
  end

  def down do
    execute("""
      alter table events alter column event_type type string
    """)

    EventTypeEnum.drop_type()
  end
end
