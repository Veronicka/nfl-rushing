defmodule RushSystemWeb.PlayerView do
  use RushSystemWeb, :view

  def render("csv_data.json", %{data: data}) do
    %{message: "csv", data: data}
  end

  def render("list_players.json", %{result: result, total: total}) do
    %{message: "Players", result: result, total: total}
  end

  def render("changeset.json", %{changeset: changeset}) do
    "Data input error: #{inspect(changeset.errors)}"
  end

  def render("api_error.json", %{reason: reason}) do
    %{message: "Rush System Error", reason: reason}
  end
end
