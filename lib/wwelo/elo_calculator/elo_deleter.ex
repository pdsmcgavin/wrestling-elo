defmodule Wwelo.EloCalculator.EloDeleter do
  @moduledoc """
  Wrestler Elo deleter module
  """
  alias Wwelo.Repo
  alias Wwelo.Stats.Elo

  def delete_all_elos do
    Repo.delete_all(Elo)
  end
end
