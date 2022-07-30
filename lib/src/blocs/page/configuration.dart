import 'package:flutter/widgets.dart';

import '../../pages/abstract.dart';
import '../page_stack/configuration.dart';
import '../page_stacks/configuration.dart';
import 'bloc.dart';

/// Describes a location within the app, corresponds to URL + state.
/// Can be used to navigate to a page recovering its state.
/// Subclass this for your pages' configurations.
class PageConfiguration {
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
  ///   2. To [CPageBloc.setStateMap]. Use other parameters there
  ///      to recover further details of the state.
  final Map<String, dynamic> state;

  const PageConfiguration({
    this.key,
    String? factoryKey,
    this.state = const {},
  }) : _factoryKey = factoryKey;

  static List<Map<String, dynamic>?> toJsons(Iterable<PageConfiguration?> pcs) {
    return pcs.map((pc) => pc?.toJson()).toList(growable: false);
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
        .map(PageConfiguration._fromMap)
        .toList(growable: false);
  }

  factory PageConfiguration._fromMap(Map<String, dynamic> map) {
    return _DenormalizedPageConfiguration(
      key: map['key'],
      factoryKey: map['factoryKey'],
      state: map['state'],
    );
  }

  RouteInformation restoreRouteInformation() {
    return RouteInformation(
      location: location,
      state: state,
    );
  }

  /// Returns the path of the page to be a part of the URL.
  ///
  /// It gets passed to [RouteInformation] as `location` argument.
  /// It may contain query string parameters after '?'.
  String get location => '/';

  /// What pages to show when navigating directly to this configuration's URL.
  PageStackConfiguration get defaultStackConfiguration {
    return PageStackConfiguration(
      pageConfigurations: defaultStackConfigurations,
    );
  }

  /// What pages to show when navigating directly to this configuration's URL.
  List<PageConfiguration> get defaultStackConfigurations => [this];

  String get defaultStackKey => throw UnimplementedError(
        'If you use multiple navigation stacks, each PageConfiguration class '
        'must indicate what stack it prefers to be shown in. '
        'For this, override defaultStackKey getter.',
      );

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
    required super.key,
    required super.factoryKey,
    required super.state,
  });

  @override
  RouteInformation restoreRouteInformation() {
    throw UnimplementedError();
  }
}
