# StandupBot

Standupbot is a distributable landing page / online form that connects to Slack that allows team members to quickly submit a "virtual standup", such as what they have been working on what their current plans are, to be posted in a templated way to a specific Slack channel.

## Elm?

This project is written in [Elm](https://elm-lang.org/). It was simple enough that this project doubles as an Elm learning experiance for me, which is kinda fun. It is a simple enough project that React would be overkill, so the benifit of Elm is it effecivly removed all posssible runtime errors.

## Configuration

If you want to set this project up for your own team, first go ahead and clone the repo and then create a `.env` file at the root of the project. In this file, define the following 3 enviornment variables.

|     Variable     | Description                                                                                                                   |
| :--------------: | ----------------------------------------------------------------------------------------------------------------------------- |
|     TEMPLATE     | The relative path to the template.json file. If you do not want to customize this at all, set it equal to `res/template.json` |
|    SLACK_HOOK    | the url of the Slack webhook to call to on form submission                                                                    |
| GOOGLE_CLIENT_ID | the Google OAuth2 client id (just the part before the `.apps.googleusercontent.com`)                                          |

### Google Authenticaion

This project uses [Google OAuth2](https://developers.google.com/adwords/api/docs/guides/authentication) to capture the display name of the user submitting the standup. Follow the link above for more information, but the quick tl;dr on how to configure the Client ID is

1. to head on over to your [Google Cloud Console](https://console.cloud.google.com)
2. Go to `APIs & Services` > `Credentials`
3. Click `Create Credentials` > `OAuth client ID`
4. Set `Application Type` to `Web application`
5. Give it a name and add whatever domain you plan to host the site on under `authorized javascript origins`.
6. If you plan to test the site locally, add `localhost:5000` to the authorized domains (dev script in project is set up to use port 5000 by default)
7. Click `Create`
8. Under `OAuth2 Client IDs` you should see your new Credential

### Slack Webhooks

This project integrates with Slack to post messages when the user submits a standup (kinda the whole idea). If you are unfamililar with how to set up an incoming slack webhook, here's how to do it:

1. Navigate to [Slack's Api](https://api.slack.com) and click on `Your Apps`.
2. Click on `Create new App` > `From Scratch`
3. Give it a name (such as StandupBot) and select the workspace you would like to distribute it in (you must be have a certain level of permission to add the app to the workspace).
4. Click `Create App` then head over to the `Incoming Webhooks` section and scroll all the way down.
5. Click `Add New Webhook to Workspace` and select a channel. This is the channel that the bot will post in.
6. Copy the `webhook url` and you should be all set!

## Building

Run `npm run build` to bulid the project. Make sure to host all of the `build/` directory, as the nessecary javascript bundle will be included there as well as the `index.html`. This can be hosted on a platform such as [vercel](https://vercel.com). If you do, make sure to set the build command to `npm run build` and the output directory to `./build`.
