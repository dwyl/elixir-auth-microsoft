defmodule AppWeb.PageController do
  use AppWeb, :controller

  def index(conn, _params) do
    state = "random_state_uid"

    oauth_microsoft_url = ElixirAuthMicrosoft.generate_oauth_url_authorize(conn, state)
    render(conn, "index.html",[oauth_microsoft_url: oauth_microsoft_url])
  end

  def welcome(conn, _params) do

    # Check if there's a user_id in the session
    case conn |> get_session(:user_id) do

      # If not, we redirect the user to the login page
      nil ->
        conn |> redirect(to: "/")

      # If there's a user_id, we render the welcome page with stored user info
      user_id ->
        profile = %{
          id: user_id,
          displayName: get_session(conn, :user_name),
          userPrincipalName: get_session(conn, :user_email)
        }

        conn
        |> put_view(AppWeb.PageView)
        |> render(:welcome, %{profile: profile, logout_microsoft_url: ElixirAuthMicrosoft.generate_oauth_url_logout()})
    end
  end
end
