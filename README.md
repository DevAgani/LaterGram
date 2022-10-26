## LaterGram

## Setup
Rename `sampleConfig.json` to `config.json` and update the access_token with a valid token

## Architecture

## How to run the application

## Tests

## Improvements


## ChangeLog
 - [Feature: Presentation Layer](https://github.com/DevAgani/LaterGram/pull/2)
 - [Feature: Image Feed Loader](https://github.com/DevAgani/LaterGram/pull/1)

## Challenges
- I experienced issues with the `access_token` that were provided whenever i'd make requests to the Basic Instagram Graph API as below 

```bash
curl --request GET \
  --url 'https://graph.instagram.com/v15.0/me?access_token={access_token}'
```