defmodule AppWeb.MicrosoftAuthController do
  use AppWeb, :controller

  @doc """
  `index/2` handles the callback from Microsoft Auth API redirect.
  """
  def index(conn, %{"code" => code, "state" => state}) do

    # Perform state change here (to prevent CSRF)
    if state !== "random_state_uid" do
      # error handling
    end

    {:ok, token} = ElixirAuthMicrosoft.get_token(code, conn)
    {:ok, profile} = ElixirAuthMicrosoft.get_user_profile(token.access_token)

    # Store only essential user info to avoid cookie overflow
    # Azure AD tokens can be 8KB+ for users with many group memberships
    conn
    |> put_session(:user_id, profile.id)
    |> put_session(:user_email, profile.mail || profile.userPrincipalName)
    |> put_session(:user_name, profile.displayName)
    |> redirect(to: "/welcome")
  end

  @doc """
  `logout/2` handles the callback from Microsoft Auth API redirect after user logs out.
  """
  def logout(conn, _params) do

    # Clears all user data from session
    conn
    |> clear_session()
    |> redirect(to: "/")
  end
end
