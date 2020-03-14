defmodule ColorifyWeb.DashboardController do
  use ColorifyWeb, :controller

  def index(conn, _) do
    user_id = get_session(conn, :user_id)

    conn
    |> get_session(:access_token)
    |> Spotify.client()
    |> Spotify.user_playlists(user_id)
    |> case do
      {:ok, response} ->
        case response.status do
          200 -> render(conn, "index.html", playlists: response.body["items"], user_id: user_id)
          _ -> redirect(conn, to: "/auth")
        end

      _ ->
        redirect(conn, to: "/auth")
    end
  end
end
