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
