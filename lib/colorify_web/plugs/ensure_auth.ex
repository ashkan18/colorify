defmodule ColorifyWeb.Plugs.EnsureAuth do
  import Plug.Conn
  import Phoenix.Controller

  def init(opts), do: opts

  def call(conn, _params) do
    case get_session(conn, :access_token) do
      nil ->
        conn
        |> redirect(to: "/auth")
        |> halt()

      _ ->
        conn
    end
  end
end
