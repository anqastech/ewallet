use Mix.Config

# General application configuration
config :frontend,
  namespace: Frontend,
  ecto_repos: [],
  dist_path: {:apply, {Utils.Helpers.PathResolver, :static_dir, [:frontend]}}

watchers =
  if System.get_env("WEBPACK_WATCH") do
    [
      npm: [
        "run",
        "build",
        cd: Path.expand("../assets", __DIR__)
      ]
    ]
  else
    []
  end

# Configures the endpoint
config :frontend, Frontend.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: Frontend.ErrorView, accepts: ~w(html json)],
  watchers: watchers

config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
