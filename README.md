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
### Normal states
<img src="Assets/iPhone%2014%20Pro-light.png" width="150">
<img src="Assets/iPhone%2014%20Pro-dark.png" width="150">
<br/><br/>

### Error states
<img src="Assets/iPhone%2014%20Pro-error-light.png" width="150">
<img src="Assets/iPhone%2014%20Pro-error-dark.png" width="150">

## Tests
- Open `LaterGram.xcodeproj`
- use the key combination `ctrl + U` to run the unit tests

### Coverage
<img src="Assets/TestCoverage.png" width="100%">

## Improvements
- Caching layer to eliminate fetching images every time
- Use a UICollectionView to allow for listing images and scrolling within an album

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