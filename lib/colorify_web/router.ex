defmodule ColorifyWeb.Router do
  use ColorifyWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ColorifyWeb do
    pipe_through :browser

    get "/auth", AuthController, :index
    get "/callback", AuthController, :callback
    delete "/logout", AuthController, :delete

    # pipe_through :ensure_admin_authed_access
    resources "/dashboard", DashboardController
    live "/playlists/:id", PlaylistLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", ColorifyWeb do
  #   pipe_through :api
  # end
end
