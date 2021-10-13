defmodule RushSystemWeb.Router do
  use RushSystemWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Other scopes may use custom stacks.
  scope "/api", RushSystemWeb do
    pipe_through :api

    get "/players", PlayerController, :fetch_all
    get "/players/generate_csv", PlayerController, :generate_csv
    get "/players/:name", PlayerController, :fetch_by_name
  end
end
