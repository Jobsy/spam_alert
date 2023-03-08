# Spam Alert
#### Spam Alert is a production-ready web endpoint that accepts a JSON payload as a POST request and sends an alert to a Slack channel if the payload matches desired criteria. This project was built with Ruby on Rails and deployed on Railway.


## Prerequisites
> . Ruby 3.0.3  
> . Rails 7.0.1  
> . Railway  


## Getting Started
### Installation
> 1. Clone the repository from Github:
>
> ```
>  git clone https://github.com/Jobsy/spam_alert.git
> ```
>

> 2. Navigate to the project directory:
>
> ```
>  cd spam_alert
> ```
>

> 3. Install the required gems:
>
> ```
>  bundle install
> ```
>

> 4. Run database migration:
>
> ```
>  rails db:migrate
> ```
>

> 5. Create .env file in the root directory of the project and add the following:
>
>    SLACK_WEBHOOK_URL=<YOUR_SLACK_WEBHOOK_URL>
>

> 6. Start the server:
>
> ```
>  rails server
> ```
>
>  The application will be available at: http://localhost:3000
>

## Usage
You can interact with the endpoint using Postman, either locally or publicly.
#### Local Interaction using Postman
> 1. Set the request URL to:
```
     http://0.0.0.0:3000/payloads
```
> 2. Set the request method to POST.
> 3. Set the request header Content-Type to application/json.
> 4. Copy one of the sample payloads from the README and paste it into the request body.
> 5. Send the request.
#### Public Interaction using Postman
> 1. Set the request URL to
```
     https://spamalert-production.up.railway.app/payloads
```
> 2. Set the request method to POST.
> 3. Set the request header Content-Type to application/json.
> 4. Copy one of the sample payloads from the README and paste it into the request body.
> 5. Send the request.

To send sample payloads using local or public url and make a POST request to the above endpoints:
If the payload is a spam notification, an alert will be sent to the configured Slack channel including the email address in the payload.
The payload should be sent in JSON format in the body of the request as show below.
##### A spam report that should result in an alert
```JSON
      {
        "RecordType": "Bounce",
        "Type": "SpamNotification",
        "TypeCode": 512,
        "Name": "Spam notification",
        "Tag": "",
        "MessageStream": "outbound",
        "Description": "The message was delivered, but was either blocked by the user, or classified as spam, bulk mail, or had rejected content.",
        "Email": "zaphod@example.com",
        "From": "notifications@honeybadger.io",
        "BouncedAt": "2023-02-27T21:41:30Z"
      }
```
##### A payload that should not result in an alert
```JSON
      {
        "RecordType": "Bounce",
        "MessageStream": "outbound",
        "Type": "HardBounce",
        "TypeCode": 1,
        "Name": "Hard bounce",
        "Tag": "Test",
        "Description": "The server was unable to deliver your message (ex: unknown user, mailbox not found).",
        "Email": "arthur@example.com",
        "From": "notifications@honeybadger.io",
        "BouncedAt": "2019-11-05T16:33:54.9070259Z"
      }
```

Create a .env file and set the following environment variables:
>
>SLACK_WEBHOOK_URL=<your Slack webhook URL>
>
Note: To get your Slack webhook URL, go to https://my.slack.com/services/new/incoming-webhook/ and follow the instructions there.

## Slack Integration
The application sends alerts to a Slack channel when a spam notification is detected. To integrate the application with your Slack channel, follow these steps:

Creating a Slack App and Webhook
> 1. Create a new Slack App: https://api.slack.com/apps
> 2. Set up a Slack bot and get an incoming webhook URL.
> 3. Create a new file named .env at the root of the project directory.
> 4. Add the webhook URL to the environment variables with the name SLACK_WEBHOOK_URL.  
 You can do this by creating a .env file at the root of the project directory and adding. 
 SLACK_WEBHOOK_URL=YOUR_SLACK_WEBHOOK_URL
> 5. Restart the application.

Adding spam_alert channel to your Slack App
> 1. Join the Slack channel using the invite link provided in the README.
> 2. When a spam notification is received, the email address included in the payload will be sent as a message to the Slack channel.
> 3. Nothing happens if otherwise


## Deployment

This application has been deployed to Railway. The application is publicly available at:
>
> https://spamalert-production.up.railway.app/
>

To send sample payloads using the provided examples, make a POST request to the following endpoint:
>
>https://spamalert-production.up.railway.app/payloads
>

The payload should be sent in JSON format in the body of the request.

### Interacting with the API
You can interact with the Spam Alert API using Postman or any other API client. To send sample payloads using the above example with Postman
#### Requirements
- The alert should only be sent to the Slack channel if the payload is a spam notification.
- The Slack alert should include the email address included in the payload.

## Credits
This project was built by Oluwajoba Bello and deployed on Railway.


