<div align="center">

# Create an Azure Active Directory App for OAuth2 Authentication

</div>

This **step-by-step guide**
for creating an 
**Azure Active Directory App**
will get the credentials 
needed to setup 
**Microsoft OAuth2 Authentication**
in your **`Elixir`** / **`Phoenix`** App.

This guide follows the 
[Official Microsoft Identity Platform docs](https://learn.microsoft.com/en-us/azure/active-directory/develop/quickstart-register-app). 
We've added some details and screenshots to the steps 
to make it clear since navigating
around Azure Portal can be confusing sometimes.

This guide is checked periodically by the `@dwyl` team/community. 
Azure has changed their UI throughout time, 
so if anything has changed or you think some steps are missing, please 
[open an issue](https://github.com/dwyl/elixir-auth-microsoft/issues).

## 1. Open Azure Portal

Assuming you already have a Microsoft account, 
you are eligible to use Azure Portal. 
You can use your account to try Azure Portal *for free* for 12 months. 
Don't worry, you won't have to pay anything 
as long as you don't use _paid_ services 
after those 12 months elapse.

Microsoft has packages of paid services and free ones. 
The one we're using today - `Active Directory` - is 
[free forever services](https://azure.microsoft.com/en-us/pricing/free-services/).

> **Note**: In typical Microsoft fashion, 
> _nothing_ is simple/straighforward ... 
> "_Azure Active Directory comes in **four editions**: 
> Free, Office 365 apps, Premium P1, and Premium P2._"
> [azure.microsoft.com/en-us/pricing/details/active-directory](https://azure.microsoft.com/en-us/pricing/details/active-directory)
> The gist is this: if you have an Azure account, it's free.
> If you have Azuer "Premium" it's $6 user/month* ...
> Don't worry, you can have an **`Elixir`** App 
> that offeres **Microsoft OAuth**
> for ***free***. We checked. So you don't have to worry. 

After you sign up / sign in, 
you are greeted with the Azure Portal webpage. 
Should look like this:

<img width="1436" alt="home" src="https://user-images.githubusercontent.com/194400/196677896-80e08e9f-356d-499a-bb36-11f3d0bb2085.png">


## 2. Go to Azure Active Directory

Now go to `Azure Active Directory`:
https://portal.azure.com/?quickstart=true#view/Microsoft_AAD_IAM/ActiveDirectoryMenuBlade/~/Overview

> **Note**: this URL is likely to change 
> as Microsoft Azure Product Managers
> have a habit of continuously "revising" things that were working fine.
> So your best bet might be to just _search_ for:
> "Azure Active Directory"

f71705f-1ccf-4d0e-bda3-5fe4f6d48c3

You should see the following page. 
In the left pane, click on `App Registrations`.

![microsoft-azure-ad-2](https://user-images.githubusercontent.com/194400/196680575-907080b6-5955-4772-87c6-0ec93d4bc364.png)

Now click on `+ New registration`. 
This should prompt you to the next step.

## 3. Create your application

The "Register an application" form will be displayed.
 Name your application whatever you want. 
We called ours: 
`"elixir-auth-microsoft-demo"`.

![microsoft-azure-register-new-application-3](https://user-images.githubusercontent.com/194400/196683621-74ee9b89-8867-485f-bd79-e787d865a0c9.png)


On `Supporter account type`, 
choose the one that is most appropriate to your situation. 
However, if you're just trying out as a personal developer, choose the third one.

If you want to allow personal Hotmail/Outlook/XBox accounts,
chose one that includes
**personal Microsoft accounts** .

For the `Redirect URI` 
add `http://localhost:4000` 
(the URI of your Phoenix application).
You can edit this setting later on, so don't worry.

Click the **`Register`** button 
and you will see your newly created app:

![azure-ad-app-3](https://user-images.githubusercontent.com/194400/196684414-17f938de-5c31-47e8-9771-255a7ef72e3e.png)


# 4. Changing Settings

After registration, 
you should see several settings that you can tweak. 
The most relevant ones are
`Authentication` and `Certificates & Secrets`.


<img width="1436" alt="app_overview" src="https://user-images.githubusercontent.com/17494745/196443321-70886a54-c2ab-4577-8139-88ca323bd3ce.png">

# 4.1 - Changing `Authentication` URI

Let's start with `Authentication`. 
Click on the tab on the lefft-hand 
side panel:

![azure-ad-4-authentication](https://user-images.githubusercontent.com/194400/196687287-c6baab8a-8387-4f0c-aafa-5e3d7c0619f7.png)

We're going to click on the `Add URI` 
and add the callback path to our application. 
In our case: `/auth/microsoft/callback` 
This is the URI that Microsoft 
will *redirect to* after successful authentication.

e.g: 

![azure-ad-4-url-added](https://user-images.githubusercontent.com/194400/196687967-6437028e-dd12-4421-acc7-90a499658b57.png)

Click "**Save**" to save your changes. 

# 4.2 - Adding Client Secret

We're using an 
auth code flow paired with Proof Key 
for Code Exchange (PKCE) and OpenID Connect (OIDC)
https://learn.microsoft.com/en-us/azure/active-directory/develop/v2-oauth2-auth-code-flow

> That's a mouthfull of buzzwords, 
> but don't worry, 
> you don't need to understand any of it
> to get Auth working for your app.
> Just know that it's the current and most secure standard 
> to get an `access token` and `ID token`.


We are using a **client secret** 
because we know this app will be hosted ***on a server*** 
and it's going to serve the files to the client, 
where environment variables are secured 
and not *exposable* (as is the case with web browsers). 

To create a new secret, 
click on the the `New client secret` button:

![azure-ad-new-client-secret](https://user-images.githubusercontent.com/194400/196692420-124d69af-f809-4b92-960e-80f137b361f8.png)

Add a descriptive label and expiration time:

![azure-ad-client-secret-name-and-expiration](https://user-images.githubusercontent.com/194400/196692905-8e74ebce-7485-4f5f-87e4-1547f4d1d0d1.png)

This will create a new secret. 

Copy this secret immediatly because 
if you leave and rejoin the page, 
it will be censored (lost forever!).

![azure-ad-copy-client-secret](https://user-images.githubusercontent.com/194400/196693504-56a3cd9c-fa22-4170-acba-f1877c7ff5fd.png)

Save the values to an `.env` file.
e.g:
```sh
export MICROSOFT_CLIENT_SECRET=rDq8Q~.uc-237FryAt-lGu7G1sQkKR
export MICROSOFT_CLIENT_ID=85228de4-cf4f-4249-ae05-247365
```

> **Note**: Don't worry, these aren't valid/real. 
> They are just for illustration.


# 5 - Congratulations! 🎉


