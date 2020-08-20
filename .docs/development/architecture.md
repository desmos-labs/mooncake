# Code architecture
The whole code architecture follows the [Clean Architecture pattern](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html) mixed with the [BLoC pattern for the UI part](https://bloclibrary.dev/#/whybloc).

The directories are separated using the Clean Architecture layers. From the inner to the outer one:

- `entities` contains the data structure definition;
- `usecases` contains the different use cases definition;
- `repositories` act as interface adapters;
- `sources` and `ui` contain respectively the database/network interfaces and all the views definition.

To make the code more simple to maintain, we used the [dependency injection technique](https://en.wikipedia.org/wiki/Dependency_injection). The whole injection is handled using the [`dependencies` Pub package](https://pub.dev/packages/dependencies) and you can find the injector definition inside the `dependency_injection` folder.


