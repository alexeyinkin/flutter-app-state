import 'package:flutter/widgets.dart';

import '../page_stack/configuration.dart';
import '../page_stacks/configuration.dart';

/// Describes a location within the app, corresponds to URL + state.
/// Can be used to navigate to a page recovering its state.
/// Subclass this for your pages' configurations.
abstract class PageConfiguration {
  /// The key to compare with to [AbstractPage.key] to decide if the state
  /// is applicable to a page in a stack.
  ///
  /// It may be more specific than [factoryKey] and contain parameters
  /// that are constant during lifetime of the page, ex: 'ProfilePage_$userId'.
  /// This way, when the state with another $userId is applied, the keys
  /// won't match, and the page will be re-created with new $userId.
  ///
  /// The value of null means that the page is a transient dialog which
  /// should not be re-created on re-navigation. It may also be dropped
  /// during back-front navigation but this is not guaranteed. This may
  /// lead to unexpected results when recovering a state with another
  /// null-keyed page at the same position in the stack: such a page
  /// will not be replaced. Consider using null here only for prototyping.
  ///
  /// Null here may be disallowed in the future after testing real-world needs.
  final String? key;

  /// The key to pass to your page factory to create a new page.
  /// This happens when recovering page stack on navigation.
  ///
  /// While [key] commonly contains parameters to make similar pages differ,
  /// this one is mostly a simple constant, ex: 'ProfilePage'. This way it is
  /// easier to run it through switch-case in your page factory.
  ///
  /// Defaults to [key] if not set explicitly or if null is passed.
  String? get factoryKey => _factoryKey ?? key;
  final String? _factoryKey;

  /// All the parameters that are needed to re-create the page.
  ///
  /// This map is passed:
  ///   1. To your page factory to create the page. Use some parameters there
  ///      if you need something to be known at the time of creating your
  ///      [PageBloc].
  ///   2. To [PageBloc.setStateMap]. Use other parameters there
  ///      to recover further details of the state.
  final Map<String, dynamic> state;

  const PageConfiguration({
    this.key,
    String? factoryKey,
    this.state = const {},
  }) :
      _factoryKey = factoryKey;

  static List<Map<String, dynamic>?> toJsons(Iterable<PageConfiguration?> pcs) {
    return pcs
        .map((pc) => pc?.toJson())
        .toList(growable: false);
  }

  Map<String, dynamic>? toJson() {
    return {
      'key': key,
      'factoryKey': factoryKey,
      'state': state,
    };
  }

  static List<PageConfiguration> fromMaps(List maps) {
    return maps
        .cast<Map<String, dynamic>>()
        .map((v) => PageConfiguration._fromMap(v))
        .toList(growable: false);
  }

  factory PageConfiguration._fromMap(Map<String, dynamic> map) {
    return _DenormalizedPageConfiguration(
      key: map['key'],
      factoryKey: map['factoryKey'],
      state: map['state'],
    );
  }

  RouteInformation restoreRouteInformation();

  // What pages to show when navigating directly to this configuration's URL.
  PageStackConfiguration get defaultStackConfiguration {
    return PageStackConfiguration(
      pageConfigurations: [this],
    );
  }

  String get defaultStackKey => (throw UnimplementedError());

  PageStacksConfiguration get defaultStacksConfiguration {
    final key = defaultStackKey;

    return PageStacksConfiguration(
      currentStackKey: key,
      pageStackConfigurations: {key: defaultStackConfiguration},
    );
  }
}

class _DenormalizedPageConfiguration extends PageConfiguration {
  _DenormalizedPageConfiguration({
    required String? key,
    required String? factoryKey,
    required Map<String, dynamic> state,
  }) : super(
    key: key,
    factoryKey: factoryKey,
    state: state,
  );

  @override
  RouteInformation restoreRouteInformation() {
    throw UnimplementedError();
  }
}
