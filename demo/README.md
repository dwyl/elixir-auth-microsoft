# `elixir-auth-microsoft` _demo_

This is a basic demo example of how one can use Microsoft Auth in a Phoenix aplication.


# _Why_? 🤷

Learning is the cornerstone of what makes a developer.
And when learning, it's really useful having *detailed docs*
that explain how to get up-and-running as fast as possible.

# _What_? 💭

This small demo is a *barebones* application using the 
[`elixir-auth-microsoft`](https://github.com/dwyl/elixir-auth-microsoft)
to add support for "***Sign-in with Microsoft***" to any Phoenix Application.

# _Who_? 👥

This demos is intended for people of all Elixir/Phoenix skill levels.
Anyone who wants the "***Sign-in with Microsoft***" functionality
without the extra steps to configure a whole auth _framework_.

Following all the steps in this example should take around 10 minutes.
However if you get stuck, please don't suffer in silence!
Get help by opening an issue: https://github.com/dwyl/elixir-auth-microsoft/issues

# _How?_ 💻

## 0. Create a New Phoenix App

Create a new Phoenix project if you don't already have one.


```
mix phx.new app --no-ecto 
```
> We don't need a database for this demo.

If prompted to install dependencies `Fetch and install dependencies? [Yn]`
Type `y` and hit the `[Enter]` key to install.


Make sure that everything works before proceeding:
```
mix test
```
You should see:
```
Generated app app
...

Finished in 0.02 seconds
3 tests, 0 failures
```
The default tests pass and you know the Phoenix app is compiling.

Run the web application:

```
mix phx.server
```

and visit the endpoint in your web browser: http://localhost:4000/
![phoenix-default-home](https://user-images.githubusercontent.com/194400/70126043-0d174b00-1670-11ea-856e-b31e593b5844.png)



## 1. Add the `elixir_auth_microsoft` package to `mix.exs` 📦

Open your `mix.exs` file and add the following line to your `deps` list:

```elixir
def deps do
  [
    {:elixir_auth_microsoft, "~> 0.1.0"}
  ]
end
```
Run the **`mix deps.get`** command to download.



## 2. Create an App Registration in Azure Active Directory ✨

If you're not sure how to proceed with Azure Portal and
setup your Active Directory application, please follow the 
[guide](../active_directory.md) to get your `client_id`
and `secret`.

By the end of this step
you should have these two environment variables defined:

```yml
"MICROSOFT_CLIENT_SECRET": "paX8Q~_SRO9~UScMi4GTyw.oC8U_De.MiqDX~dBO",
"MICROSOFT_CLIENT_ID" : "a00c63f7-6da6-43bd-a94f-74d36486264a"
```

> ⚠️ Don't worry, these keys aren't valid. 
They are just here for illustration purposes.

## 3. Create 2 New Files  ➕

We need to create two files in order to handle the requests
to the Microsoft Azure APIs and display data to people using our app.

### 3.1 Create a `MicrosoftAuthController` in your Project

So as to display the data returned by the Microsoft Graph API, 
we need to create a new `controller`.

Create a new file called
`lib/app_web/controllers/microsoft_auth_controller.ex`

and add the following code:

```elixir
defmodule AppWeb.MicrosoftAuthController do
  use AppWeb, :controller

  @doc """
  `index/2` handles the callback from Google Auth API redirect.
  """
  def index(conn, %{"code" => code, "state" => state}) do

    # Perform state change here (to prevent CSRF)
    if state !== "random_state_uid" do
      # error handling
    end

    {:ok, token} = ElixirAuthMicrosoft.get_token(code, conn)
    {:ok, profile} = ElixirAuthMicrosoft.get_user_profile(token.access_token)

    conn
    |> put_view(AppWeb.PageView)
    |> render(:welcome, profile: profile)
  end
end
```

Let's go over this code:
- Creates a one-time authentication token based on the `code` and, 
optionally `state` sent by Microsoft after the person authenticates.
- Request the account profie data from Microsoft based on
the received `access_token`.
- Render a `:welcome` view displaying some profile data
to confirm that login with Azure was successful.


> Note: we are placing the `welcome.html.eex` template
in the `template/page` directory to save having to create
any more directories and view files.
You are free to organise your code however you prefer.

### 3.2 Create `welcome` template 📝

Create a new file with the following path:
`lib/app_web/templates/page/welcome.html.eex`

And type (_or paste_) the following code in it:
```html
<section class="phx-hero">
  <h1> Welcome <%= @profile.displayName %>!</h1>
  <p> You are <strong>signed in</strong>
    with your <strong>Microsoft Account</strong> <br />
    <strong style="color:teal;"><%= @profile.userPrincipalName %></strong>
  </p>
</section>
```


The [Microsoft Graph API `get_profile`](https://learn.microsoft.com/en-us/graph/api/profile-get?view=graph-rest-beta&tabs=http)
 request returns profile data in the following format:
```elixir
%{
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
  userPrincipalName: "testemail@hotmail.com"
}
```

## 4. Add the `/auth/microsoft/callback` to `router.ex`

Open your `lib/app_web/router.ex` file
and locate the section that looks like `scope "/", AppWeb do`

Add the following line:

```elixir
get "/auth/microsoft/callback", MicrosoftAuthController, :index
```

That will direct the API request response
to the `MicrosoftAuthController` `:index` function we defined above.


## 5. Update `PageController.index`

In order to display the "Sign-in with Microsoft" button in the UI,
we need to _generate_ the URL for the button in the relevant controller,
and pass it to the template.

Open the `lib/app_web/controllers/page_controller.ex` file
and update the `index` function:

From:
```elixir
def index(conn, _params) do
  render(conn, "index.html")
end
```

To:
```elixir
def index(conn, _params) do
  state = "random_state_uid"

  oauth_microsoft_url = ElixirAuthMicrosoft.generate_oauth_url_authorize(conn, state)
  render(conn, "index.html",[oauth_microsoft_url: oauth_microsoft_url])
end
```

### 5.1 Update the `page/index.html.eex` Template

Open the `/lib/app_web/templates/page/index.html.eex` file
and type the following code:

```html
<section class="phx-hero">
  <h1>Welcome to Awesome App!</h1>
  <p>To get started, login to your Microsoft Account: </p>
  <a href={@oauth_microsoft_url}>
    <img src="https://learn.microsoft.com/en-us/azure/active-directory/develop/media/howto-add-branding-in-azure-ad-apps/ms-symbollockup_signin_light.png" alt="Sign in with Microsoft" />
  </a>
</section>
```

The home page of the app now has a big "Sign in with Microsoft" button:

![sign-in-button](https://20o8nn37v3mzb7unq3fsj61e-wpengine.netdna-ssl.com/wp-content/uploads/2021/07/Sign-in-with-Microsoft-Button.png)


Once the person completes their authentication with Microsoft,
they should see the following welcome message, 
with your account name and display name:

<img width="1306" alt="successful_login" src="https://user-images.githubusercontent.com/17494745/196441038-5cdfecbb-626e-42e0-be94-65fb9725dc19.png">


