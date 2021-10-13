defmodule RushSystem.PlayersTest do
  @moduledoc """
    Test for Players
  """
  use RushSystem.DataCase

  alias RushSystem.{Models.Player, Players}

  import RushSystem.Factories

  describe "Players.create_player/1" do
    test "Player is successfully created" do
      {:ok, player} =
        Players.create(%{
          "Player" => "Sansa",
          "Team" => "JAX",
          "Pos" => "RB",
          "Att" => 2,
          "Att/G" => 2,
          "Yds" => 7,
          "Avg" => 3.5,
          "Yds/G" => 7,
          "TD" => 0,
          "Lng" => "7",
          "1st" => 0,
          "1st%" => 0,
          "20+" => 0,
          "40+" => 0,
          "FUM" => 0
        })

      assert Repo.one(Player) == player
    end
  end

  describe "Players.fetch_by_name/3" do
    test "should succesfully find player by name" do
      player = insert(:player)

      {status, result} = Players.fetch_by_name(%{"name" => "John", "page" => 1, "size" => 5})

      assert status == :ok
      assert result.total == 1
      assert List.first(result.players) == player
    end

    test "should handle not finding player by name" do
      {status, result} = Players.fetch_by_name(%{"name" => "Ned Stark", "page" => 1, "size" => 5})

      assert status == :ok
      assert result.total == 0
      assert result.players == []
    end
  end

  describe "Players.fetch_all/2" do
    test "should succesfully fecth all" do
      insert(:player)
      insert(:player, name: "Jack")

      {status, result} = Players.fetch_all(%{"page" => 1, "size" => 5})

      assert status == :ok
      assert result.total == 2
      assert length(result.players) == 2
    end

    test "should succesfully order players by total_touchdowns" do
      insert(:player, total_touchdowns: 1)
      insert(:player, name: "Jack", total_touchdowns: 2)

      {:ok, result} = Players.fetch_all(%{"order_by" => "TD", "page" => "1", "size" => "5"})

      assert result.total == 2
      assert Enum.at(result.players, 0).total_touchdowns == 1
      assert Enum.at(result.players, 1).total_touchdowns == 2
    end

    test "should succesfully order players by longest_rush" do
      insert(:player, longest_rush: "1")
      insert(:player, name: "Jack", longest_rush: "2")

      {:ok, result} = Players.fetch_all(%{"order_by" => "Lng", "page" => "1", "size" => "5"})

      assert result.total == 2
      assert Enum.at(result.players, 0).longest_rush == "1"
      assert Enum.at(result.players, 1).longest_rush == "2"
    end

    test "should succesfully order players by total_yards" do
      insert(:player, total_yards: 1)
      insert(:player, name: "Jack", total_yards: 2)

      {:ok, result} = Players.fetch_all(%{"order_by" => "Yds", "page" => "1", "size" => "5"})

      assert result.total == 2
      assert Enum.at(result.players, 0).total_yards == 1
      assert Enum.at(result.players, 1).total_yards == 2
    end
  end
end
