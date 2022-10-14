# Creating an Azure Active Directory Application for OAuth2 Authentication

This is a small step-by-step guide for creating an Azure Active Directory app registration
so that you can get all the credentials needed to setup Microsoft OAuth2 Authentication to your Elixir App.

This guide follows the [official documentation from Microsoft](https://learn.microsoft.com/en-us/azure/active-directory/develop/quickstart-register-app). We've added some details and screenshots to the steps to make it clear since navigating
around Azure Portal can be confusing sometimes.

This guide is checked periodically by the `@dwyl` team/community. Azure has changed their UI throughout time, 
so if anything has changed or you think some steps are missing, please [do let us know](https://github.com/dwyl/elixir-auth-microsoft/issues).

## 1. Open Azure Portal
Assuming you have a Microsoft account, you are eligible to use Azure Portal. You can use your account to try Azure Portal *for free* for 12 months. Don't worry, you won't have to pay anything as long as you don't use paid services after those 12 months expired. 

Microsoft has packages of paid services and free ones. The one we're using today - `Active Directory` - is [free](https://azure.microsoft.com/en-us/pricing/free-services/).

So after you sign up and sign in, you are greeted with the Azure Portal webpage. Should look like this:

<img width="3120" alt="Screenshot 2022-10-14 at 13 38 26" src="https://user-images.githubusercontent.com/17494745/195852314-66b08e4a-1636-4344-bf50-db3169ba1f0c.png">



## 2. Go to Active Directory
Now go to `Active Directory` (you can either search or click on the icon if it's showing). 

You should see the following page. In the left pane, click on `App Registrations`.

<img width="3120" alt="Screenshot 2022-10-14 at 13 40 26" src="https://user-images.githubusercontent.com/17494745/195852340-20fc1fd3-f3df-40a5-b6f5-3678793f885f.png">


Now click on `+ New registration` right below the title of the page. This should prompt you to the next step.

<img width="3076" alt="Screenshot 2022-10-14 at 13 43 03" src="https://user-images.githubusercontent.com/17494745/195852367-012fa411-a070-4fda-96ee-83f617331287.png">

## 3. Create your application
You're prompted with a simple form now, which you ought to complete. Name your application whatever you want. 
We decided to name this one `elixir-demo`. 

<img width="1840" alt="Screenshot 2022-10-14 at 13 47 05" src="https://user-images.githubusercontent.com/17494745/195852413-2cd05964-a269-444e-9cda-5ef3836582cd.png">

On `Supporter account type`, make sure you check the one that allows **personal Microsoft accounts** if you're 
a solo developer with a regular Hotmail account. The differences between these options are in the picture above,
so choose the one that is most appropriate to your situation. 
However, if you're just trying out as a personal developer, choose the third one.

On the `Redirect URI` section, add `http://localhost:4000` (the URI of your Phoenix application).
We have the chance to edit this setting later on, so don't worry.


# 4. Changing settings
After registration, you are prompted with your newly created app registration. 
You should see several settings that you can tweak. The most relevant ones are
`Authentication` and `Certificates & Secrets`.

<img width="1840" alt="Screenshot 2022-10-14 at 13 51 24" src="https://user-images.githubusercontent.com/17494745/195852458-6d022105-75df-474d-b92c-c2d79c77a07f.png">

# 4.1 - Changing `Authentication`
Let's start with `Authentication`. Click on the tab on the lefft-hand side panel and you're going to be greeted with the following prompts:

<img width="1873" alt="Screenshot 2022-10-14 at 19 48 41" src="https://user-images.githubusercontent.com/17494745/195919719-96c8484c-94c3-4a5e-b06d-5615443bcb41.png">

We're going to click on the `Add URI` and add the callback path to our application. In our case, we will write `/auth/microsoft/callback` - this will be the URI that Microsoft will *redirect to* after successful sign in.

# 4.2 - Adding client secret
We're going to be using an [auth code flow paired with Proof Key for Code Exchange (PKCE) and OpenID Connect (OIDC)](https://learn.microsoft.com/en-us/azure/active-directory/develop/v2-oauth2-auth-code-flow) - this is the current and most secure standard to get an `access token` and `ID token`.

> If you don't know what we're talking about, check the link above. This is an OpenID Connect standard procedure. 

We are using a **client secret** here because we know this app will be hosted ***on a server*** and it's going to serve the files to the client, where environment variables are secured and not *exposable* (as is the case with web browsers). 

To create a new secret, simply click on the the `New client secret` button, add a descriptive label and expiration time. This will create a new secret. Copy this secret immediatly because if you leave and rejoin the page, it will be censored.

# 5 - Congratulations! 🎉
That should be it! You're sorted, give yourself a pat on the back!

// TO BE CONTINUED
