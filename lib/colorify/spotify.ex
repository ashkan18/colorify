defmodule Spotify do
  use Tesla

  def user_playlists(client, user_id) do
    Tesla.get(client, "v1/users/" <> user_id <> "/playlists")
  end

  def playlist_tracks(client, playlist_id) do
    # , query: [fields: "name,tracks.items(track(name,href,album(images,name,href))"])
    Tesla.get(client, "v1/playlists/" <> playlist_id)
  end

  def client(token) do
    middleware = [
      {Tesla.Middleware.BaseUrl, "https://api.spotify.com/"},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers, [{"authorization", "Bearer " <> token}]}
    ]

    Tesla.client(middleware)
  end
end
