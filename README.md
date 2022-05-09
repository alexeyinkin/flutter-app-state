A bloc-based state management solution on top of Router API for larger apps.

## Features ##

### Flexible page stack ###

Some navigation packages require pre-defined stacks: for route `C`, the ancestors are always
`B` and `A`. With this package, it is not the case. Any screen can open any other screen.
This is how book list might open a book details page:

```dart
pageStacksBloc.push(
  BookDetailsPage(bookId: id),
);
```

### Declarative default stacks ###

For each URL, you can define the default stack of pages that show when this URL is navigated.
For book details, you may declare that the parent page should be the book list:

```dart
@override
PageStackConfiguration get defaultStackConfiguration {
  return PageStackConfiguration(
    pageConfigurations: [
      const BookListPageConfiguration(),
      this,
    ],
  );
}
```

### Separation of concerns ###

Each screen uses up to 4 artifacts:

- The screen widget.
- Bloc for logic and navigation (optional).
- `PageConfiguration`, a representation of URL (optional, use if you want URLs).
- `Page`, a simple adapter to be stored in the stack of `Navigator`.

This provides a clear file structure:
```
lib
|--pages
|  |-- one
|  |   |-- bloc.dart
|  |   |-- configurations.dart
|  |   |-- screen.dart
|  |   `-- page.dart
|  `-- two
|      |-- bloc.dart
|      |-- configurations.dart
|      |-- screen.dart
|      `-- page.dart
...
```

### Blocs handle navigation ###

You normally back your screens with blocs to maintain the screen state (checkboxes,
counters, etc.). This package provides base classes for such blocs that also handle
navigation.

Imagine a traditional counter app but with the counter value in URL.
This is how a page bloc can update the URL:

```dart
void onIncrementPressed() {
  _counter++;
  emitState();            // Bloc state that the screen listens to.
  emitConfiguration();    // Updates the URL with what getConfiguration() returns.
}

@override
PageConfiguration getConfiguration() {
  return CounterPageConfiguration(counter: _counter);
}
```

This is how state is applied to bloc when 'back' or 'forward' is pressed in the browser:

```dart
@override
void setStateMap(Map<String, dynamic> state) {
  _counter = state['counter'];
  emitState();
  emitConfiguration();
}
```

By default, Android back button closes the screen. A page bloc may override this to decrement
the counter and only close when reached zero:

```dart
@override
Future<bool> onBackPressed() {
  if (_counter > 0) {
    _counter--;
    emitState();
    emitConfiguration();
    return Future.value(BackPressedResult.keep); // Prevents closing.
  }
  return Future.value(BackPressedResult.close);  // The default if you did not override the method.
}
```

If we had a dialog to manually enter the counter value, this is how we updated the bloc
when its popped:

```dart
@override
void onForegroundClosed(PageBlocCloseEvent event) {
  if (event is CounterEditedEvent) {
    _counter = event.counter;
    emitState();
    emitConfiguration();
  }
}
```

We do not await dialog futures. This also means that one screen can return result
to the one under it even if the whole stack was destroyed and re-created from URL.

### Multiple page stacks ###

If you have bottom navigation buttons and want an independent page stack for each button,
this works out of the box.

When the app is opened at a URL, it is converted to a `PageConfiguration` that knows
which tab should be active:

```dart
@override
String get defaultStackKey => TabEnum.books.name; // Your custom enum for tabs.
```

Each screen can be pushed to any stack:

```dart
pageStacksBloc.currentStackBloc?.push(
  BookDetailsPage(bookId: id),
);
```

This allows Instagram-like navigation, where a user profile may open in explore tab,
likes tab, or any other.

## Usage ##

To get started, read these tutorials in this order:

1. [Flutter Router API is not declarative. Here is why](https://medium.com/p/bd962e6bfb91)
2. [Instagram-like navigation with Router API in Flutter](https://medium.com/p/a5851f1024d)
3. [Adding web URLs to Flutter app using app_state package](https://medium.com/p/329cb5a77aac)
4. [Tabs with independent navigation stacks in Flutter with app_state package](https://medium.com/p/cfb52d035da6)
5. [Receiving result from modal routes in Flutter with app_state package](https://medium.com/p/811acedc5214)

See the example projects: https://github.com/alexeyinkin/flutter-app-state-examples
