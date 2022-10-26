## LaterGram
Is a mobile app with one view showing the list of the most recent photos and albums posted on Instagram with the following guidelines:

## Setup
- Clone the Repo
- The project has been build with Xcode Version 14.0.1

Rename `sampleConfig.json` to `config.json` and update the access_token with a valid token

## Architecture
- MVVM (Model View ViewModel) + Composition layer

## How to run the application
- Open `LaterGram.xcodeproj`
- use the key combination `ctrl + R` to run the application

## Screenshots
![Dark Mode](Assets/iPhone%2014%20Pro-dark.png)
![Light Mode](Assets/iPhone%2014%20Pro-light.png)

## Tests
- Open `LaterGram.xcodeproj`
- use the key combination `ctrl + U` to run the unit tests

## Improvements
- Caching layer to eliminate fetching images every time

## ChangeLog
 - [CHORE: Documentation + CleanUp](https://github.com/DevAgani/LaterGram/pull/3)
 - [Feature: Presentation Layer](https://github.com/DevAgani/LaterGram/pull/2)
 - [Feature: Image Feed Loader](https://github.com/DevAgani/LaterGram/pull/1)

## Challenges
- I experienced issues with the `access_token` that were provided whenever i'd make requests to the Basic Instagram Graph API as below 

```bash
curl --request GET \
  --url 'https://graph.instagram.com/v15.0/me?access_token={access_token}'
```
- I decided to mock the response just to showcase the how everying was to eventually fally into place.