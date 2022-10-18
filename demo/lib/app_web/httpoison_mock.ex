defmodule ElixirAuthMicrosoft.HTTPoisonMock do
  def get("https://login.microsoftonline.com/common/oauth2/v2.0/authorize") do
    {:error, :bad_request}
  end

  def get(_url, _headers) do
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
  end


  def post(_url, _body, _headers) do
    {:ok, %{body: Jason.encode!(%{access_token: "token1", code: "code1"})}}
  end
end
