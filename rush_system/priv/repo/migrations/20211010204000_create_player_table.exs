defmodule Acculynx.Repo.Migrations.CreatePlayerTable do
  use Ecto.Migration

  def change do
    create table(:players) do
      add(:name, :string, null: false)
      add(:team_abv, :string, null: false)
      add(:postion, :string, null: false)
      add(:attempts_per_game_avg, :float)
      add(:attempts, :float)
      add(:total_yards, :integer)
      add(:avg_yards_per_attempt, :float)
      add(:yards_per_game, :float)
      add(:total_touchdowns, :integer)
      add(:longest_rush, :string)
      add(:first_downs, :integer)
      add(:first_down_percent, :float)
      add(:more_20_yards, :integer)
      add(:more_40_yards, :integer)
      add(:fumbles, :integer)
      timestamps()
    end
  end
end
