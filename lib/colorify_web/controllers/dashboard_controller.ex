defmodule ColorifyWeb.DashboardController do
  use ColorifyWeb, :controller

  def index(conn, _) do
    {:ok, response} =
      get_session(conn, :access_token)
      |> Spotify.client()
      |> Spotify.user_playlists("ashkan18")
    render(conn, "index.html", playlists: response.body["items"])
  end
end
