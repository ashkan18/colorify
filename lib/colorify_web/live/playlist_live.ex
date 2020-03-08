defmodule ColorifyWeb.PlaylistLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <div class="main-live">
      <section class="main-stats">
        <%= if @tracks != [] do %>
          <h2>Here are tracks in this playlist:</h2>
        <% end %>
        <%= for track <- @tracks do %>
          <div class="artwork-event">
            <div class="serif-2 color-black60"> <%= track["track"]["name"] %> </div>
          </div>
        <% end %>
      </section>
    </div>
    """
  end

  def mount(%{"id" => id }, session, socket) do
    if connected?(socket) do
      #   #ColorifyWeb.Endpoint.subscribe("events")
      send(self(), {:initialize, session["access_token"], id})
    end
    {:ok,
     assign(socket,
       tracks: [],
       colors: [],
       id: id
     )}
  end

  def handle_info({:initialize, token, id}, socket) do
    {:ok, tracks_response} = Spotify.client(token)
      |> Spotify.playlist_tracks(id)
    {:noreply,
      assign(socket, tracks: tracks_response.body["tracks"]["items"])
    }
  end
end
