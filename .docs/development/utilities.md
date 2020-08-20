# Third party libraries
While developing Mooncake, we use different libraries in order to facilitate our work and speed up the whole process. Inside this page we explore how they are setup and when you should use them as well. 

## JSON
To properly handle JSON marshaling and unmarshaling, we used the [`json_serializable`](https://pub.dev/packages/json_serializable) and [`json_annotation`](https://pub.dev/packages/json_annotation) packages.

If you change the definition of classes marked with `@JsonSerializable()` remember to run the following command to toggle the code generation and update the generated `fromJson`/`toJson` methods as well:

```shell
flutter pub run build_runner build
```

## Analytics
In order to constantly improve the application workings, we use [Firebase Analytics](https://firebase.google.com/docs/analytics) to track **completely anonymous** usage of the application by the users. This include tracking when they log in, add/remove a reaction, create a post etc.

In order to do so, we use the [Flutter Firebase Plugins](https://firebase.google.com/docs/flutter/setup).

