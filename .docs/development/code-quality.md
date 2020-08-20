# Code quality 
Inside this page you can learn about the tools we use to ensure a proper code quality is met. 

## Formatting
When writing code we follow the [Flutter formatting guideline](https://flutter.dev/docs/development/tools/formatting). To ensure your files also follow the same formatting, please run the given commands once you edited or added new files:

```shell
flutter format .
```

## Analysis
In order to make sure each developer writes code that meets the best practices properly, we use [static analyses](https://en.wikipedia.org/wiki/Static_program_analysis). This is handled using the [pendatic](https://pub.dev/packages/pedantic) package. 

If you want to run the analysis by yourself you can use the following command: 

```
flutter analyze
```
