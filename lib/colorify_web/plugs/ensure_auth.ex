defmodule ColorifyWeb.Plugs.EnsureAuth do
  import Plug.Conn
  import Phoenix.Controller

  def init(opts), do: opts

  def call(conn, _params) do
    case get_session(conn, :access_token) do
      nil -> conn
        |> put_flash(:error, "You need to sign in or sign up before continuing.")
        |> redirect(to: "/auth")
        |> halt()
      _ -> conn
    end
  end
end
