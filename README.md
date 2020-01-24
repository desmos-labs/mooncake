![Cover image](../.img/cover.png)

[![](https://img.shields.io/badge/100%25-flutter-blue)](https://flutter.dev)
[![](https://img.shields.io/badge/based%20on-desmos-orange)](https://desmos.network)

## Introduction
Mooncake, which name derives from the homonym [chinese bakery product](https://en.wikipedia.org/wiki/Mooncake), is a decentralized social application based on the [Desmos blockchain](https://github.com/desmos-labs/desmos).

It allows to post freely and anonymously any kind of message, and to see what all the users are writing without having to follow or be friend with anyone. 

Everyone reads everything, but none knows who is who. 

> Are you ready to enter a new world of social networks? 

If so, create your account by generating a mnemonic (or importing an existing one), ask some tokens using our [faucet](https://faucet.desmos.network/) and start posting! 📜

## Downloads
You can get all the latest builds on the [release page](https://github.com/desmos-labs/mooncake/releases).

## Caveats
### Syncing
As of today, the syncing of posts and reactions is performed **once every 30 seconds**.  
This is due to avoid uploading or downloading new content too much quickly. 

For users, this means that everything you do **will stay on your device for 30 seconds**. After that time, it will be sent to the chain and will be public.  


#### Developers
If you want to try a faster sync time, you can change it from withing the `main.dart` file, setting the desired `syncPeriod` when creating the `PostsBloc` instance.