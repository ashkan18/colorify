defmodule SpotifyAuth do
  @moduledoc """
  An OAuth2 strategy for Spotify.
  """
  use OAuth2.Strategy

  alias OAuth2.Strategy.AuthCode

  def client do
    Application.get_env(:colorify, :oauth)
      |> Keyword.merge(config())
      |> OAuth2.Client.new()
      |> OAuth2.Client.put_serializer("application/json", Jason)
  end

  defp config do
    [
      strategy: SpotifyAuth, #default,
      scope: "playlist-read-private,user-library-read",
      site: "https://accounts.spotify.com",
      authorize_url: "/authorize",
      token_url: "/api/token"
    ]
  end

  # Strategy Callbacks

  def authorize_url!(params \\ []) do
    OAuth2.Client.authorize_url!(client(), params)
  end

  def get_token!(params \\ [], _headers \\ []) do
    OAuth2.Client.get_token!(client(), Keyword.merge(params, client_secret: client().client_secret))
  end

  # Strategy Callbacks

  def authorize_url(client, params) do
    AuthCode.authorize_url(client, params)
  end

  def get_token(client, params, headers) do
    client
    |> put_header("Accept", "application/json")
    |> AuthCode.get_token(params, headers)
  end
end
