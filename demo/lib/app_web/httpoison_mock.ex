defmodule ElixirAuthMicrosoft.HTTPoisonMock do
  @moduledoc """
  SHOULD BE THE SAME AS THE ORIGINAL `httpoison_mock.ex`.
  """
  @spec get(any, nonempty_maybe_improper_list) :: {:error, :bad_request} | {:ok, %{body: binary}}
  def get(_url,  [ {:Authorization, token} = _authorization | _content_type]) do
    is_token_valid = token !== "Bearer invalid_token"

    if is_token_valid do
      {:ok,
      %{
        body:
          Jason.encode!(%{
           businessPhones: [],
           displayName: "Test Name",
           givenName: "Test",
           id: "192jnsd9010apd",
           jobTitle: nil,
           mail: nil,
           mobilePhone: '+351928837834',
           officeLocation: nil,
           preferredLanguage: nil,
           surname: "Name",
           userPrincipalName: "testemail@hotmail.com"}
          )
      }}
    else
      {:error, :bad_request}
    end
  end

  @spec post(any, any, any) :: {:ok, %{body: binary}}
  def post(_url, _body, _headers) do
    {:ok, %{body: Jason.encode!(%{access_token: "token1"})}}
  end
end
