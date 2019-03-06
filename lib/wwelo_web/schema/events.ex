defmodule WweloWeb.Schema.Events do
  @moduledoc false
  use Absinthe.Schema.Notation

  alias Wwelo.StatsCache

  object :event do
    field(:name, :string)
    field(:date, :string)
    field(:event_type, :string)
    field(:id, :integer)
    field(:matches, list_of(:match))
  end

  object :match do
    field(:id, :integer)
    field(:stipulation, :string)
    field(:card_position, :integer)
    field(:participants, list_of(:participant))
  end

  object :participant do
    field(:id, :integer)
    field(:name, :string)
    field(:match_team, :integer)
    field(:elo_before, :float)
    field(:elo_after, :float)
    field(:outcome, :string)
  end

  object :events_queries do
    field :events, list_of(:event) do
      arg(:event_type, :string)

      resolve(fn %{
                   event_type: event_type
                 },
                 _ ->
        {:ok, StatsCache.get_events(event_type)}
      end)
    end

    field :event, :event do
      arg(:event_id, :integer)

      resolve(fn %{
                   event_id: event_id
                 },
                 _ ->
        {:ok, StatsCache.get_event(event_id)}
      end)
    end
  end
end
