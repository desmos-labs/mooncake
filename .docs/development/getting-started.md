# Getting started

## Requirements
In order to work with the Mooncake codebase you will need to satisfy the following requirements.

### Flutter
The first requirement is to have [Flutter](https://flutter.dev) installed.
For the installation guide you can reference the [official website](https://flutter.dev/docs/get-started/install).

The Flutter version used during the development is `1.20.0`. You can get it by running:

```shell
$ flutter version 1.20.0
$ flutter upgrade
```

### Device
Since Mooncake is a mobile application, you will need to have a device on which to run it in order to see how it looks. 

Currently, there are two different ways of running Mooncake: 

1. On a **physical device**.   
   This requires you having either an iOS or Android mobile phone. 
  
2. An **emulator**.  
   No matter your current OS, you will be able to run Mooncake on Android emulator smoothly. However, if you wish to see how it looks on an iOS device, you will need to develop using a Mac.  


## Starting the development
In order to start developing using Mooncake, your first need to download the code on your machine. To do so, you need to have [Git]() installed. Once you have it, you can run the following command:

```
git clone git@github.com:desmos-labs/mooncake.git
``` 

This will create a new `mooncake` folder inside which the code will be downloaded. Now, go inside that directory and download the dependencies: 

```
cd mooncake
flutter pub get
```

Once you have done so, you are ready to start developing. 

## Running the application
To run a local version of Mooncake, you have two options: 

1. [Run in debug mode](#run-in-debug-mode)
2. [Run in release mode](#run-in-release-mode)

### Run in debug mode
To run the app in debug mode, simply open your emulator or connect a physical device and then execute:

```shell
flutter run
```

### Run in release mode
While in debug mode, Flutter never compiles the application fully. To make sure the changes you have made will run properly, you need to run the application in release mode.

Note that in order to use this particular running mode, you need to perform some additional setup steps. Please refer to the followings in order to know what to do: 

- [Android setup](https://flutter.dev/docs/deployment/android)
- [iOS setup](https://flutter.dev/docs/deployment/ios)

:::warning  
Please note that the release mode is available only on physical devices.  
:::

When you have your project properly setup, to run the app on release mode simply execute:

```
flutter run --release
```
