defmodule RushSystem.Models.Player do
  @moduledoc """
  Model for a players' rushing statistics
  """

  use Ecto.Schema

  import Ecto.{Changeset, Query}

  @fields [
    :name,
    :team_abv,
    :postion,
    :attempts_per_game_avg,
    :attempts,
    :total_yards,
    :avg_yards_per_attempt,
    :yards_per_game,
    :total_touchdowns,
    :longest_rush,
    :first_downs,
    :first_down_percent,
    :more_20_yards,
    :more_40_yards,
    :fumbles
  ]

  @derive {
    Jason.Encoder,
    only: @fields
  }

  @required [:name, :team_abv, :postion]

  schema "players" do
    field(:name, :string)
    field(:team_abv, :string)
    field(:postion, :string)
    field(:attempts_per_game_avg, :float)
    field(:attempts, :float)
    field(:total_yards, :integer)
    field(:avg_yards_per_attempt, :float)
    field(:yards_per_game, :float)
    field(:total_touchdowns, :integer)
    field(:longest_rush, :string)
    field(:first_downs, :integer)
    field(:first_down_percent, :float)
    field(:more_20_yards, :integer)
    field(:more_40_yards, :integer)
    field(:fumbles, :integer)
    timestamps()
  end

  def build(params) do
    params
    |> changeset()
    |> apply_action(:insert)
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @fields)
    |> validate_required(@required)
  end

  def fetch_all_csv(name \\ nil, order \\ nil) do
    query = from(p in __MODULE__) |> order_by_param(order)

    if is_nil(name) or name == "null" do
      query
    else
      downcase = String.downcase(name)
      like_term = "%#{downcase}%"

      from(p in query,
        where: like(fragment("lower(?)", p.name), ^like_term)
      )
    end
  end

  def fetch_all(order \\ nil, page \\ 1, size \\ 10) do
    from(p in __MODULE__)
    |> order_by_param(order)
    |> paginate(page, size)
  end

  def fetch_all_without_pagination() do
    from(p in __MODULE__)
  end

  def fetch_by_name(name, order \\ nil, page \\ 1, size \\ 10) do
    downcase = String.downcase(name)
    like_term = "%#{downcase}%"

    from(p in __MODULE__,
      where: like(fragment("lower(?)", p.name), ^like_term)
    )
    |> order_by_param(order)
    |> paginate(page, size)
  end

  def count() do
    from(p in __MODULE__, select: count(p.id))
  end

  def count_search_name(name) do
    downcase = String.downcase(name)
    like_term = "%#{downcase}%"

    from(p in __MODULE__,
      select: count(p.id),
      where: like(fragment("lower(?)", p.name), ^like_term)
    )
  end

  defp order_by_param(query, param) do
    from(query,
      order_by: ^player_param(param)
    )
  end

  defp player_param("Yds"), do: {:asc, :total_yards}

  defp player_param("Lng"), do: {:asc, :longest_rush}

  defp player_param("TD"), do: {:asc, :total_touchdowns}

  defp player_param("null"), do: []

  defp player_param(nil), do: []

  defp paginate(query, page, size) do
    from(query,
      limit: ^size,
      offset: ^((page - 1) * size)
    )
  end
end
