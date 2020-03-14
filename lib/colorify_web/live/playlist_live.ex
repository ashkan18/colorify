defmodule ColorifyWeb.PlaylistLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <div class="main-live">
      <section class="main-stats">
        <%= if not Enum.empty?(@tracks) do %>
          <h2>Here are tracks in this playlist: (<%= @number_of_tracks %>/<%= @processed_tracks %>)</h2>
        <% end %>
        <div style="display: flex;flex-direction: row; flex-wrap: wrap; justify-content: space-between; text-align: center;">
          <%= for track <- @tracks do %>
            <%= if Enum.member?(@selected_tracks, track["track"]["id"]) do %>
              <div class="track selected"> <%= track["track"]["name"] %> </div>
            <% else %>
              <div class="track"> <%= track["track"]["name"] %> </div>
            <% end %>
          <% end %>
        </div>
        <div style="display: flex;flex-direction: row;flex-wrap: wrap; align-items: center; width: 1000px;justify-content: space-between;margin-top: 20px;">
          <%= for {color, %{"count" => count}} <- @colors do %>
            <div phx-click="select_color" phx-value-color=<%= color %> style="border-radius: 50%;display: inline-block;background-color: <%= color %>; width: <%= (count / @max) * 200 %>px; height: <%= (count / @max) * 200 %>px"></div>
          <% end %>
        </div>
      </section>
    </div>
    """
  end

  def mount(%{"id" => id}, session, socket) do
    if connected?(socket) do
      send(self(), {:initialize, session["access_token"], id})
    end

    {:ok,
     assign(socket,
       tracks: [],
       colors: %{},
       id: id,
       min: 0,
       max: 100,
       selected_tracks: [],
       number_of_tracks: 0,
       processed_tracks: 0
     )}
  end

  def handle_event("select_color", %{"color" => selected_color}, socket) do
    {:ok, selected_tracks} =
      socket.assigns.colors
      |> Map.fetch(selected_color)

    {:noreply, assign(socket, selected_tracks: selected_tracks["track_ids"])}
  end

  def handle_info({:initialize, token, id}, socket) do
    Spotify.client(token)
    |> Spotify.playlist_tracks(id)
    |> case do
      {:ok, tracks_response} ->
        tracks_response.body["tracks"]["items"]
        |> Enum.map(fn track ->
          send(self(), {:process_image, track["track"]["id"], List.first(track["track"]["album"]["images"])["url"]})
        end)

        {:noreply, assign(socket, tracks: tracks_response.body["tracks"]["items"], number_of_tracks: length(tracks_response.body["tracks"]["items"]))}

      _ ->
        {:noreply, socket}
    end
  end

  def handle_info({:process_image, track_id, image_url}, socket) do
    updated_colors =
      Colorify.Analyzer.analyze(image_url, 2)
      |> Enum.reduce(socket.assigns.colors, fn color, current_colors ->
        {_, new_map} =
          current_colors
          |> Map.get_and_update(color["hex"], fn current_value ->
            new_value =
              case current_value do
                %{"count" => count, "track_ids" => track_ids} -> %{"count" => count + color["count"], "track_ids" => track_ids ++ [track_id]}
                _ -> %{"count" => color["count"], "track_ids" => [track_id]}
              end

            {current_value, new_value}
          end)

        new_map
      end)

    {{_, min}, {_, max}} = Enum.min_max_by(updated_colors, fn {_k, v} -> v["count"] end)

    {:noreply, assign(socket, colors: updated_colors, min: min["count"], max: max["count"], processed_tracks: socket.assigns.processed_tracks + 1)}
  end
end
