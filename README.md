# Colorify
App for listing all your Spotify playlists and get color palette of songs in each playlist.

![](/docs/colorify.png)

## Run Locally
Colorify is a [Phoenix](https://www.phoenixframework.org/)-based application. It uses websocket based [LiveView](https://github.com/phoenixframework/phoenix_live_view) for analyzing album covers on the fly for each playlist and update the color palette as the results are coming in.

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Create `.env` file in your root folder and set variables based on `.env.example` 
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
