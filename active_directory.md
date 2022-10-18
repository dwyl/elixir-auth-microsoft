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

<img width="1436" alt="home" src="https://user-images.githubusercontent.com/17494745/196442972-acd0f101-6ee4-4a7e-8afd-3da316d2a378.png">


## 2. Go to Active Directory
Now go to `Active Directory` (you can either search or click on the icon if it's showing). 

You should see the following page. In the left pane, click on `App Registrations`.

<img width="1436" alt="ad" src="https://user-images.githubusercontent.com/17494745/196443021-239575d1-dab6-43bb-86d8-1b1becfc3c28.png">

Now click on `+ New registration` right below the title of the page. This should prompt you to the next step.

<img width="1436" alt="registration" src="https://user-images.githubusercontent.com/17494745/196443075-d6f8b390-2c2d-4f69-a8dc-3bc925c62e64.png">

## 3. Create your application
You're prompted with a simple form now, which you ought to complete. Name your application whatever you want. 
We decided to name this one `elixir-demo`. 


<img width="1436" alt="new_app" src="https://user-images.githubusercontent.com/17494745/196443153-825c756e-808b-490b-a150-db78de65d89c.png">


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


<img width="1436" alt="app_overview" src="https://user-images.githubusercontent.com/17494745/196443321-70886a54-c2ab-4577-8139-88ca323bd3ce.png">

# 4.1 - Changing `Authentication`
Let's start with `Authentication`. Click on the tab on the lefft-hand side panel and you're going to be greeted with the following prompts:

<img width="1436" alt="auth" src="https://user-images.githubusercontent.com/17494745/196443390-5ee8cad9-ec19-45e9-aeb0-015c60c23226.png">

We're going to click on the `Add URI` and add the callback path to our application. In our case, we will write `/auth/microsoft/callback` - this will be the URI that Microsoft will *redirect to* after successful sign in.

# 4.2 - Adding client secret
We're going to be using an [auth code flow paired with Proof Key for Code Exchange (PKCE) and OpenID Connect (OIDC)](https://learn.microsoft.com/en-us/azure/active-directory/develop/v2-oauth2-auth-code-flow) - this is the current and most secure standard to get an `access token` and `ID token`.

> If you don't know what we're talking about, check the link above. This is an OpenID Connect standard procedure. 

We are using a **client secret** here because we know this app will be hosted ***on a server*** and it's going to serve the files to the client, where environment variables are secured and not *exposable* (as is the case with web browsers). 

To create a new secret, simply click on the the `New client secret` button, add a descriptive label and expiration time. This will create a new secret. Copy this secret immediatly because if you leave and rejoin the page, it will be censored.

<img width="1436" alt="secret" src="https://user-images.githubusercontent.com/17494745/196443496-e366e5be-b94d-4590-80cc-9d4d7a4166c9.png">


# 5 - Congratulations! 🎉
That should be it! You're sorted, give yourself a pat on the back!
