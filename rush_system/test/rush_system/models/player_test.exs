defmodule RushSystem.Models.PlayerTest do
  @moduledoc """
    Test for Player
  """

  use RushSystem.DataCase

  alias RushSystem.Models.Player

  describe "changeset" do
    test "with valid attributes" do
      valid_params = %{
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

      changeset = Player.changeset(valid_params)
      assert changeset.valid?
    end

    test "changeset with missing required attributes" do
      invalid_params = %{}

      changeset = Player.changeset(invalid_params)
      refute changeset.valid?

      [
        name: {"can't be blank", [validation: :required]},
        team_abv: {"can't be blank", [validation: :required]},
        postion: {"can't be blank", [validation: :required]}
      ] = changeset.errors
    end
  end
end
