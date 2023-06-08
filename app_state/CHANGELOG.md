## 0.9.4

* Require `flutter_issue_108697_workaround: ^0.1.3` with a fix for WebKit.

## 0.9.3

* Added `PPageStateMixin.pageStack`, fill it when a page is added to the stack.

## 0.9.2

* Added `PageStackNavigator.navigatorKey`, passed `PageStackRouterDelegate.navigatorKey`.

## 0.9.1

* Fixed linter issues.
* Upgrade to [total_lints](https://pub.dev/packages/total_lints) v2.19.0

## 0.9.0

* **BREAKING:** `restoreRouteInformation` in `PageStackConfiguration` and `PageStacksConfiguration`
are now nullable. They used to return `/` for `null` paths and that had been showing for an instant
in the address bar when starting at a non-`/` URL.

## 0.8.4

* Support for `collection` v1.17.0.

## 0.8.3

* Added `PagePath.uri`.
* Added `PagePath.getUriAtBase()`.
* Relaxed mockito version requirement.

## 0.8.2

* Allow `PageStack.replacePath` without `RouteInformationParser`.

## 0.8.1

* Exports `PageStacksStackEvent`.

## 0.8.0

* **BREAKING:** Removed all functionality deprecated in v0.6 and v0.7.

## 0.7.4

* Added `PageStacksBuilder` widget.
* Refactored the `5_route_result` example to use `ChangeNotifier` instead of bloc.
* Incorporated the older separate medium tutorials in the READMEs:
    * [Recovering user input when ‘Forward’ is clicked in Flutter app](https://medium.com/p/60c66938db34).
    * [Tabs with independent navigation stacks in Flutter with app_state package](https://medium.com/p/cfb52d035da6).
    * [Receiving result from modal routes in Flutter with app_state package](https://medium.com/p/811acedc5214).
* Fixed image links in `/example/README.md`.
* Added 'Support: Telegram' shield.

## 0.7.3

* Fixed image paths.

## 0.7.2

* Fixed linter issues, formatted examples, added the format check to the CI.
* Moved to `app_state` subdirectory.

## 0.7.1

* Moved the examples to the package's repository.

## 0.7.0

Most of the references to BLoC were removed from the package to allow any implementation for
state management:
custom BLoC, BLoC or Cubit from [the bloc package](https://pub.dev/packages/bloc),
`ChangeNotifier`, or anything else. Deprecated `typedef`s to the older classes and
deprecated aliases to older members were added to soften the change.

This is a short-lived major version to migrate from those deprecated API to the new one
but to still be able to run your app in the process. Every deprecation in this version
is scheduled for removal in v0.8.0.

* **BREAKING:** While removing references to BLoC, named arguments to some constructors and methods
  could not be easily backed by anything backward compatible, and they were hard-renamed:
    * `PageStackPageBlocEvent`:
        * was renamed to `PageStackPageEvent`.
        * `bloc` was changed to `PageStateMixin state`.
        * `pageBlocEvent` was renamed to `pageEvent`.
    * `PageStacksPageStackBlocEvent`:
        * was renamed to `PageStacksStackEvent`.
        * `bloc` was renamed to `stack`.
        * `pageStackBlocEvent` was renamed to `pageStackEvent`.
    * `MaterialPageStacksRouterDelegate.pageStacksBloc` was changed from a named constructor
       argument to a positional one and renamed to `pageStacks`.
    * `PageStackNavigator.bloc` was renamed to `stack`.
* **BREAKING:** `PageStack.pages` is now an `UnmodifiableListView` and not the actual list.
* Renamings backed by deprecated `typedef`s and member aliases that are thus non-breaking:
    * `PageBloc` was changed to `PageStateMixin` mixin. To continue using
      custom blocs as in the previous versions, mix it in with `with` keyword
      instead of extending `PageBloc`. The newly deprecated `PageBloc`
      is changed to mix in this mixin.
    * `PageBlocEvent` was renamed to `PageEvent`.
    * `PageBlocPathChangedEvent` was renamed to `PagePathChangedEvent`.
    * In `enum PopCause`:
        * `pageBloc` was renamed to `page`.
        * `pageStackBloc` was renamed to `pageStack`.
    * `PageBlocPopEvent` was renamed to `PagePopEvent`.
    * `PageStackBackButtonDispatcher.pageStackBloc` was renamed to `pageStack`.
    * `PageStacksBackButtonDispatcher.pageStacksBloc` was renamed to `pageStacks`.
    * `PageStackBlocEvent` was renamed to `PageStackEvent`.
    * `PageStackRouterDelegate.pageStackBloc` was renamed to `pageStack`.
    * `PageStacksBloc`:
        * was renamed to `PageStacks`.
        * `currentStackBloc` was renamed to `currentStack`.
    * `PageStacksBlocEvent` was renamed to `PageStacksEvent`.
    * `PageStacksRouterDelegate.pageStacksBloc` was renamed to `pageStacks`.
    * `CAbstractPage.bloc` was changed to `PageStateMixin state`.
* `PageStackEvent` now has type parameter `<P extends PagePath>`.
* `PageState` class is added as the default class that uses `PageStateMixin`.
* All classes using `C` prefix were changed to `P` prefix. Deprecated `typedef`s added for
  backward compatibility. That prefix was historical
  when the term 'configuration' was used instead of 'path'. The new `P` stands for 'path'.
  These classes are meant for apps that have a common superclass under `PagePath`.
  All other apps should use the same classes without prefixes.

## 0.6.10

* Added `PageStacksConfigurationChangedEvent`.

## 0.6.9

* Preserves the state on browser refresh button press by using https://pub.dev/packages/flutter_issue_108697_workaround
* Renamed `PageStackBlocNavigator` to `PageStackNavigator`. A deprecated `typedef` was added
  for backward compatibility.

## 0.6.8

* Added `PageStackRouterDelegate.observers`, `PageStackRouterDelegate.transitionDelegate`.

## 0.6.7

* Added `PageStackBlocNavigator.observers`, `PageStackBlocNavigator.transitionDelegate`.

## 0.6.6

* Updated example links.

## 0.6.5

* Added `PageStackBloc.popUntilBottom()`, it uses the new `PopCause.pageStackBloc`.
* `PageBlocPopEvent` is now always created with the correct `R` type. Before it had been
* `const PageBlocPopEvent<Null>` for pops without data.
* Improved test coverage.
* Fix formatting.
* Add comparison to auto_route and go_router to README.

## 0.6.4

* Added `PageStackBloc.replaceWith` to declaratively navigate to a given path with two options:
    - Replacing the stack unconditionally with `mode: PageStackMatchMode.none`.
    - Preserving the states of pages that exist in both the old and the new stack with
      `mode: PageStackMatchMode.keyOrNullPathNoGap`.
* Added `mode` argument to `PageStackBloc.setConfiguration` to choose the match mode the same way
  as in `replaceWith`.
* Added `PageBlocCloseEvent.cause` to tell between the back button close, the bloc's own intention
  to close, and a kick-out as a result of stack diff.
* `BlocMaterialPage` is now non-abstract.
* Fixed issue when page stack was allowed to be emptied and stayed defunct afterwards
  [Issue 3](https://github.com/alexeyinkin/flutter-app-state/issues/3). The emptying operation
  is now reverted.
* Removed code duplication by handling all page removals in `PageStackBloc.handleRemoved()`.
* Expand tests.

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
