[![Pub Package](https://img.shields.io/pub/v/app_state.svg)](https://pub.dev/packages/app_state)
[![GitHub](https://img.shields.io/github/license/alexeyinkin/flutter-app-state)](https://github.com/alexeyinkin/flutter-app-state/blob/main/LICENSE)
[![CodeFactor](https://img.shields.io/codefactor/grade/github/alexeyinkin/flutter-app-state?style=flat-square)](https://www.codefactor.io/repository/github/alexeyinkin/flutter-app-state)

A state management solution on top of Router API for larger apps.

This is a routing library. See how it compares to
[auto_route](https://medium.com/p/41da1aa53146)
and
[go_router](https://medium.com/p/397316f30dcb).

See [tons of runnable examples here](https://github.com/alexeyinkin/flutter-app-state-examples).

- [Unique Features](#unique-features)
    * [States First](#states-first)
    * [Push-pop Type Safety at Compile Time](#push-pop-type-safety-at-compile-time)
    * [Stack Recovery from URL](#stack-recovery-from-url)
    * [Dialog Awaiting Survives the App Restart](#dialog-awaiting-survives-the-app-restart)
- [Architecture](#architecture)
- [The Bare Minimal App](#the-bare-minimal-app)
- [Pushing and Popping Pages](#pushing-and-popping-pages)
    * [Pushing](#pushing)
    * [Programmatic Popping](#programmatic-popping)
    * [Overriding the Back Button](#overriding-the-back-button)
    * [Page Keys](#page-keys)
- [Web Architecture](#web-architecture)
    * [Parsing URLs](#parsing-urls)
    * [Recommended PagePath Structure](#recommended-pagepath-structure)
    * [Creating the Page Objects](#creating-the-page-objects)
    * [Updating the Address Bar](#updating-the-address-bar)
        + [Page Without State](#page-without-state)
        + [Page With State](#page-with-state)
        + [Page Without URL](#page-without-url)
        + [Updating the URL Programmatically](#updating-the-url-programmatically)
    * [Redirecting a URL](#redirecting-a-url)
        + [Option 1. Single Class](#option-1-single-class)
        + [Option 2. Multiple Classes](#option-2-multiple-classes)
    * [Browser Back and Forward Buttons](#browser-back-and-forward-buttons)
    * [Recovering Unsaved Input on Page Refresh and Navigation](#recovering-unsaved-input-on-page-refresh-and-navigation)
- [Multiple Tabs with Independent Stacks](#multiple-tabs-with-independent-stacks)
- [Advanced Ways to Return Result](#advanced-ways-to-return-result)
    * [Push and Pop Type Safety at Compile Time](#push-and-pop-type-safety-at-compile-time)
    * [Receiving the Dialog Result after the App Restart](#receiving-the-dialog-result-after-the-app-restart)
- [Help is Wanted](#help-is-wanted)

## Unique Features

### States First

Instead of routes or widgets, in the core there is a stack of stateful objects
(Blocs, ChangeNotifiers, or anything else, collectively referred to as *page states*
as opposed to *widget states*).
This package translates navigation intents to operations on those.
The page states are then wrapped into widgets to form the navigator's stack.
This simplifies state management: no need for providers,
stateful widgets, manual bloc creation and disposal, or `BuildContext`.

### Push-pop Type Safety at Compile Time

All state objects are typed and can only pop what is allowed.
And the Page entry you push to the stack is also typed, so your awaited type is also
guaranteed.

### Stack Recovery from URL

When a URL is typed in, the page stack is recovered by the rules you define. If you navigate to
`/books/123/rate`, you may get a stack of 3 pages: The Book List at the bottom, the Book Details,
and Rate dialog at the top, all can be popped by the back button.
Unlike with beamer, the rules can be any, and not only derived from
path segments.

### Dialog Awaiting Survives the App Restart

Page states listen to events from other page states above them. When the top one pops, its result is passed
to `didPopNext` method of the page state under it. So you get the result without awaiting a future.
If you type in `/books/123/rate` and close the dialog by rating a book, the book details page state
will get the rate without any future. See and run
[the license dialog example](https://github.com/alexeyinkin/flutter-app-state/tree/main/app_state/example/lib/5_route_result).

## Architecture

The main state unit is `PageStack`. You normally create it as a global object
available to all code, or you provide it with [get_it](https://pub.dev/packages/get_it).

It contains the stack at runtime:

![PageStack](https://raw.githubusercontent.com/alexeyinkin/flutter-app-state/main/img/page-stack.png)

For each page, there are 3 main units:

- **Page State**.
  This is the heart of a page during its life cycle.
  It can be any object with `PageStateMixin`:
  a [BLoC](https://pub.dev/packages/bloc),
  a [ChangeNotifier](https://api.flutter.dev/flutter/foundation/ChangeNotifier-class.html),
  or a plain custom class.
  If your screen was a `StatefulWidget` in the traditional architecture,
  then the page state with this mixin plays the role of its `State`.
  It contains everything to preserve so the screen itself can be a stateless widget.
  However, `PageStateMixin` is richer than a screen's `State`.
  It is aware of the page stacking and can handle events related to it.
- **Screen**.
  Most often this is just a stateless widget with your page state as the single argument.
- **Page**.
  `Navigator` in Flutter accepts the list of `Page` objects to maintain
  the stack of routes that are displayed.
  So `Page` is a necessary adapter for the pair of the state and the screen to show in the app.

These three together are collectively referred to as a 'page' (lowercase) to distinguish it from `Page` class.

Zooming in, this is how they interact:

![Page, Page State, Screen](https://raw.githubusercontent.com/alexeyinkin/flutter-app-state/main/img/page-state-screen.png)

## The Bare Minimal App

This app has one screen and no navigation. It even has no page state, since it has nothing to preserve.
See and run [the example project](https://github.com/alexeyinkin/flutter-app-state/tree/main/app_state/example/lib/1_min/main.dart).

![The Bare Minimal App](https://raw.githubusercontent.com/alexeyinkin/flutter-app-state/main/img/minimal.png)

```dart
import 'package:app_state/app_state.dart';
import 'package:flutter/material.dart';

final pageStack = PageStack(bottomPage: HomePage());
final _routerDelegate = PageStackRouterDelegate(pageStack);

void main() => runApp(MyApp());

class HomePage extends StatelessMaterialPage {
  HomePage() : super(key: const ValueKey('Home'), child: HomeScreen());
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hello World with app_state!')),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: _routerDelegate,
      routeInformationParser: const PageStackRouteInformationParser(),
    );
  }
}
```

## Pushing and Popping Pages

### Pushing

To push a screen, you create its `Page` object and `push` it into a `PageStack`:

```dart
final result = await pageStack.push(
  BookDetailsPage(bookId: id),
);
```

You can do this from anywhere and don't need `BuildContext`.

The Android back button and the default `BackButton` in `Scaffold` just work.

See and run [this example with a book list](https://github.com/alexeyinkin/flutter-app-state/tree/main/app_state/example/lib/2_two_screens).
It has no URLs so far, we will get to them soon.

![Book List App](https://raw.githubusercontent.com/alexeyinkin/flutter-app-state/main/img/book-list-no-urls.gif)

### Programmatic Popping

To pop a page, call `pop()` on its state with an optional return value:
```dart
onPressed: () => state.pop(result);
```

### Overriding the Back Button

In your state, override `onBackPressed()`:

```dart
@override
Future<BackPressedResult> onBackPressed() {
  if (!_saved) {
    return Future.value(BackPressedResult.keep);
  }
  return Future.value(BackPressedResult.close);
}
```

### Page Keys

Each page in a stack must have a unique key. If you push a page with an existing key,
the `onDuplicateKey` argument of `push` determines what to do. It can:

- Bring the older page up and drop the new page (the default).
- Drop the older page and show the new one.
- Throw an exception.

Pages of the same class may have different keys. In a social app, you may have a user page
with the user ID in the key. This allows you to show multiple user profiles in the stack,
but if a duplicate user profile is about to be shown, you can bring the old one above
to save memory and to not bore your user with many back taps later.

## Web Architecture

All the above examples work in web, but the URL always stays `/`. Here is how to support URLs.

### Parsing URLs

`PagePath` class is an object representation of a URL. You subclass it for every
page you support. For example, `BookListPath` will likely have no arguments,
but a `BookDetailsPath` will likely have `final int id;`

You then create a URL parser that is called by Flutter on start-up
and also on back and forward navigation.
This parser chooses the particular `PagePath`.

![Parsing PagePath](https://raw.githubusercontent.com/alexeyinkin/flutter-app-state/main/img/parsing-page-path.png)

It is easiest to maintain if made of one-liners like this:

```dart
class MyRouteInformationParser extends PageStackRouteInformationParser {
  @override
  Future<PagePath> parsePagePath(RouteInformation ri) async {
    return
        BookDetailsPath.tryParse(ri) ??
        const BookListPath(); // The default page if nothing worked.
  }
}
```

You use this parser instead of the ordinary `PageStackRouteInformationParser` in your app constructor.
See and run [this example](https://github.com/alexeyinkin/flutter-app-state/tree/main/app_state/example/lib/3_web)
that adds URL support to the earlier book list example.

### Recommended PagePath Structure

This is the class from the above example.

```dart
class BookDetailsPath extends PagePath {
  final int bookId;

  static final _regExp = RegExp(r'^/books/(\d+)$');

  BookDetailsPagePath({
    required this.bookId,
  }) : super(
    key: BookDetailsPage.formatKey(bookId: bookId),
    factoryKey: BookDetailsPage.classFactoryKey,
    state: {'bookId': bookId},
  );

  @override
  String get location => '/books/$bookId';

  static BookDetailsPath? tryParse(RouteInformation ri) {
    final matches = _regExp.firstMatch(ri.location ?? '');
    if (matches == null) return null;

    final bookId = int.tryParse(matches[1] ?? '') ?? (throw Error());
    return BookDetailsPath(
      bookId: bookId,
    );
  }

  @override
  get defaultStackPaths => [
    const BookListPath(),
    this,
  ];
}
```

- **`tryParse`** is the recommended static method in each of your `PagePath` classes.
  You then call them in a chain to return the one that worked.
  Here it applies the regular expression to get `bookId`.
- **`location`** getter is the reverse. It returns the path of the URL to put in the address bar
  in case the location changes programmatically in the app and not as a result of the
  address bar change. If not present, the URL will be `/`.
- **`defaultStackPaths`** returns a list of `PagePath` objects to pre-populate
  the stack with, bottom to top. In this case, the user has typed in a particular book's URL,
  so we compose the initial stack of two pages. At the bottom is the book list page,
  and above it is this one we parsed. So when this stack is loaded, the back button would lead the user
  to the book list page. If this getter is not present, the stack defaults to this single page.
- **`super.key`** is to diff the pages in the stack to see if after the URL change some pages
  need to be kicked out of the stack, updated, or added.
- **`super.state`** is the map of all fields. It is required because sometimes this object
  gets serialized into the browser history and then recovered.
- **`super.factoryKey`** will be described in the next section.

This was the most complicated example you will see with this package.
Everything else will be simpler.

### Creating the Page Objects

Create a global method like this:

```dart
AbstractPage? createPage(
  String factoryKey,
  Map<String, dynamic> state,
) {
  switch (factoryKey) {
    case BookDetailsPage.classFactoryKey: return BookDetailsPage(bookId: state['bookId']);
    case BookListPage.classFactoryKey: return BookListPage();
  }

  return null;
}
```

Then pass it to your `PageStack`:

```dart
final pageStack = PageStack(
  bottomPage: BookListPage(),
  createPage: createPage,
);
```

Pages also must be upgraded to support the factory:

```dart
class BookDetailsPage extends StatelessMaterialPage {
  static const classFactoryKey = 'BookDetails';

  BookDetailsPage({
    required int bookId,
  }) : super(
    key: ValueKey(formatKey(bookId: bookId)),
    child: BookDetailsScreen(book: bookRepository[bookId]),
    path: BookDetailsPath(bookId: bookId),
  );

  static String formatKey({required int bookId}) {
    return '${classFactoryKey}_$bookId';
  }
}
```

The new things in this `Page` class are:

- **`classFactoryKey`** is any unique string among your page classes.
  This is what `PagePath.factoryKey` is matched to when your factory selects
  the page class to create.
- **`formatKey`** is a method to create a runtime key to
  [avoid page duplication in the stack](#page-keys). It is just for convenience because
  we now need to create these keys in two different places: here and in `BookDetailsPath`.
- **`super.path`** is described next.

### Updating the Address Bar

The address bar is not the only source of `PagePath` objects.
When you programmatically create a page and push it to the stack, it may report
a `PagePath` object to the framework so it updates the address bar from it.

![Emitting PagePath](https://raw.githubusercontent.com/alexeyinkin/flutter-app-state/main/img/emitting-page-path.png)

#### Page Without State
For a page without state, you hardcode a `PagePath` like in the snippet above.

```dart
super(
  // ...
  path: BookDetailsPath(bookId: bookId),
);
```

When this page is pushed, that `PagePath.location` ends up in the address bar.

#### Page With State
A page with state delegates this to the state for higher flexibility.
Override the `PageStateMixin.path` getter:

```dart
@override
BookListPath get path => const BookListPath();
```

#### Page Without URL
The address bar content is always taken from the highest page in the stack that has non-`null`
`PagePath`, with or without state. For minor dialogs that should not affect the address bar
and should not get to the browser history, just do not introduce any path classes.

#### Updating the URL Programmatically

Imagine a tree browser that dynamically updates the address bar with all of this happening
in a single screen:

![Tree Navigation](https://raw.githubusercontent.com/alexeyinkin/flutter-app-state/main/img/tree-navigation.gif)

What gets updated is its state. A state can emit a new `PagePath` at any time.
For this, call its `emitPathChanged()` method.
This will call the `path` getter for the actual path to propagate.

### Redirecting a URL

#### Option 1. Single Class
The URL that your `PagePath` returns takes over the one
that was parsed. To redirect `/` to `/books`, do the following:

1. In `BookListPath.tryParse()`, allow both `/` and `/books`.
2. Return `/books` in `location` getter.

#### Option 2. Multiple Classes
You can have many `PagePath` classes for different URLs that all return
`BookListPath` in their `tryParse` methods, and it in turn will return `/books`
for location.

This is useful for:

- Redirecting to a page without its knowledge.
- Conditional redirects where you don't want to concentrate the condition logic
  in the target `PagePath`.

### Browser Back and Forward Buttons

Back and Forward buttons in the browser work automatically. Unlike the Android back button,
these buttons traverse the browser's history. The following is happening on any navigation
with the browser buttons:

1. **`RouteInformationParser`** is called with a URL to parse `PagePath` object from it.
   This is exactly like when the app starts.
2. Unlike the initial parsing, the `RouteInformation` now contains saved states for each page.
   This is because when the framework emitted the `PagePath` earlier,
   it was smart enough to also save all pages' serialized states.
   This is why you did pass `state` to `PagePath` super constructor earlier.
   This is how [History API](https://developer.mozilla.org/en-US/docs/Web/API/History_API)
   works in JavaScript, nicely abstracted by Flutter.
   `PageStackRouteInformationParser` detects this and skips the URL parsing.
3. `PageStack.setConfiguration()` is called with all pages' states recovered into maps.
   The current pages in the stack are diffed against that recovered state.
   Unchanged pages are not affected, unwanted pages are popped, and new pages are created
   using the `createPage` factory you provided when creating this stack. This is why `createPage`
   gets a map and not a `PagePath` object.
4. `PageStck` emits an event to rebuild any navigator listening to it.
   This is usually `PageStackNavigator` created for you by the default `PageStackRouterDelegate`
   you passed to the app constructor.
5. The `Navigator` then runs its own diff on pages to update the routes that actually show
   the screen widgets, this is Flutter's built-in. This way you get the updated UI.

It all works for you automatically if you correctly set all pages' and `PagePath` keys.

### Recovering Unsaved Input on Page Refresh and Navigation

![Screen](https://raw.githubusercontent.com/alexeyinkin/flutter-issue-108697-workaround/main/example/example.gif)

This package allows you to recover the state in many cases where it otherwise would be lost:
1. Page refresh, including `Ctrl-F5`.
2. Back and Forward navigation with browser buttons between your app pages.
3. Back and Forward navigation away from your app that effectively restarts it.

Flutter apps generally cannot do (1) and (3) because of
[a bug in Flutter](https://github.com/flutter/flutter/issues/108697), but this package
has a workaround for it. Actually the only way to lose the state is to copy the URL
and re-open it in a new browser tab.

To preserve the state, you add data fields to your `PagePath` classes, and then save and read them.
Read [this tutorial](https://medium.com/p/60c66938db34) on how to do this.

## Multiple Tabs with Independent Stacks

Use case: Each tab must have its own navigation stack.
The Android back button and the Scaffold's back button should only pop pages on the current stack.
Tab switching should not affect the back button history (except the browser's navigation buttons,
this is how browsers work).

![Multiple Tabs with Independent Stacks](https://raw.githubusercontent.com/alexeyinkin/flutter-app-state/main/img/multiple-stacks.gif)

Read [this tutorial](https://medium.com/p/cfb52d035da6) on how this app is made.

## Advanced Ways to Return Result

### Push and Pop Type Safety at Compile Time

`PageStateMixin` and `StatefulMaterialPage` are typed by a return type `R`:

- `PageStateMixin<R>`
- `StatefulMaterialPage<R, B extends PageStateMixin<R>>`

In most examples we ignore those types for faster learning, but in production
you always specify the return type even if it is `void`.

If you await the `push` call, the result is inferred with that type:

```dart
class InputPageState with PageStateMixin<int> { /* ... */ }
class InputPage extends StatefulMaterialPage<int, InputPageState> { /* ... */ }

final result = await pageStack.push(InputPage()); // result is inferred as int.
```

When you `pop` the result from the state, you can only `pop` that exact type,
otherwise it will not build.

And your `Page` can only have a state of the same return type, otherwise it will not build.

### Receiving the Dialog Result after the App Restart

Use case:

1. The user opens the input dialog, copies its URL and restarts the app at that URL.
2. The user inputs a value and closes the dialog.
3. The underlying page receives the result.

![Result Surviving Restart](https://raw.githubusercontent.com/alexeyinkin/flutter-app-state/main/img/result-surviving-restart.gif)

This cannot be done by mere awaiting of the pushed page. When the app restarts,
even if we recover the page stack, we create the stack in the factory, so the bottom page
has no future to await.

For this, we employ the alternative way to receive the result. In the bottom page state,
override `didPopNext`:

```dart
@override
void didPopNext(AbstractPage page, PagePopEvent event) {
  print('didPopNext: ${event.data}');
}
```

This way the compiler still makes sure the state pops with the right type, but the `event.data`
is not type-checked by the receiver. This is because a state can push pages of different classes that produce different
result types, but they all are collected in this method.

See [this tutorial](https://medium.com/p/811acedc5214) with more details and the link to the full runnable example.

## Help is Wanted

Do you like this package? Do not buy me a coffee, I don't drink it. Here is what you can do:

* **Spread**:
    * **Like this package** on https://pub.dev/packages/app_state, because people judge the packages by the
      like count.
    * **Spread a word** to Flutterers you know.
    * **[Follow me on Medium](https://medium.com/@alexey.inkin)**. It will show the app_state tutorials to more people.

* **Info Help**:
    * **I need a Comparison** to
      [beamer](https://pub.dev/packages/beamer),
      [routemaster](https://pub.dev/packages/routemaster),
      raw Router API implementation,
      and the old Navigator push-pop. You can write an article or at least provide me with points
      on how they compare, what they could not do for you, what is too hard with them,
      or how this package made your life easier.
      My email is here: https://pub.dev/publishers/ainkin.com/packages
    * **Send me your project link** so I can list it among users to have a richer gallery of examples.
      Get a free ad from me.
      If it is a proprietary website or app, people will see what is possible to do with the package.
      And if it is open-source,
      it will get more attention here and gain more users.
    * **Reports an Issue** if you find anything wrong.

* **Program**:
    * **Code Generator**. This package needs one to generate `Page` and `PagePath` classes,
      a page factory and `PagePath` parsing chain.
      You can design or implement it.
    * **Tests**. You can cover it.
    * **Other PRs**. Please share your idea in an issue first.

Here are [tons of runnable examples again](https://github.com/alexeyinkin/flutter-app-state-examples)
if you have missed the link in the beginning.
