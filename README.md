![Cover image](.img/cover.png)

[![](https://img.shields.io/badge/100%25-flutter-blue)](https://flutter.dev)
[![](https://img.shields.io/badge/based%20on-desmos-orange)](https://desmos.network)
[![CircleCI](https://img.shields.io/circleci/build/github/desmos-labs/mooncake)](https://app.circleci.com/github/desmos-labs/mooncake/pipelines)
[![Codecov](https://img.shields.io/codecov/c/github/desmos-labs/mooncake)](https://codecov.io/gh/desmos-labs/mooncake)
[![](https://img.shields.io/badge/compatible-Android-green)](https://desmos.network)
[![](https://img.shields.io/badge/compatible-iOS-lightgray)](https://desmos.network)

## Introduction
Mooncake, which name derives from the homonym [chinese bakery product](https://en.wikipedia.org/wiki/Mooncake), is a decentralized social application based on the [Desmos blockchain](https://github.com/desmos-labs/desmos).

It allows to post freely and anonymously any kind of message, and to see what all the users are writing without having to follow or be friend with anyone. 

Everyone reads everything, but none knows who is who. 

> Are you ready to enter a new world of social networks? 

## Download
Downloads and documentation can both be found on the [official website](https://mooncake.space)

<a target="_blank" href='https://play.google.com/apps/testing/com.forbole.mooncake'><img alt='Get it on Google Play' src='https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png' width="100"/></a> <a target="_blank" href='https://testflight.apple.com/join/3Zh9mWFk'><img alt='Get it on Google Play' src='https://pluspng.com/img-png/download-on-app-store-png-with-without-wifi-or-data-2000.png' width="100"/></a>

## Screens
<img src="./.img/screen_login.png" alt="Login screen" width="200"> <img src="./.img/screen_list.png" alt="List screen" width="200"> <img src="./.img/screen_detail.png" alt="Detail screen" width="200">

## Development
You can read more about the development on the [official website](https://mooncake.space/development).

## Caveats
### Syncing
As of today, the syncing of posts and reactions is performed **once every 30 seconds**.  
This is due to avoid uploading or downloading new content too much quickly. 

For users, this means that everything you do **will stay on your device for 30 seconds**. After that time, it will be sent to the chain and will be public.  

## Disclaimer
Some of the code inside this repo has been taken and adapted from the awesome [Flutter Twitter clone project](https://github.com/TheAlphamerc/flutter_twitter_clone).
