defmodule Wwelo.Utils.GetEloConsts do
  @moduledoc false

  def get_elo_consts do
    %{
      default_elo: 1200,
      match_weight: 32,
      elo_base: 10,
      distribution_factor: 400
    }
  end
end
