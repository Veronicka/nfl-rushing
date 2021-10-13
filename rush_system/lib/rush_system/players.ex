defmodule RushSystem.Players do
  alias RushSystem.{Models.Player, Repo}

  def create(params) do
    params
    |> format_params()
    |> Player.changeset()
    |> Repo.insert()
  end

  def open_file_and_add_informations(file) do
    with {:ok, body} <- File.read(file),
         {:ok, items} <- Jason.decode(body) do
      Enum.each(items, fn item ->
        create(item)
      end)
    end
  end

  def fetch_all(%{"page" => page, "size" => size} = params) do
    order_by = Map.get(params, "order_by", nil)

    page = verify_integer(page)
    size = verify_integer(size)

    total = total_players()

    players =
      order_by
      |> Player.fetch_all(page, size)
      |> Repo.all()

    {:ok, %{players: players, total: total}}
  end

  def fetch_all(_), do: {:error, :invalid_params}

  def fetch_by_name(%{"name" => name, "page" => page, "size" => size} = params) do
    order_by = Map.get(params, "order_by", nil)

    page = verify_integer(page)
    size = verify_integer(size)

    total = total_players_name(name)

    players =
      name
      |> Player.fetch_by_name(order_by, page, size)
      |> Repo.all()

    {:ok, %{players: players, total: total}}
  end

  def fetch_by_name(_), do: {:error, :invalid_params}

  defp total_players(), do: Player.count() |> Repo.one()

  defp total_players_name(name), do: name |> Player.count_search_name() |> Repo.one()

  defp format_params(%{
         "1st" => first_downs,
         "1st%" => first_down_percent,
         "20+" => more_20_yards,
         "40+" => more_40_yards,
         "Att" => attempts,
         "Att/G" => attempts_per_game_avg,
         "Avg" => avg_yards_per_attempt,
         "FUM" => fumbles,
         "Lng" => longest_rush,
         "Player" => name,
         "Pos" => postion,
         "TD" => total_touchdowns,
         "Team" => team_abv,
         "Yds" => total_yards,
         "Yds/G" => yards_per_game
       }) do
    %{
      "name" => name,
      "team_abv" => team_abv,
      "postion" => postion,
      "attempts_per_game_avg" => verify_float(attempts_per_game_avg),
      "attempts" => verify_float(attempts),
      "total_yards" => verify_integer(total_yards),
      "avg_yards_per_attempt" => verify_float(avg_yards_per_attempt),
      "yards_per_game" => verify_float(yards_per_game),
      "total_touchdowns" => verify_integer(total_touchdowns),
      "longest_rush" => longest_rush,
      "first_downs" => verify_integer(first_downs),
      "first_down_percent" => verify_float(first_down_percent),
      "more_20_yards" => verify_integer(more_20_yards),
      "more_40_yards" => verify_integer(more_40_yards),
      "fumbles" => verify_integer(fumbles)
    }
  end

  defp verify_integer(param) do
    case is_integer(param) do
      true ->
        param

      false ->
        {value, _} = Integer.parse(param)
        value
    end
  end

  defp verify_float(param) do
    case is_float(param) do
      true ->
        param

      false ->
        if is_integer(param) do
          param * 1.0
        else
          {value, _} = Float.parse(param)
          value
        end
    end
  end
end
