# Podio sample Rails application

This app demonstrates how to authenticate against Podio, and how to read and write items.

## Preparations on Podio

Create an API key by logging into Podio and go to Account Settings in the My Account dropdown. Then go to the API Keys tab and write a name and a domain for this app. While you are developing, you probably want to set the domain to `localhost:3000 or similar.

To be able to run this sample you must also have the Leads app installed on Podio. It can be installed [from the App Store](https://podio.com/store/app/11236-leads). You can also use another app, but then this example won't work "out of the box".

## Installation

Clone this repository:

    git clone https://github.com/podio/podio_rails_sample.git

Install gem dependencies:

    bundle install

Setup the database:

    rake db:migrate

## Configuration

You must put your API key and secret in the environment variables PODIO_CLIENT_ID and PODIO_CLIENT_SECRET. Alternatively you can hardcode them in config/initializers/podio.rb.

You must also update the hardcoded APP_ID and SPACE_ID constants in app/models/lead.rb to the corresponding ids for your instance of the Leads app. You find the app id by going to your installed Leads app on Podio, click the wrench icon and select "Developers". One way to get the space id is to go to the [API reference page for the Get app operation](https://developers.podio.com/doc/applications/get-app-22349), scroll to the bottom, login to the sandbox, paste in the app id, submit the form and find the "space_id" in the result.

## Running

To start the web server locally, run:

    rails server

Then go to [localhost:3000](http://localhost:3000) to login and use the app.

## App authentication

When you run this app, you will notice that you get the opportunity to paste in an app id and an app token on the login page. This demonstrates how you can authenticate as an app, rather than as a user. You get the app id and token from the app's "Developer" page. The different ways of authenticating are explained here: https://developers.podio.com/authentication.

## Tips

You probably want to work with Podio apps that has a completely different structure than the Leads app used in this example. The easiest way to the see the structure and the all-important external ids of you app is to go to the aforementioned "Developers" page for your app.You can also go to https://developers.podio.com/doc/applications/get-app-22349 and enter the app id with "full" as type in the in the sandbox.

Further, you can see exactly what fields and values you get from a Get Items call by using the sandbox here: https://developers.podio.com/doc/items/get-items-27803

The authentication in this app is based on Omniauth and a strategy for using Omnioauth with Podio - https://github.com/lucasallan/omniauth-podio. On top of that it pretty much follows the steps outlined in the RailsCast about simple Omniauth usage - http://railscasts.com/episodes/241-simple-omniauth?view=asciicast.
