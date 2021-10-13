defmodule RushSystemWeb.PlayerControllerTest do

  use RushSystemWeb.ConnCase, async: false

  import Mock

  alias RushSystem.Players

  setup do
    [
      fetch_players: %{
        players: [
          %RushSystem.Models.Player{
            attempts: 2.0,
            attempts_per_game_avg: 2.0,
            avg_yards_per_attempt: 3.5,
            first_down_percent: 0.0,
            first_downs: 0,
            fumbles: 0,
            id: 1,
            inserted_at: ~N[2021-10-11 02:13:05],
            longest_rush: "7",
            more_20_yards: 0,
            more_40_yards: 0,
            name: "Joe Banyard",
            postion: "RB",
            team_abv: "JAX",
            total_touchdowns: 0,
            total_yards: 7,
            updated_at: ~N[2021-10-11 02:13:05],
            yards_per_game: 7.0
          },
          %RushSystem.Models.Player{
            attempts: 5.0,
            attempts_per_game_avg: 1.7,
            avg_yards_per_attempt: 1.0,
            first_down_percent: 0.0,
            first_downs: 0,
            fumbles: 0,
            id: 2,
            inserted_at: ~N[2021-10-11 02:13:05],
            longest_rush: "9",
            more_20_yards: 0,
            more_40_yards: 0,
            name: "Shaun Hill",
            postion: "QB",
            team_abv: "MIN",
            total_touchdowns: 0,
            total_yards: 5,
            updated_at: ~N[2021-10-11 02:13:05],
            yards_per_game: 1.7
          }
        ],
      total: 2
      },
      order_by_total_touchdowns: %{
        players: [
          %RushSystem.Models.Player{
            attempts: 2.0,
            attempts_per_game_avg: 2.0,
            avg_yards_per_attempt: 3.5,
            first_down_percent: 0.0,
            first_downs: 0,
            fumbles: 0,
            id: 1,
            inserted_at: ~N[2021-10-11 02:13:05],
            longest_rush: "7",
            more_20_yards: 0,
            more_40_yards: 0,
            name: "Fred Jose",
            postion: "RB",
            team_abv: "JAX",
            total_touchdowns: 1,
            total_yards: 7,
            updated_at: ~N[2021-10-11 02:13:05],
            yards_per_game: 7.0
          },
          %RushSystem.Models.Player{
            attempts: 5.0,
            attempts_per_game_avg: 1.7,
            avg_yards_per_attempt: 1.0,
            first_down_percent: 0.0,
            first_downs: 0,
            fumbles: 0,
            id: 2,
            inserted_at: ~N[2021-10-11 02:13:05],
            longest_rush: "9",
            more_20_yards: 0,
            more_40_yards: 0,
            name: "Paul Hill",
            postion: "QB",
            team_abv: "MIN",
            total_touchdowns: 5,
            total_yards: 5,
            updated_at: ~N[2021-10-11 02:13:05],
            yards_per_game: 1.7
          }
        ],
        total: 2
      },
      fetch_by_name: %{
        players: [
          %RushSystem.Models.Player{
            attempts: 5.0,
            attempts_per_game_avg: 1.7,
            avg_yards_per_attempt: 1.0,
            first_down_percent: 0.0,
            first_downs: 0,
            fumbles: 0,
            id: 2,
            inserted_at: ~N[2021-10-11 02:13:05],
            longest_rush: "9",
            more_20_yards: 0,
            more_40_yards: 0,
            name: "Paul Hill",
            postion: "QB",
            team_abv: "MIN",
            total_touchdowns: 5,
            total_yards: 5,
            updated_at: ~N[2021-10-11 02:13:05],
            yards_per_game: 1.7
          }
        ],
        total: 1
      }
    ]
  end

  describe "Player Controller" do
    test "GET /api/players", fixture do
      with_mock Players,
        fetch_all: fn _ -> {:ok, fixture.fetch_players} end
      do
        conn =
          build_conn()
          |> get("/api/players?page=1&size=5")

        assert conn.status == 200
        assert conn.resp_body == "{\"message\":\"Players\",\"result\":[{\"name\":\"Joe Banyard\",\"team_abv\":\"JAX\",\"postion\":\"RB\",\"attempts_per_game_avg\":2.0,\"attempts\":2.0,\"total_yards\":7,\"avg_yards_per_attempt\":3.5,\"yards_per_game\":7.0,\"total_touchdowns\":0,\"longest_rush\":\"7\",\"first_downs\":0,\"first_down_percent\":0.0,\"more_20_yards\":0,\"more_40_yards\":0,\"fumbles\":0},{\"name\":\"Shaun Hill\",\"team_abv\":\"MIN\",\"postion\":\"QB\",\"attempts_per_game_avg\":1.7,\"attempts\":5.0,\"total_yards\":5,\"avg_yards_per_attempt\":1.0,\"yards_per_game\":1.7,\"total_touchdowns\":0,\"longest_rush\":\"9\",\"first_downs\":0,\"first_down_percent\":0.0,\"more_20_yards\":0,\"more_40_yards\":0,\"fumbles\":0}],\"total\":2}"
      end
    end

    test "GET /api/players?order_by=TD", fixture do
      with_mock Players,
        fetch_all: fn _ -> {:ok, fixture.order_by_total_touchdowns} end
      do
        conn =
          build_conn()
          |> get("/api/players?order_by=TD&page=1&size=5")

        assert conn.status == 200
        assert conn.resp_body == "{\"message\":\"Players\",\"result\":[{\"name\":\"Fred Jose\",\"team_abv\":\"JAX\",\"postion\":\"RB\",\"attempts_per_game_avg\":2.0,\"attempts\":2.0,\"total_yards\":7,\"avg_yards_per_attempt\":3.5,\"yards_per_game\":7.0,\"total_touchdowns\":1,\"longest_rush\":\"7\",\"first_downs\":0,\"first_down_percent\":0.0,\"more_20_yards\":0,\"more_40_yards\":0,\"fumbles\":0},{\"name\":\"Paul Hill\",\"team_abv\":\"MIN\",\"postion\":\"QB\",\"attempts_per_game_avg\":1.7,\"attempts\":5.0,\"total_yards\":5,\"avg_yards_per_attempt\":1.0,\"yards_per_game\":1.7,\"total_touchdowns\":5,\"longest_rush\":\"9\",\"first_downs\":0,\"first_down_percent\":0.0,\"more_20_yards\":0,\"more_40_yards\":0,\"fumbles\":0}],\"total\":2}"
      end
    end

    test "GET /api/players/:name", fixture do
      with_mock Players,
        fetch_by_name: fn _ -> {:ok, fixture.fetch_by_name} end
      do
        conn =
          build_conn()
          |> get("/api/players/paul?page=1&size=5")

        assert conn.status == 200
        assert conn.resp_body == "{\"message\":\"Players\",\"result\":[{\"name\":\"Paul Hill\",\"team_abv\":\"MIN\",\"postion\":\"QB\",\"attempts_per_game_avg\":1.7,\"attempts\":5.0,\"total_yards\":5,\"avg_yards_per_attempt\":1.0,\"yards_per_game\":1.7,\"total_touchdowns\":5,\"longest_rush\":\"9\",\"first_downs\":0,\"first_down_percent\":0.0,\"more_20_yards\":0,\"more_40_yards\":0,\"fumbles\":0}],\"total\":1}"
      end
    end
  end
end
