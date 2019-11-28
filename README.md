# Dwitter
[![](https://img.shields.io/badge/100%25-flutter-blue)](https://flutter.dev)
[![](https://img.shields.io/badge/based%20on-desmos-red)](https://desmos.network)

Dwitter is a decentralized version of [Twitter](https://twitter.com) (with less functions), entirely based on the 
[Desmos blockchain](https://github.com/desmos-labs/desmos).

It allows to post freely any kind of message, and see what all the users are writing, no follow needed. 
Everyone knows everything.

## Current state
Currently there is **no interaction** with the blockchain but **all the posts and comments are stored locally**.

## Development
### Requirements
- [Flutter](https://flutter.dev): to know how to install it, please refer to the [installation guide](https://flutter.dev/docs/get-started/install).
- An Android/iOS emulator or physical device. 

### Run the app
To run a local version of this application, you need to execute the following commands: 

```shell
flutter pub run build_runner build
flutter run
``` 

This will run it in either an Android or iOS emulator (or physical device). 