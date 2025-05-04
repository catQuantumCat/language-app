# language_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


## Build Runner
```
dart run build_runner build --delete-conflicting-outputs
```

## What I have learned

### Feb 18
- Understand 2 methods of modeling state using Bloc - [here](https://bloclibrary.dev/modeling-state/) - Choose enum method
- Apply inhertance to child's view, of `ChallengeView` to overriding certain methods
- Usage of `dynamic` type when building a answer checking method for `ChallengeData` abstract class
- Keyword: `covariant` to pioritize the child-method's property type over the parent's re-defined one
- Generic with `<T>` to clear type ambiguity when using the `checkAnswer` method - declared in `ChallengeData` abstract class and inherited by it's children
    -   Enable type safety and avoid runtime errors, by forcing a type when calling the method
    - Use generic caused a lot of trouble when debugging why the type of this `ChallengeData` child is being passed through another `ChallengeData` child's method
