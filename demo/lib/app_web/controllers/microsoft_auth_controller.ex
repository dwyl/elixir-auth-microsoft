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

    conn
    |> put_session(:token, token)
    |> redirect(to: "/welcome")
  end

  @doc """
  `logout/2` handles the callback from Microsoft Auth API redirect after user logs out.
  """
  def logout(conn, _params) do

    # Clears token from user session
    conn = conn |> delete_session(:token)

    conn
    |> redirect(to: "/")
  end
end
