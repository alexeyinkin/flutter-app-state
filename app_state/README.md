[![Pub Package](https://img.shields.io/pub/v/app_state.svg)](https://pub.dev/packages/app_state)
[![GitHub](https://img.shields.io/github/license/alexeyinkin/flutter-app-state)](https://github.com/alexeyinkin/flutter-app-state/blob/main/LICENSE)
[![CodeFactor](https://img.shields.io/codefactor/grade/github/alexeyinkin/flutter-app-state?style=flat-square)](https://www.codefactor.io/repository/github/alexeyinkin/flutter-app-state)
[![Support Chat](https://img.shields.io/badge/support%20chat-telegram-brightgreen)](https://ainkin.com/chat)

A state management solution on top of Router API for larger apps.

This is a routing library. See how it compares to
[auto_route](https://medium.com/p/41da1aa53146)
and
[go_router](https://medium.com/p/397316f30dcb).

See [tons of runnable examples here](https://github.com/alexeyinkin/flutter-app-state/tree/main/app_state/example).

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
    * [Defining the Stacks](#defining-the-stacks)
    * [Showing the Stacks](#showing-the-stacks)
    * [Wiring the Stacks to Navigation Events](#wiring-the-stacks-to-navigation-events)
        + [PageStacksRouterDelegate](#pagestacksrouterdelegate)
        + [MaterialPageStacksRouterDelegate](#materialpagestacksrouterdelegate)
    * [Pushing Pages](#pushing-pages)
    * [Parsing URLs for the Stacks](#parsing-urls-for-the-stacks)
    * [Setting the Default Stack for Pages](#setting-the-default-stack-for-pages)
    * [Back Button with Multiple Stacks](#back-button-with-multiple-stacks)
- [Advanced Ways to Return Result](#advanced-ways-to-return-result)
    * [Push and Pop Type Safety at Compile Time](#push-and-pop-type-safety-at-compile-time)
    * [Receiving the Dialog Result after the App Restart](#receiving-the-dialog-result-after-the-app-restart)
        + [How Screens Get Closed](#how-screens-get-closed)
        + [Popping Data](#popping-data)
        + [Receiving Data](#receiving-data)
        + [Re-creating the Stack on Start-up](#re-creating-the-stack-on-start-up)
- [Tech Support Chat](#tech-support-chat)
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

![PageStack](https://raw.githubusercontent.com/alexeyinkin/flutter-app-state/main/app_state/img/page-stack.png)

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
  However, `PageStateMixin` is richer than a widget's `State`.
  It is aware of the page stacking and can handle events related to it.
- **Screen**.
  Most often this is just a stateless widget with your page state as the single argument.
- **Page**.
  `Navigator` in Flutter accepts the list of `Page` objects to maintain
  the stack of routes that are displayed.
  So `Page` is a necessary adapter for the pair of the state and the screen to show in the app.

These three together are collectively referred to as a 'page' (lowercase) to distinguish it from `Page` class.

Zooming in, this is how they interact:

![Page, Page State, Screen](https://raw.githubusercontent.com/alexeyinkin/flutter-app-state/main/app_state/img/page-state-screen.png)

## The Bare Minimal App

This app has one screen and no navigation. It even has no page state, since it has nothing to preserve.
See and run [the example project](https://github.com/alexeyinkin/flutter-app-state/tree/main/app_state/example/lib/1_min/main.dart).

![The Bare Minimal App](https://raw.githubusercontent.com/alexeyinkin/flutter-app-state/main/app_state/img/minimal.png)

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

![Book List App](https://raw.githubusercontent.com/alexeyinkin/flutter-app-state/main/app_state/img/book-list-no-urls.gif)

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

![Parsing PagePath](https://raw.githubusercontent.com/alexeyinkin/flutter-app-state/main/app_state/img/parsing-page-path.png)

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

![Emitting PagePath](https://raw.githubusercontent.com/alexeyinkin/flutter-app-state/main/app_state/img/emitting-page-path.png)

#### Page Without State
For a page without a state, you hardcode a `PagePath` like in the snippet above.

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
`PagePath`, with or without a state. For minor dialogs that should not affect the address bar
and should not get to the browser history, just do not introduce any path classes.

#### Updating the URL Programmatically

Imagine a tree browser that dynamically updates the address bar with all of this happening
in a single screen:

![Tree Navigation](https://raw.githubusercontent.com/alexeyinkin/flutter-app-state/main/app_state/img/tree-navigation.gif)

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
Read [this tutorial](https://github.com/alexeyinkin/flutter-app-state/tree/main/app_state/example/lib/6_forward_recovery)
on how to do this. It has the runnable app from which this GIF is recorded.

## Multiple Tabs with Independent Stacks

**Use case:** Each tab must have its own navigation stack.
The Android back button and the Scaffold's back button should only pop pages on the current stack.
Tab switching should not affect the back button history (except the browser's navigation buttons,
this is how browsers work).

![Multiple Tabs with Independent Stacks](https://raw.githubusercontent.com/alexeyinkin/flutter-app-state/main/app_state/img/multiple-stacks.gif)

Take a look at [this runnable example](https://github.com/alexeyinkin/flutter-app-state/tree/main/app_state/example/lib/4_tabs).

### Defining the Stacks

`PageStacks` is the class that:

- Holds multiple `PageStack` objects. These are added at runtime.
- Keeps the notion of the current stack.
- Serializes the states of all pages in all stacks for browser history.
- Recovers the states of all pages in all stacks when navigating the browser history.

This is how to initialize it in your `main.dart`:

```dart
final pageStacks = PageStacks();                                          // CHANGED
final _routerDelegate = MaterialPageStacksRouterDelegate(                 // CHANGED
  pageStacks: pageStacks,
  child: HomeScreen(stacks: pageStacks),
);
final _routeInformationParser = MyRouteInformationParser();
final _backButtonDispatcher = PageStacksBackButtonDispatcher(pageStacks); // CHANGED

void main() {
  pageStacks.addPageStack(                                                // NEW
    TabEnum.books.name,
    PageStack(
      bottomPage: BookListPage(),
      createPage: PageFactory.createPage,
    ),
  );

  pageStacks.addPageStack(                                                // NEW
    TabEnum.about.name,
    PageStack(
      bottomPage: AboutPage(),
      createPage: PageFactory.createPage,
    ),
  );

  pageStacks.setCurrentStackKey(TabEnum.books.name, fire: false);         // NEW

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: _routerDelegate,
      routeInformationParser: _routeInformationParser,
      backButtonDispatcher: _backButtonDispatcher,
    );
  }
}
```

### Showing the Stacks

Create a screen that shows the current stack:

```dart
class HomeScreen extends StatelessWidget {
  final PageStacks stacks;

  const HomeScreen({required this.stacks});

  @override
  Widget build(BuildContext context) {
    return PageStacksBuilder(
      stacks: stacks,
      builder: (BuildContext context) {
        final tab = TabEnum.values.byName(stacks.currentStackKey!);

        return Scaffold(
          body: KeyedStack<TabEnum>(
            itemKey: tab,
            children: stacks.pageStacks.map(
              (tabString, stack) => MapEntry(
                TabEnum.values.byName(tabString),
                PageStackNavigator(key: ValueKey(tabString), stack: stack),
              ),
            ),
          ),
          bottomNavigationBar: KeyedBottomNavigationBar<TabEnum>(
            currentItemKey: tab,
            items: const {
              TabEnum.books: BottomNavigationBarItem(
                icon: Icon(Icons.menu_book),
                label: 'Books',
              ),
              TabEnum.about: BottomNavigationBarItem(
                icon: Icon(Icons.info),
                label: 'About',
              ),
            },
            onTap: (tab) => stacks.setCurrentStackKey(tab.name),
          ),
        );
      },
    );
  }
}
```

Here `PageStacksBuilder` is the widget that builds itself on `PageStacks` events.

You can use any layout for the stacks. Here we use a bottom navigation bar that switches
the current stack. Note that we use `KeyedBottomNavigationBar` and `KeyedStack` from
[keyed_collection_widgets](https://pub.dev/packages/keyed_collection_widgets) package.
These are safer equivalents of the standard `BottomNavigationBar` and `IndexedStack`.

You are not limited to this layout an can as well use tabs or `PageView`, or even go split-screen
with all stacks visible at a time.

### Wiring the Stacks to Navigation Events

#### PageStacksRouterDelegate

`PageStacksRouterDelegate` is the router delegate that makes a `PageStacks` object
respond to navigation events by:
- Creating and popping pages in the current stack.
- Storing and recovering pages' states.

The only thing it does not know is how to show the stacks since this is very much app-specific,
so it does not override `RouterDelegate.build()` method.

#### MaterialPageStacksRouterDelegate

`MaterialPageStacksRouterDelegate` is a subclass that in addition overrides the `build()` method
and shows a specific child. It also gives you the default root `Navigator` which you don't use
for much but it is convenient for multiple reasons like having an `Overlay` for tool tips
on the navigation bar buttons.

So this is the delegate we use in the above example.

### Pushing Pages

You can push a page to the current page stack like this:

```dart
class BookListState with PageStateMixin<void> {
  void showDetails(Book book) {
    pageStacks.currentStack?.push(BookDetailsPage(bookId: book.id));
  }
  // ...
}
```

### Parsing URLs for the Stacks

For a single-stack app, we used to extend `PageStackRouteInformationParser` to parse URLs
into a stack configuration. Now we extend `PageStacksRouteInformationParser` (note the “s”).

The difference is that the latter recovers state for all stacks.

### Setting the Default Stack for Pages

When URL is typed in, it is converted to a `PagePath` object which is used
to create stacks of pages. With single stack, each path was populating that one stack.
With multiple stacks, each path must know what tab should be active
if it was the entry point to the app. Otherwise an exception is thrown.

For this, override `defaultStackKey` getter in each `PagePath`:

```dart
class BookListPath extends PagePath {
  // ...
  @override
  String get defaultStackKey => TabEnum.books.name;
}
```

### Back Button with Multiple Stacks

In Android, the back button always closes the current screen and does not lead
to the previously selected tab.

However, in browser, the back button will take you to a previously selected tab
as this is how browsers are supposed to work.
Traditionally their back-forward navigation has to do with history and not with hierarchy.

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

**Use case:**

1. The user opens the input dialog, copies its URL and restarts the app at that URL.
2. The user inputs a value and closes the dialog.
3. The underlying page receives the result.

![Result Surviving Restart](https://raw.githubusercontent.com/alexeyinkin/flutter-app-state/main/app_state/img/result-surviving-restart.gif)

See [this runnable example](https://github.com/alexeyinkin/flutter-app-state/tree/main/app_state/example/lib/5_route_result)
from which this GIF is recorded.

This cannot be done by mere awaiting of the pushed page. When the app restarts,
even if we recover the page stack, we create the stack in the factory, so the bottom page
has no future to await.

#### How Screens Get Closed

Each `PageStateMixin` has `events` stream.
`PageStack` listens to its pages’ `event` streams, and this allows the page states to coöperate.

![How Screens Get Closed](https://raw.githubusercontent.com/alexeyinkin/flutter-app-state/main/app_state/img/closing-screen.png)

The `PageStateMixin` can call `pop(data)` method with an optional `data` argument.
It emits the `PagePopEvent` that carries this data.

If you use `PageStackNavigator`, then under the hood these two also call this method without data:
- The Android back button.
- The back arrow button in `AppBar`.

`PageStack` receives this event and calls `didPopNext` method on the `PageStateMixin`
immediately under. The event is passed there. This way,
the `PageStaeMixin` learns that it is likely the topmost one now.

Also `PageStack` completes the future that was created with the original push.

So the bottom `PageStateMixin` has two ways to receive the data.

#### Popping Data

In this example, this is how the state closes its screen on the 'save' button.
It is the same as described earlier in [Programmatic Popping](#programmatic-popping):

```dart
class InputPageNotifier extends ChangeNotifier with PageStateMixin<String> {
  final nameController = TextEditingController();

  InputPageNotifier({
    required String name,
  }) {
    nameController.text = name;
    nameController.addListener(notifyListeners);
  }

  void onSavePressed() {
    pop(nameController.text); // This is statically type-checked to be String.
  }

  @override
  InputPath get path => const InputPath();
}
```

#### Receiving Data

And this is how the result is received:

```dart
class AboutPageNotifier extends ChangeNotifier with PageStateMixin<void> {
  String name;

  AboutPageNotifier({required this.name});

  Future<void> onLicensePressed() async {
    // This is statically type-checked to be String.
    final result = await pageStacks.currentStack?.push(
      InputPage(name: name),
    );

    print('Awaited: $result');
  }

  @override
  void didPopNext(AbstractPage page, PagePopEvent event) {
    print('didPopNext: ${event.data}');

    final data = event.data; // Not type-checked in any way.
    if (data is String) {
      name = data;
      notifyListeners();
    }
  }

  @override
  AboutPath get path => const AboutPath();
}
```

Note that `event.data` is not type-checked by the receiver.
This is because we can push pages of different classes that produce different result types,
but they all are collected in this method.

#### Re-creating the Stack on Start-up

In [Recommended PagePath Structure](#recommended-pagepath-structure), we showed how a `PagePath`
can dictate the default stack of pages when its URL is typed in. This was optional before
but is critical now that the bottom page must receive the data:

```dart
@override
get defaultStackPaths => [
      const AboutPath(),
      this,
    ];
```

## Tech Support Chat

Do you have any questions?

Feel free to ask in the [Telegram Support Chat](https://ainkin.com/chat).

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

Here are [tons of runnable examples again](https://github.com/alexeyinkin/flutter-app-state/tree/main/app_state/example)
if you have missed the link in the beginning.
