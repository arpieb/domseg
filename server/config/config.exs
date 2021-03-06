# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :domsegserver,
  namespace: DOMSegServer,
  ecto_repos: [DOMSegServer.Repo]

# Configures the endpoint
config :domsegserver, DOMSegServerWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: DOMSegServerWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: DOMSegServer.PubSub,
  live_view: [signing_salt: "AO/ls4V/"]

# Configure generators
config :domsegserver, :generators,
  binary_id: true

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :domsegserver, DOMSegServer.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.12.18",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2016 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Add support for alternate template engine(s)
config :phoenix, :template_engines,
  md: PhoenixMarkdown.Engine

config :phoenix_markdown, :earmark, %{
  gfm: true,
  smartypants: false,
  breaks: true
}

config :phoenix_markdown, :server_tags, :all

# Configure dart_sass
config :dart_sass,
  version: "1.43.1",
  default: [
    args: ~w(css/app.scss ../priv/static/assets/app.css),
    cd: Path.expand("../assets", __DIR__)
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
