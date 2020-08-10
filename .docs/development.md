# Development
## Requirements
In order for you to locally run Mooncake, you will need to satisfy the following requirements:

1. Having [Flutter](https://flutter.dev) installed.
   For the installation guide please reference the [official website](https://flutter.dev/docs/get-started/install).
   The Flutter version used during the development is `1.20.0`. You can get it by running:
   ```shell
   $ flutter version 1.20.0
   $ flutter upgrade
   ```

2. An Android/iOS emulator or physical device.

## Architecture
The whole code architecture follows the [Clean Architecture pattern](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html) mixed with the [BLoC pattern for the UI part](https://bloclibrary.dev/#/whybloc).

The directories are separated using the Clean Architecture layers. From the inner to the outer one:

- `entities` contains the data structure definition;
- `usecases` contains the different use cases definition;
- `repositories` act as interface adapters;
- `sources` and `ui` contain respectively the database/network interfaces and all the views definition.

To make the code more simple to maintain, we used the [dependency injection technique](https://en.wikipedia.org/wiki/Dependency_injection). The whole injection is handled using the [`dependencies` Pub package](https://pub.dev/packages/dependencies) and you can find the injector definition inside the `dependency_injection` folder.

## Code generation
To properly handle JSON marshaling and unmarshaling, we used the [`json_serializable`](https://pub.dev/packages/json_serializable) and [`json_annotation`](https://pub.dev/packages/json_annotation) packages.

If you change the definition of classes marked with `@JsonSerializable()` remember to run the following command to toggle the code generation and update the generated `fromJson`/`toJson` methods as well:

```shell
flutter pub run build_runner build
```

## Parameters
### Syncing
If you want to try a faster sync time, you can change it from withing the `main.dart` file, setting the desired `syncPeriod` when creating the `PostsBloc` instance.

## Analytics
In order to constantly improve the application workings, we use [Firebase Analytics](https://firebase.google.com/docs/analytics) to track **completely anonymous** usage of the application by the users. This include tracking when they log in, add/remove a reaction, create a post etc.

In order to do so, we use the [Flutter Firebase Plugins](https://firebase.google.com/docs/flutter/setup).

## Formatting
When writing code we follow the [Flutter formatting guideline](https://flutter.dev/docs/development/tools/formatting). To ensure your files also follow the same formatting, please run the given commands once you edited or added new files:

```shell
flutter format .
```

## Testing
If you want to write tests, please refer the [Flutter testing guide](https://flutter.dev/docs/testing).

If you have developed a new feature, or you simply want to make sure that all tests pass, execute the following command:

```
flutter test --coverage test
```

## Run the app
To run a local version of this application, you have two options.

### Run in debug mode
To run the app in debug mode, simply open your emulator or connect a physical device and then execute:

```shell
flutter run
```


### Run in release mode
While in debug mode, the application is never fully compiled. To make sure the changes you have made will run properly, you need to run the application in release mode.

:::warning
Please note that the release mode is available only on physical devices.
:::

To run the app on release mode simply execute:

```
flutter run --release
```

#### Android setup
To run the app in release mode on an Android device, you will need to follow these steps:

1. Open up the `android/local.properties` file that you should have.

2. Inside the file, put the following lines:
   ```
   signing.storeFile=
   signing.storePassword=
   signing.keyPassword=
   signing.keyAlias=
   ```

3. Generate a new Keystore and associated key to sign Mooncake.
   You can read how to do it here: [Generate an upload key in Android Studio](https://developer.android.com/studio/publish/app-signing#generate-key).

4. Fill the `signing.storeFile`, `signing.storePassword`, `signing.keyPassword` and `signing.keyAlias` values with the ones of the Keystore file and key you just have generated.

If you are ready to run the app in release mode, here are the steps to follow:

1. Open
