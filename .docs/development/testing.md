# Testing
While developing Mooncake we strive to have the best test coverage possible. For this reason, we use three different test types in order to make sure the different types of tests: 

- [Unit tests](https://flutter.dev/docs/testing#unit-tests) to test the `entities`, `usecases`, `repositories` and `sources` [layers](architecture.md). 

- [Widget tests](https://flutter.dev/docs/testing#widget-tests) to make sure the widgets defined inside the `ui` [layer](architecture.md) are visualized properly. 

- [Integration tests](https://flutter.dev/docs/testing#integration-tests) to make sure widgets work together properly. 

If you have developed a new feature, or you simply want to make sure all tests pass, execute the following command:

```
flutter test --coverage test
```
