<div align="center">

# `elixir-auth-microsoft` _demo_

A basic demo/example of how to use
Microsoft Auth in a `Phoenix` aplication.

</div>

# _Why_? 🤷

We love full working examples
with step-by-step instructions.
This demo shows you 
how to get up-and-running as fast as possible.

# _What_? 💭

A *barebones* demo/exampe `Phoenix` app using 
[`elixir-auth-microsoft`](https://github.com/dwyl/elixir-auth-microsoft)
to add "***Sign-in with Microsoft***".

# _Who_? 👥

This demos is intended for people of all `Elixir`/`Phoenix` skill levels.
Anyone who wants the "***Sign-in with Microsoft***"
without the extra steps to configure a whole auth _framework_.

Following all the steps in this example 
should take around **10 minutes**.
However if you get stuck, please don't suffer in silence!
[Open an issue](https://github.com/dwyl/elixir-auth-microsoft/issues)

# _How?_ 💻

## 0. Create a New Phoenix App

Create a new `Phoenix` project if you don't already have one.


```sh
mix phx.new app --no-ecto 
```

> We don't need a database for this demo.

When prompted to install dependencies 
`Fetch and install dependencies? [Yn]`
Type `y` and hit the `[Enter]` key to install.


Make sure that everything works before proceeding:

```sh
mix test
```

You should see:

```sh
Generated app app
...

Finished in 0.02 seconds
3 tests, 0 failures
```

The default tests pass 
and you know the `Phoenix` app is compiling.

Run the app:

```sh
mix phx.server
```

and visit the endpoint in your web browser: 
http://localhost:4000/

![phoenix-default-home](https://user-images.githubusercontent.com/194400/70126043-0d174b00-1670-11ea-856e-b31e593b5844.png)

## 1. Add the `elixir_auth_microsoft` package to `mix.exs` 📦

Open your `mix.exs` file 
and add the following line 
to your `deps` list:

```elixir
def deps do
  [
    {:elixir_auth_microsoft, "~> 1.0.0"}
  ]
end
```

Run **`mix deps.get`** to download.

## 2. Create an App Registration in Azure Active Directory ✨

If you're not sure how to proceed with Azure Portal and
setup your Active Directory application, 
please follow the 
[`azure_app_registration_guide.md`](https://github.com/dwyl/elixir-auth-microsoft/blob/main/azure_app_registration_guide.md)
to get your `client_id`
and `secret`.

By the end of this step
you should have these two environment variables defined:

```yml
export MICROSOFT_CLIENT_SECRET=rDq8Q~.uc-237FryAt-lGu7G1sQkKR
export MICROSOFT_CLIENT_ID=a3d22eeb-85aa-4650-8ee8-3383931
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

Let's review this code:

- Creates a one-time authentication token based on the `code` and, 
optionally `state` sent by Microsoft after the person authenticates.

- Request the account profie data from Microsoft based on
the received `access_token`.

- Render a `:welcome` view displaying some profile data
to confirm that login with Azure was successful.

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

> **Note**: we are placing the
>  `welcome.html.eex` template
> in the `template/page` directory to save having to create
> any more directories and view files.
> You are free to organise your code however you prefer.


The Microsoft Graph API 
[`get_profile`](https://learn.microsoft.com/en-us/graph/api/profile-get?view=graph-rest-beta&tabs=http)
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

e.g:

![elixir-auth-microsoft-demo](https://user-images.githubusercontent.com/194400/196782404-0918edf9-65e1-4a4d-b676-31bd10b8cd42.png)

Once the person completes their authentication with Microsoft,
they should see the following welcome message, 
with your account name and display name:

![auth-success-welcome](https://user-images.githubusercontent.com/194400/196753288-31b1ddd3-8e4e-40e6-bf7d-35214a05c546.png)


## 6. Maintaining the token in session

Currently, if you refresh the page,
the token is not persisted 
and you lose your "logged in" status.

To fix this,
we are going to put the retrieved token
in the `conn` session.

Firstly, let's change the 
"app" page to its own.
Go to `lib/app_web/router.ex`
and add the following route
in the `scope "/"`.

```elixir
scope "/", AppWeb do
  pipe_through :browser

  get "/", PageController, :index
  get "/welcome", PageController, :welcome   # add this one
  get "/auth/microsoft/callback", MicrosoftAuthController, :index
end
```

We're going to make the person 
redirect to `/welcome` after successful login.
Go to `lib/app_web/controllers/page_controller.ex`
and add the following function.

```elixir
  def welcome(conn, _params) do

    # Check if there's a session token
    case conn |> get_session(:token) do

      # If not, we redirect the person to the login page
      nil ->
        conn |> redirect(to: "/")

      # If there's a token, we render the welcome page
      token ->
        {:ok, profile} = ElixirAuthMicrosoft.get_user_profile(token.access_token)

        conn
        |> put_view(AppWeb.PageView)
        |> render(:welcome, profile: profile)
    end
  end
```

We are using the 
[`get_session`](https://hexdocs.pm/plug/Plug.Conn.html#get_session/2)
to retrieve the `token` from the session.
We've *yet* to place it there in the first place,
but don't worry, we'll do it next!
If no `token` is found,
we redirect the person to the homepage to login.
If it is, we render the page normally!

Now let's put the `token` in the session
after the person logs in successfully.

In `lib/app_web/controllers/microsoft_auth_controller.ex`,
change the `index` function to the following:

```elixir
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
```

We are simply using the
[`put_session`](https://hexdocs.pm/plug/Plug.Conn.html#put_session/3)
function to persist the token within the connection session
to later be retrieved by the page
after successful login.
The person is redirected to the `/welcome` page
we've defined earlier if they manage to login.

And that's it!
If you refresh the `/welcome` page,
the token won't be lost! 🎉

## 7. Logging out

The person can log in.
We should let them *log out*.

The process of logging out is quite simple:

1. the person clicks on the `Sign Out` button.
2. they are redirected to Microsoft's website
to end their account's session.
3. after successfully logging out, 
the person is redirected to a `post-logout redirect URI`.

For this, 
we are going to define a **post-logout redirect URI**
as part of our app's config.
We can do this by setting the 
`MICROSOFT_POST_LOGOUT_REDIRECT_URI` env variable.

Let's set its value to 
`http://localhost:4000/auth/microsoft/logout`.
Add this to your `.env` file.

```
export MICROSOFT_POST_LOGOUT_REDIRECT_URI=http://localhost:4000/auth/microsoft/logout
```

In addition to this,
we are going to need to define this in 
the `App Registration` in Azure of our app.
If you navigate to the app's App Registration
and to the `Authentication` tab,
we add the `post-logout redirect URI` to the
`Redirect URIs` form.

<img width="1260" alt="add_azure" src="https://github.com/LuchoTurtle/banger-bot/assets/17494745/07f04dab-f48d-4c36-89dc-e8c70f4eaa02">

You'll need to run `source .env`
so the terminal has access to the newly set env variable.

### 7.1 Add the post-logout redirect URI to `router.ex`

We need to define our post-logout page in our application.
For this, open `lib/app_web/router.ex`
and add the following line to the scope.

```elixir
  scope "/", AppWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/welcome", PageController, :welcome
    get "/auth/microsoft/callback", MicrosoftAuthController, :index
    get "/auth/microsoft/logout", MicrosoftAuthController, :logout   # add this
  end
```

Let's add the `logout` function
to `lib/app_web/controllers/microsoft_auth_controller.ex`.
This will handle the behaviour once the person
is redirected from the `Microsoft` page
after logging out.

Open the file and add the following function:

```elixir
  def logout(conn, _params) do

    # Clears token from user session
    conn = conn |> delete_session(:token)

    conn
    |> redirect(to: "/")
  end
```

We are simply clearing the person's session
and redirecting them to the homepage
(so they can log in again, if they wish to).


### 7.2 Adding a button so the person logs out

All there's left to do is 
*adding the sign out button* so the person
can log out.

Inside `lib/app_web/templates/page/welcome.html.heex`,
add the button.

```html
  <a href={@logout_microsoft_url}>
    <button type="button" class="rounded-md bg-indigo-50 px-3.5 py-2.5 text-sm font-semibold text-indigo-600 shadow-sm hover:bg-indigo-100">Sign Out</button>
  </a>
```

We are using the `@logout_microsoft_url` connection assign.
We need to define this connection assign
inside `lib/app_web/controllers/page_controller.ex`.

```elixir
  def welcome(conn, _params) do
    case conn |> get_session(:token) do

      nil ->
        conn |> redirect(to: "/")

      token ->
        {:ok, profile} = ElixirAuthMicrosoft.get_user_profile(token.access_token)

        conn
        |> put_view(AppWeb.PageView)
        |> render(:welcome, %{profile: profile, logout_microsoft_url: ElixirAuthMicrosoft.generate_oauth_url_logout()})   # change here
    end
  end
```

We are using the `generate_oauth_url_logout` library function
to create the *logout URI* that the person is redirected into
after clicking the button.
We use this value to assign it to the `conn` object with key `logout_microsoft_url`.


### 7.3 And you're done!

Hurray! 🎉

We've just added log out capabilities to the app!
Now the person will be prompted with a `Sign Out` button.

<img width="1083" alt="sign_out" src="https://github.com/LuchoTurtle/banger-bot/assets/17494745/d8ece404-e943-4691-afed-40d922ede6a7">

Once they click the button,
they're redirected to the `Microsoft` page
to end the account's session on their identity server.

<img width="1083" alt="microsoft" src="https://github.com/LuchoTurtle/banger-bot/assets/17494745/dedcd5f0-7233-4381-ad26-14398922f611">

After they click the account they wish to sign out from,
depending on whether or not a
*post-logout redirect URI* was defined,
the person is redirected back to the homepage,
or shown the following screen if not.

<img width="1083" alt="not_defined_screen" src="https://github.com/LuchoTurtle/banger-bot/assets/17494745/0dd2c277-a08a-4770-8fa2-74549d56715c">


Awesome!
We've successfully logged out of our application
*and* from Microsoft's server 😃.