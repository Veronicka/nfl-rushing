defmodule RushSystem.Factories do
  @moduledoc """
    Ecto Factories
  """
  use ExMachina.Ecto, repo: RushSystem.Repo
  alias RushSystem.Models.Player

  def player_factory do
    %Player{
      name: "John Snow",
      team_abv: "TST",
      postion: "RB",
      attempts_per_game_avg: 2.0,
      attempts: 2.0,
      total_yards: 5,
      avg_yards_per_attempt: 2.5,
      yards_per_game: 1.0,
      total_touchdowns: 1,
      longest_rush: "5",
      first_downs: 1,
      first_down_percent: 0.1,
      more_20_yards: 0,
      more_40_yards: 0,
      fumbles: 0
    }
  end
end
