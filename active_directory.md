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

// ADD HERE 1

## 2. Go to Active Directory
Now go to `Active Directory` (you can either search or click on the icon if it's showing). 

You should see the following page. In the left pane, click on `App Registrations`.

// ADD HERE 2

Now click on `+ New registration` right below the title of the page. This should prompt you to the next step.

// ADD HERE 3

## 3. Create your application
You're prompted with a simple form now, which you ought to complete. Name your application whatever you want. 
We decided to name this one `elixir-demo`. 

// ADD HERE 4

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

// ADD HERE 4


// TO BE CONTINUED
