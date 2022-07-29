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
