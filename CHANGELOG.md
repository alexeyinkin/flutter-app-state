## 0.6.3

* Renamed `PageBlocCloseEvent` to `PageBlocPopEvent` to align with `didPopNext` method.
* A deprecated `typedef` was created for backwards compatibility.

## 0.6.2

* Renamed `PageConfiguration` to `PagePath`. A `typedef` for backwards compatibility is added.
  Methods, getters, and arguments with pages' 'configuration' in its name were changed to use 'path',
  deprecated copies of the old ones were added for backwards compatibility.
  The `PageConfiguration`'s name was a permanent source of confusion.
  Each doc had to start with a note that `PageConfiguration` corresponds to a URL,
  and it was not easy to memorize. This change will simplify the learning of this package.
  It has also stripped 9-13 characters from identifiers.
  `Path` is inspired by the
  [original article announcing Router API](https://medium.com/flutter/learning-flutters-new-navigation-and-routing-system-7c9068155ade)
  (as well as `app_state` name itself was).
  `Configuration` earlier was inspired by `Router` docs where it means the configuration of
  the whole app (earlier versions of `app_state` were designed to allow storing only the top page's
  state, and so 'configuration' was extended to pages as well). 'Configuration' is still used
  in `PageStackConfiguration` and `PageStacksConfiguration` class names that do represent
  the whole app's state, and that is correct.
* Deprecated `PagePath.restoreRouteInformation`. It used to allow overriding `state`
  and was confusing because it was not used in serializing for browser history
  (`super.state` is).

## 0.6.1

* Fix images in README.

## 0.6.0

* **BREAKING**: All classes that had a type parameter `<C extends PageConfiguration>` no longer
  have it. The idea of this type parameter is to have a subclass that is a superclass to all of
  your configurations. An example is when you store a language slug there, and it must be
  automatically present in all your configurations. These cases are rare, and most of the time
  `<PageConfiguration...` only clutters the code when you must provide some other typed
  parameters like `PageBloc` type or the return value.
  All such classes were renamed in a pattern of `PageBloc<C, R> -> CPageBloc<C, R>`.
  Then `typedef`s were added like `typedef PageBloc<R> = CPageBloc<PageConfiguration, R>`.
  If you need the common subclass of `PageConfiguration`,
  just add `C` before all such typed parent classes to get it back.
  Otherwise just remove `<PageConfiguration>` from your code.
* **BREAKING**: When `PageStackBloc` compares pages to `null` `PageConfiguration`,
  it ignores the page keys and never disposes such pages.
  This is to allow non-web apps without any `PageConfiguration` classes.
  Otherwise the pages were always kicked out when comparing to `null` `PageConfiguration`.
  No practical use cases were affected.
* `PageConfiguration` classes are now optional for all non-web apps and web apps that do not
  care for URLs.
* `PageConfiguration` is now non-abstract and has `/` as the default `location`.
* `PageConfiguration` objects no longer need to parse `RouteInformation.state` in their `tryParse`.
  To benefit from this, stop overriding `parseRouteInformation` in your parser and override
  one of the new methods instead: `parsePageConfiguration`,
  `PageStackRouteInformationParser.parsePageStackConfiguration`,
  `PageStacksRouteInformationParser.parsePageStacksConfiguration`.
  These methods are only called when failed to extract state from `RouteInformation`,
  i.e. when the URL is typed in, and so no non-URL state information is present.
* `PageStackConfiguration.getTopPageConfiguration()` is now nullable and returns null if
  none of the pages in the stack have `PageConfiguration`.
* `PageStackRouteInformationParser` and `PageStacksRouteInformationParser` can now be used
  without subclassing in all non-web apps and web apps that do not care for URLs.
  By return they parse `null` `PageConfiguration` objects.
* `PageStackRouteInformationParser` and `PageStacksRouteInformationParser` in their
  `restoreRouteInformation` now return all their stack/stacks states to store in browser history
  and not only that of the top `PageConfiguration`.
* Added `const` constructors to `PageStackRouteInformationParser` and
  `PageStacksRouteInformationParser`.
* `PageStackRouteInformationParser` and `PageStacksRouteInformationParser` now have
  `parsePageConfiguration` to only parse the single `PageConfiguration`. This way the superclasses
  call `defaultStackConfiguration` and `defaultStacksConfiguration` so you don't have to.
  They are *the recommended* replacements to respective `parseRouteInformation` methods.
  They are called only when failed to recover from `RouteInformation.state`.
  To use them, stop overriding `parseRouteInformation`.
* `PageStackRouteInformationParser` now has `parsePageStackConfiguration`,
  and `PageStacksRouteInformationParser` now has `parsePageStacksConfiguration`.
  They are *the alternative* replacements to respective `parseRouteInformation` methods
  in case you need additional logic to recover the stack state that cannot be derived
  from your `PageConfiguration` alone.
  They are called only when failed to recover `RouteInformation.state`.
  To use them, stop overriding `parseRouteInformation`.

## 0.5.1

* Added `PageConfiguration.location`.
* Added `PageConfiguration.defaultStackConfigurations`.

## 0.5.0

* **BREAKING**: Pages, Blocs an `PageBlocCloseEvent` have a new `R` type parameter
  for the return result.
  The actual result is of `R?` with `null` if closing without data.
* **BREAKING**: `PageBlocCloseEvent` has a new required `data` property of type `R`.
  It is encouraged to use it instead of subclassing `PageBlocCloseEvent`.
* **BREAKING**: Page classes no longer have `const` constructors because they have `Completer`s now.
* Added `PageBloc.pop(data)`.
* Added `PageBloc.didPopNext(page, event)`.
* `PageStackBloc.push` returns a `Future` that completes when the page is popped.
* Deprecated `PageBloc.onForegroundClosed` in favor of `didPopNext`.
* Deprecated `PageBloc.closeScreen` and `PageBloc.closeScreenWith` in favor of `pop`.

## 0.4.0

* **BREAKING**: Require Flutter 3.
* Re-licensed under MIT No Attribution.
* Using `total_lints`, fix linter issues.

## 0.3.5

* Fix duplicate page key handling.

## 0.3.4

* Call const constructors where possible.
* Applied `dart format`.
* Added features to `README.md`

## 0.3.3

* Added `MaterialPageStacksRouterDelegate`.
* Added `StatefulBlocWidget`.

## 0.3.2

* Const constructors for `PageBlocCloseEvent`, `PageBlocConfigurationChangedEvent`, `PageStackConfiguration`.
* Link to tutorials.

## 0.3.1

* Wrap `PageStackBlocEvent` as `PageStacksBlocEvent`.

## 0.3.0

* **BREAKING**: Remove `AppBloc`.
* Add `PageStacksBloc`, `PageStacksConfiguration`, `PageStacksRouteInformationParser`, `PageStacksRouterDelegate`.
* Add `PageConfiguration.defaultStackKey`, `defaultStacksConfiguration`.

## 0.2.1

* An accidental debug print removed.

## 0.2.0

* **BREAKING**: `PageConfiguration` is now abstract, added `restoreRouteInformation()`.
* Added `PageConfiguration.defaultStackConfiguration`.
* Added `PageStackConfiguration.getTopPageConfiguration()`.
* Added `PageStackRouteInformationParser`.

## 0.1.6

* Fix `onPopRoute` in `PageStackBlocNavigator`.

## 0.1.5

* Added `PageStackRouterDelegate`.

## 0.1.3

* Added `PageBloc.closeScreenWith`, `PageBloc.onForegroundClosed`.

## 0.1.2

* **BREAKING**: Renamed `AppBlocNormalizedState` to `AppConfiguration`.
* **BREAKING**: Renamed `PageStackBlocNormalizedState` to `PageStackConfiguration`.
* **BREAKING**: Renamed `ScreenBlocNormalizedState` to `PageConfiguration`.
* **BREAKING**: Renamed `Screen...` events to `Page...` events.
* **BREAKING**: Extracted `PageBloc.states` to the new `PageStatefulBloc` subclass.
* `PageBloc` is not abstract.
* Allow to specify duplicate key behavior per push.
* Allow `null` for page keys.
* Added docs.

## 0.1.1

* **BREAKING**: Removed `ScreenBlocConfigurationChangedEvent.configuration`.
* Added `AppBloc`.
* Added `AppBlocNormalizedState`, `PageStackBlocNormalizedState`, `ScreenBlocNormalizedState`.
* Normalize and denormalize state.
* Create pages in `PageStackBloc`.

## 0.1.0

* Initial release.
