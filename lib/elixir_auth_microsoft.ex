defmodule ElixirAuthMicrosoft do


  @authorize_url "https://login.microsoftonline.com/common/oauth2/v2.0/authorize"
  @token_url "https://login.microsoftonline.com/common/oauth2/v2.0/token"
  @profile_url "https://graph.microsoft.com/v1.0/me"
  @default_scope "https://graph.microsoft.com/User.Read"
  @default_callback_path "/auth/microsoft/callback"

  @httpoison (Application.compile_env(:elixir_auth_microsoft, :httpoison_mock) &&
  ElixirAuthMicrosoft.HTTPoisonMock) || HTTPoison

  def inject_poison, do: @httpoison

  def generate_oauth_url_authorize(conn) do
    query = %{
      client_id: microsoft_client_id(),
      response_type: "code",
      redirect_uri: generate_redirect_uri(conn),
      scope: @default_scope,
      response_mode: "query",
      state: "1234"
    }

    params = URI.encode_query(query, :rfc3986)

    "#{@authorize_url}?&#{params}"
  end

  def get_token(code, conn) do
    headers = ["Content-Type": "multipart/form-data"]

    # We don't encode with JSON because the endpoint only works properly with uriencoded form data
    body = [
      {"grant_type", "authorization_code"},
      {"client_id", microsoft_client_id()},
      {"redirect_uri", generate_redirect_uri(conn)},
      {"code", code},
      {"scope", @default_scope},
      {"client_secret", microsoft_client_secret()}
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


  defp generate_redirect_uri(conn) do
    get_baseurl_from_conn(conn) <> get_callback_path()
  end


  defp microsoft_client_secret do
    System.get_env("MICROSOFT_CLIENT_SECRET")
  end

  defp microsoft_client_id do
    System.get_env("MICROSOFT_CLIENT_ID")
  end

  defp get_callback_path do
    System.get_env("MICROSOFT_CALLBACK_PATH") || @default_callback_path
  end


  defp get_baseurl_from_conn(%{host: h, port: p}) when h == "localhost" do
    "http://#{h}:#{p}"
  end

  defp get_baseurl_from_conn(%{host: h}) do
    "https://#{h}"
  end

end
