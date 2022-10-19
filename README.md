<div align="center">

# `elixir-auth-microsoft`

An easy way to get **Microsoft `OAuth` authentication** 
up and running in your **`Elixir` / `Phoenix`** app.

![GitHub Workflow Status](https://img.shields.io/github/workflow/status/dwyl/elixir-auth-microsoft/Elixir%20CI?label=build&style=flat-square)
[![codecov.io](https://img.shields.io/codecov/c/github/dwyl/elixir-auth-microsoft/master.svg?style=flat-square)](http://codecov.io/github/dwyl/elixir-auth-microsoft?branch=main)
[![Hex.pm](https://img.shields.io/hexpm/v/elixir-auth-microsoft?color=brightgreen&style=flat-square)](https://hex.pm/packages/elixir-auth-microsoft)
[![HitCount](http://hits.dwyl.com/dwyl/elixir-auth-microsoft.svg)](http://hits.dwyl.com/dwyl/elixir-auth-microsoft)
[![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat-square)](https://github.com/dwyl/elixir-auth-microsoft/issues)

![sign-in-with-microsoft-buttons](https://user-images.githubusercontent.com/194400/196658191-31c7594e-f041-4e63-b49e-3289e8c31b10.png)


</div>


# _Why_? 🤷

Following 
[`Google`](https://github.com/dwyl/elixir-auth-google)
and 
[`Github`](https://github.com/dwyl/elixir-auth-github)
it
made sense for us to have a simple and **documented** way 
to add "**Sign-in with _Microsoft_**" capability 
to add to our Elixir apps.

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

<img width="1306" alt="first_page" src="https://user-images.githubusercontent.com/17494745/196440727-583b804a-6716-4aed-a0aa-fd894d78d7f6.png">


When the person clicks the button, they should be prompted
with the Microsoft Sign-in page.

<img width="1306" alt="consent_form" src="https://user-images.githubusercontent.com/17494745/196440842-82aa95ba-ccc0-4d04-81a2-5f71819795c7.png">


The person will then have to consent to the defined scopes
in the App Registration alongside the overlap of the scope(s)
requested.

After this, they will be shown the following page
after successful login.

<img width="1306" alt="successful_login" src="https://user-images.githubusercontent.com/17494745/196441038-5cdfecbb-626e-42e0-be94-65fb9725dc19.png">

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


<img width="1306" alt="two_buttons" src="https://user-images.githubusercontent.com/17494745/196441338-8c46d7d0-8fbc-4515-9f0a-591faaa63c47.png">


## Notes 📝


+ Azure AD official docs:
https://learn.microsoft.com/en-us/azure/active-directory/
+ Azure Authentication Flow used:
https://learn.microsoft.com/en-us/azure/active-directory/develop/v2-oauth2-auth-code-flow#use-the-access-token

## Branding Guidelines

The official Microsoft Auth branding guidelines specify exact button, font and spacing:
https://learn.microsoft.com/en-us/azure/active-directory/develop/howto-add-branding-in-azure-ad-apps

![sign-in-with-microsoft-redlines](https://user-images.githubusercontent.com/194400/196657843-0a92e351-4c1f-4100-b13e-ae0b9afee260.png)

We have followed them precisely in our implementation. 