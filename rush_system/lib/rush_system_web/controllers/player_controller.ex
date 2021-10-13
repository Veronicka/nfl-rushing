defmodule RushSystemWeb.PlayerController do
  use RushSystemWeb, :controller

  alias RushSystem.{CSVCreator, Players}

  def fetch_all(conn, params) do
    case Players.fetch_all(params) do
      {:ok, %{players: players, total: total}} ->
        render(conn, "list_players.json", result: players, total: total)

      {:error, reason} ->
        render(conn, "api_error.json", reason: reason)
    end
  end

  def fetch_by_name(conn, params) do
    case Players.fetch_by_name(params) do
      {:ok, %{players: players, total: total}} ->
        render(conn, "list_players.json", result: players, total: total)

      {:error, reason} ->
        render(conn, "api_error.json", reason: reason)
    end
  end

  def generate_csv(conn, _params) do
    conn =
      conn
      |> put_resp_content_type("text/csv")
      |> put_resp_header("content-disposition", ~s[attachment; filename="report.csv"])
      |> send_chunked(:ok)

    CSVCreator.generate_csv(fn stream ->
      for result <- stream do
        conn |> chunk(result)
      end
    end)

    conn
  end
end
