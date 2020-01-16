![Cover image](./.img/cover.png)

[![](https://img.shields.io/badge/100%25-flutter-blue)](https://flutter.dev)
[![](https://img.shields.io/badge/based%20on-desmos-orange)](https://desmos.network)

## Introduction
Mooncake, which name derives from the homonym [chinese bakery product](https://en.wikipedia.org/wiki/Mooncake), is a decentralized social application based on the [Desmos blockchain](https://github.com/desmos-labs/desmos).

It allows to post freely and anonymously any kind of message, and to see what all the users are writing without having to follow or be friend with anyone. 

Everyone reads everything, but none knows who is who. 

> Are you ready to enter a new world of social networks? 

If so, create your account by generating a mnemonic (or importing an existing one), ask some tokens using our [faucet](https://faucet.desmos.network/) and start posting! 

## Downloads
* Android: [Download the APK](./.build/mooncake-0.0.1.apk)

## Caveats
### Syncing
As of today, the syncing of posts and reactions is performed **once every 30 seconds**.  
This is due to avoid uploading or downloading new content too much quickly. 

For users, this means that everything you do **will stay on your device for 30 seconds**. After that time, it will be sent to the chain and will be public.  


#### Developers
If you want to try a faster sync time, you can change it from withing the `main.dart` file, setting the desired `syncPeriod` when creating the `PostsBloc` instance.  

## Development
### Requirements
- [Flutter](https://flutter.dev): to know how to install it, please refer to the [installation guide](https://flutter.dev/docs/get-started/install).
- An Android/iOS emulator or physical device. 

### Architecture
The whole code architecture follows the [Clean Architecture pattern](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html) mixed with the [BLoC pattern for the UI part](https://bloclibrary.dev/#/whybloc). 

The directories are separated using the Clean Architecture layers. From the inner to the outer one:

- `entities` contains the data structure definition;
- `usecases` contains the different use cases definition;
- `repositories` act as interface adapters; 
- `sources` and `ui` contain respectively the database/network interfaces and all the views definition.

To make the code more simple to maintain, we used the [dependency injection technique](https://en.wikipedia.org/wiki/Dependency_injection). The whole injection is handled using the [`dependencies` Pub package](https://pub.dev/packages/dependencies) and you can find the injector definition inside the `dependency_injection` folder. 

### Code generation
To properly handle JSON marshaling and unmarshaling, we used the [`json_serializable`](https://pub.dev/packages/json_serializable) and [`json_annotation`](https://pub.dev/packages/json_annotation) packages.
 
If you change the definition of classes marked with `@JsonSerializable()` remember to run the following command to toggle the code generation and update the generated `fromJson`/`toJson` methods as well:

```shell
flutter pub run build_runner build
``` 

### Formatting
When writing code we follow the [Flutter formatting guideline](https://flutter.dev/docs/development/tools/formatting). To ensure your files also follow the same formatting, please run the given commands once you edited or added new files:

```shell
flutter format. 
``` 

### Run the app
To run a local version of this application, you need to execute the following commands: 

```shell
flutter run
``` 

This will run it in either an Android or iOS emulator (or physical device). 