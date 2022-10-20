defmodule AppWeb.PageController do
  use AppWeb, :controller

  def index(conn, _params) do
    state = "random_state_uid"

    oauth_microsoft_url = ElixirAuthMicrosoft.generate_oauth_url_authorize(conn, state)
    render(conn, "index.html",[oauth_microsoft_url: oauth_microsoft_url])
  end
end
