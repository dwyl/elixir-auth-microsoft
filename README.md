<div align="center">

# `elixir-auth-microsoft`

An easy way to get Microsoft OAuth authentication up and running in your Elixir application.

</div>


# _Why_? 🤷

Following [`Google`](https://github.com/dwyl/elixir-auth-google)
and [`Github`](https://github.com/dwyl/elixir-auth-github), it
made sense for us to have a simple and **documented** way to add 
a "Sign-in with Microsoft" capability to add to our Elixir apps.

# _What_? 💭

An Elixir package that seamlessly handles
Microsoft OAuth2 Authentication/Authorization
in as few steps as possible. <br />
Following best practices for security & privacy
and avoiding complexity
by having sensible defaults for all settings.


> We built a lightweight solution
that only does _one_ thing
and is easy for complete beginners to understand/use. <br />
There were already a few available options
for adding Microsoft Auth to apps on
[hex.pm/packages?search=microsoft](https://hex.pm/packages?search=microsoft).<br />
Most of these are not specific to Azure AD or build upon other auth packages
that have much more implementation steps and complexity.</br>
e.g:
[github.com/googleapis/ueberauth_microsoft](https://github.com/swelham/ueberauth_microsoft)
which builds upon the Ueberauth auth platform. <br />
We focused on making a _simple_ package that 
has both step-by-step instructions
and a _complete working example_ App.


# _Who_? 👥

This module is for people building apps using Elixir/Phoenix
who want to ship the "Sign-in with Microsoft" feature _faster_
and more maintainably.

It's targetted at _complete_ beginners
with no prior experience/knowledge
of auth "schemes" or "strategies". <br />
Just follow the detailed instructions
and you'll be up-and running in a few minutes minutes.


# _How_? ✅

You can add Microsoft Authentication to your Elixir App
using **`elixir_auth_microsoft`** <br />
in under **5 minutes** the following steps.

## 1. Add the hex package to `deps` 📦

Open your project's **`mix.exs`** file
and locate the **`deps`** (dependencies) section.
Add a line for **`:elixir_auth_microsoft`** in the **`deps`** list:

```elixir
def deps do
  [
    {:elixir_auth_microsoft, "~> 0.1.0"}
  ]
end
```

Once you have added the line to your **`mix.exs`**,
remember to run the **`mix deps.get`** command
in your terminal
to _download_ the dependencies.


## 2. Create an App Registration in Azure Active Directory 🆕

You ought to create an App Registration in Azure Active Directory 
if you already don't have one. You need this to generate
OAuth2 credentials for the appication. 

These credentials will be saved as environment variables
and accessed by your app. You can optionally put them 
in your config file, if it's more convenient.

> **Note**: There are a handful of steps for creating your
Azure App Registration and respective credentials. We have 
created the following [guide](https://github.com/dwyl/elixir-auth-google/blob/master/create-google-app-guide.md) to make it quick and painless.<br />
Don't be intimidated by all the buzz-words;
it's quite straightforward.
And if you get stuck, ask for
[help!](https://github.com/dwyl/elixir-auth-microsoft/issues)


## 3. Setup CLIENT_ID and CLIENT_SECRET in your project

You may either add those keys as environment variables or put them in the config:

```
export MICROSOFT_CLIENT_SECRET=paX8Q~_SRO9~UScMi4GTyw.oC8U_De.MiqDX~dBO
export MICROSOFT_CLIENT_ID=a00c63f7-6da6-43bd-a94f-74d36486264a
export MICROSOFT_SCOPES_LIST=openid profile 
```
> These keys aren't valid, just for illustration purposes.

Or add the following in the config file:

```elixir
config :elixir_auth_microsoft,
  client_id: "00c63f7-6da6-43bd-a94f-74d36486264a",
  client_secret: "paX8Q~_SRO9~UScMi4GTyw.oC8U_De.MiqDX~dBO"
  scopes: openid profile

```

The `scopes` and `MICROSOFT_SCOPES_LIST` are **optional**, and they default 
to the user profile. For the scopes available, follow [this link](https://learn.microsoft.com/en-us/azure/active-directory/develop/v2-permissions-and-consent).
Do remember that the scopes you request are only given permission
dependending on what you set in the App Registration in Azure Active Directory.
Find more information in the [guide to setup your app registration](./active_directory.md).


## 4. Follow the demo guide 📝
We've created a guide that takes you step-by-step to get 
a boostrapped Phoenix generated application with 
Microsoft authentication in just a few steps. 

Please, do check the guide [here](/demo/README.md).

# _Done_! 🚀

The home page of the app now should have a big "Sign in with Microsoft" button:

![sign-in-button](https://user-images.githubusercontent.com/194400/70202961-3c32c880-1713-11ea-9737-9121030ace06.png)

When the person clicks the button, they should be prompted
with the Microsoft Sign-in page.

<img width="1298" alt="Screenshot 2022-10-18 at 12 37 44" src="https://user-images.githubusercontent.com/17494745/196425192-4ca634ba-1573-4b14-9c9b-aee890043d34.png">


The person will then have to consent to the defined scopes
in the App Registration alongside the overlap of the scope(s)
requested.

After this, they will be shown the following page
after successful login.
<img width="1222" alt="welcome" src="https://user-images.githubusercontent.com/17494745/196406469-7278d190-63b0-4740-ac10-5a6305c3cb6a.png">



## Optimised SVG + CSS Button

If you have taken a gander around our [demo](./demo/), you 
might have realised we are using an `<img>` for the 
`Sign in with Microsoft` button. 

However, we could go for an alternative and have a `svg` 
file, making it more lightweight and allowing us to even
change languages if we wanted to!

Luckily, Microsoft has made all the heavylifting for us. 
If we follow this [link](https://learn.microsoft.com/en-us/azure/active-directory/develop/howto-add-branding-in-azure-ad-apps#pictogram-and-sign-in-with-microsoft),
we'll find a few options and themes on SVG format.

The result looks _better_ than the `<img>` button. 
Here's a comparison between the two:

<img width="999" alt="Screenshot 2022-10-18 at 13 00 19" src="https://user-images.githubusercontent.com/17494745/196425270-94100e5f-24f6-4759-8ff3-7ac8648c47bd.png">



## Notes 📝


+ Azure AD official docs:
https://learn.microsoft.com/en-us/azure/active-directory/
+ Azure Authentication Flow used:
https://learn.microsoft.com/en-us/azure/active-directory/develop/v2-oauth2-auth-code-flow#use-the-access-token
+ Microsoft Auth branding guidelines:
https://learn.microsoft.com/en-us/azure/active-directory/develop/howto-add-branding-in-azure-ad-apps
