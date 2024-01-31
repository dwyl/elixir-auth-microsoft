import Config

config :elixir_auth_microsoft,
  client_id: "ks920olws-10ls-109s-s9k2-ki290s92le1",
  client_secret: "82j01jsmi92kks001ljsu",
  post_logout_redirect_uri: "http://localhost:4000/auth/microsoft/logout",

  httpoison_mock: true

System.put_env("MICROSOFT_CLIENT_ID", "ks920olws-10ls-109s-s9k2-ki290s92le1")
System.put_env("MICROSOFT_POST_LOGOUT_REDIRECT_URI", "http://localhost:4000/auth/microsoft/logout")
