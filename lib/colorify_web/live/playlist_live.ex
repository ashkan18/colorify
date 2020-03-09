defmodule ColorifyWeb.PlaylistLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <div class="main-live">
      <section class="main-stats">
        <%= if not Enum.empty?(@tracks) do %>
          <h2>Here are tracks in this playlist:</h2>
        <% end %>
        <%= for track <- @tracks do %>
          <div >
            <div class="serif-2 color-black60"> <%= track["track"]["name"] %> </div>
          </div>
        <% end %>
        <%= for {color, count} <- @colors do %>
          <div style="border-radius: 50%;display: inline-block;;background-color: <%= color %>; width: <%= count / 100 %>px; height: <%= count / 100 %>px"></div>
        <% end %>
      </section>
    </div>
    """
  end

  def mount(%{"id" => id }, session, socket) do
    if connected?(socket) do
      send(self(), {:initialize, session["access_token"], id})
    end
    {:ok,
     assign(socket,
       tracks: [],
       colors: %{},
       id: id
     )}
  end

  def handle_info({:initialize, token, id}, socket) do
    Spotify.client(token)
    |> Spotify.playlist_tracks(id)
    |> case do
      {:ok, tracks_response} ->
        tracks_response.body["tracks"]["items"]
        |> Enum.map( fn track ->
          IO.inspect(track, label: :track)
          send(self(), {:process_image, track["track"]["id"], List.first(track["track"]["album"]["images"])["url"]})
        end)
        {:noreply, assign(socket, tracks: tracks_response.body["tracks"]["items"]) }
      _ -> {:noreply, socket}
    end
  end

  def handle_info({:process_image, _track_id, image_url}, socket) do
    updated_colors = Colorify.Analyzer.analyze(image_url, 3)
    |> Enum.reduce(socket.assigns.colors, fn color, current_colors ->
      {_, new_map} = Map.get_and_update(current_colors, color["hex"], fn current_value -> {current_value, current_value || 0 + color["count"]} end)
      new_map
    end)
    |> IO.inspect(label: :new_map)
    {:noreply, assign(socket, colors: updated_colors)}
  end
end
