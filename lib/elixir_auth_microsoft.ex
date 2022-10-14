defmodule ElixirAuthMicrosoft do
  @moduledoc """
  Minimalist Google OAuth Authentication for Elixir Apps.
  Extensively tested, documented, maintained and in active use in production.
  """
  @authorize_url "https://login.microsoftonline.com/common/oauth2/v2.0/authorize"
  @token_url "https://login.microsoftonline.com/common/oauth2/v2.0/token"
  @profile_url "https://graph.microsoft.com/v1.0/me"
  @default_scope "https://graph.microsoft.com/User.Read"
  @default_callback_path "/auth/microsoft/callback"

  @httpoison HTTPoison

  def inject_poison, do: @httpoison

  def generate_oauth_url_authorize(_conn) do
    query = %{
      client_id: "a00c63f7-6da6-43bd-a94f-74d36486264a",
      response_type: "code",
      redirect_uri: "http://localhost:4000/auth/microsoft/callback",
      scope: @default_scope,
      response_mode: "query",
      state: "1234"
    }

    params = URI.encode_query(query, :rfc3986)

    "#{@authorize_url}?&#{params}"
  end

  def get_token(code, _conn) do

    headers = ["Content-Type": "multipart/form-data"]

    # We don't encode with JSON because the endpoint only works properly with uriencoded form data
    body = [
      {"grant_type", "authorization_code"},
      {"client_id", "a00c63f7-6da6-43bd-a94f-74d36486264a"},
      {"redirect_uri", "http://localhost:4000/auth/microsoft/callback"},
      {"code", code},
      {"scope", @default_scope},
      {"client_secret", google_client_secret()}
    ]

    inject_poison().post(@token_url, {:multipart, body}, headers)
    |>parse_body_response()

  end

  def get_user_profile(token) do
    headers = ["Authorization": "Bearer #{token}", "Content-Type": "application/json"]

    inject_poison().get(@profile_url, headers)
    |> parse_body_response()

  end

  def parse_body_response({:error, err}), do: {:error, err}
  def parse_body_response({:ok, response}) do
    body = Map.get(response, :body)
    # make keys of map atoms for easier access in templates
    if body == nil do
      {:error, :no_body}
    else
      {:ok, str_key_map} = Jason.decode(body)
      atom_key_map = for {key, val} <- str_key_map, into: %{}, do: {String.to_atom(key), val}
      {:ok, atom_key_map}
    end
  end


  defp google_client_secret do
    System.get_env("MICROSOFT_CLIENT_SECRET")
  end

end
