defmodule ColorifyWeb.DashboardController do
  use ColorifyWeb, :controller

  def index(conn, _) do
    conn
      |> get_session(:access_token)
      |> Spotify.client()
      |> Spotify.user_playlists("ashkan18")
      |> case do
        {:ok, response} ->
          case response.status do
            200 -> render(conn, "index.html", playlists: response.body["items"])
            _ -> redirect(conn, to: "/auth")
          end
        _ -> redirect(conn, to: "/auth")
      end
  end
end
