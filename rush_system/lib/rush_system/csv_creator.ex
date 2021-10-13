defmodule RushSystem.CSVCreator do

  require Logger

  alias RushSystem.{Models.Player, Repo}

  def generate_csv(callback) do
    Logger.info("Generating CSV ...")

    Repo.transaction(fn ->
      Player.fetch_all_without_pagination()
      |> Repo.stream()
      |> Stream.map(&build_csv_row/1)
      |> CSV.Encoding.Encoder.encode(headers: true)
      |> callback.()
    end)

    Logger.info("Done")
  end

  defp build_csv_row(row) do
    %{
      "id" => row.id,
      "1st" => row.first_downs,
      "1st%" => row.first_down_percent,
      "20+" => row.more_20_yards,
      "40+" => row.more_40_yards,
      "Att" => row.attempts,
      "Att/G" => row.attempts_per_game_avg,
      "Avg" => row.avg_yards_per_attempt,
      "FUM" => row.fumbles,
      "Lng" => row.longest_rush,
      "Player" => row.name,
      "Pos" => row.postion,
      "TD" => row.total_touchdowns,
      "Team" => row.team_abv,
      "Yds" => row.total_yards,
      "Yds/G" => row.yards_per_game
    }
  end
end
