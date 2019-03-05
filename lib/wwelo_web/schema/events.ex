defmodule WweloWeb.Schema.Events do
  @moduledoc false
  use Absinthe.Schema.Notation

  alias Wwelo.StatsCache

  object :event do
    field(:name, :string)
    field(:date, :string)
    field(:event_type, :string)
    field(:id, :integer)
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
  end
end
