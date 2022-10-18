import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :app, AppWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "1sTIQUIvoLJRG01Z2HwWA9yoCUg70d4GeQTC+jrXRb/YVtxbOgp/7HdJlH6WTRsQ",
  server: false

# In test we don't send emails.
config :app, App.Mailer,
  adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :elixir_auth_microsoft,
  client_id: "ks920olws-10ls-109s-s9k2-ki290s92le1",
  client_secret: "82j01jsmi92kks001ljsu",
  httpoison_mock: true

System.put_env("GOOGLE_CLIENT_ID", "ks920olws-10ls-109s-s9k2-ki290s92le1")
