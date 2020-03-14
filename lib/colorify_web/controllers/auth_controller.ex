defmodule ColorifyWeb.AuthController do
  use ColorifyWeb, :controller

  @doc """
  This action is reached via `/auth` and redirects to the OAuth2 provider
  based on the chosen strategy.
  """
  def index(conn, _) do
    redirect(conn, external: SpotifyAuth.authorize_url!())
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  @doc """
  This action is reached via `/callback` is the the callback URL that
  the OAuth2 provider will redirect the user back to with a `code` that will
  be used to request an access token. The access token will then be used to
  access protected resources on behalf of the user.
  """
  def callback(conn, %{"code" => code}) do
    with token_client <- SpotifyAuth.get_token!(code: code),
         access_token <- token_client.token.access_token,
         {:ok, user_response} <- access_token |> Spotify.client() |> Spotify.me() do
      conn
      |> put_session(:user_id, user_response.body["id"])
      |> put_session(:access_token, access_token)
      |> redirect(to: "/")
    else
      _ -> redirect(conn, to: "/auth")
    end
  end
end
