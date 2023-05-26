defmodule AppWeb.PageController do
  use AppWeb, :controller

  def index(conn, _params) do
    state = "random_state_uid"

    oauth_microsoft_url = ElixirAuthMicrosoft.generate_oauth_url_authorize(conn, state)
    render(conn, "index.html",[oauth_microsoft_url: oauth_microsoft_url])
  end

  def welcome(conn, _params) do

    # Check if there's a session token
    case conn |> get_session(:token) do

      # If not, we redirect the user to the login page
      nil ->
        conn |> redirect(to: "/")

      # If there's a token, we render the welcome page
      token ->
        {:ok, profile} = ElixirAuthMicrosoft.get_user_profile(token.access_token)

        conn
        |> put_view(AppWeb.PageView)
        |> render(:welcome, %{profile: profile, logout_microsoft_url: ElixirAuthMicrosoft.generate_oauth_url_logout()})
    end
  end
end
