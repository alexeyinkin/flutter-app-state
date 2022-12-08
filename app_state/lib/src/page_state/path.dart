import 'package:flutter/widgets.dart';

import '../page_stack/configuration.dart';
import '../page_stacks/configuration.dart';
import '../pages/abstract.dart';
import 'page_state_mixin.dart';

/// Describes a location within the app, corresponds to location + state.
/// Can be used to navigate to a page recovering its state.
/// Subclass this for your pages' paths.
class PagePath {
  /// The key to compare with to [PAbstractPage.key] to decide if the state
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
  ///      [PPageStateMixin].
  ///   2. To [PPageStateMixin.setStateMap]. Use other parameters there
  ///      to recover further details of the state.
  final Map<String, dynamic> state;

  const PagePath({
    this.key,
    String? factoryKey,
    this.state = const {},
  }) : _factoryKey = factoryKey;

  static List<Map<String, dynamic>?> toJsons(Iterable<PagePath?> pcs) {
    return pcs.map((pc) => pc?.toJson()).toList(growable: false);
  }

  Map<String, dynamic>? toJson() {
    return {
      'key': key,
      'factoryKey': factoryKey,
      'state': state,
    };
  }

  static List<PagePath> fromMaps(List maps) {
    return maps
        .cast<Map<String, dynamic>>()
        .map(PagePath._fromMap)
        .toList(growable: false);
  }

  factory PagePath._fromMap(Map<String, dynamic> map) {
    return PagePath(
      key: map['key'],
      factoryKey: map['factoryKey'],
      state: map['state'],
    );
  }

  /// Returns the path of the page to be a part of the URL.
  ///
  /// It gets passed to [RouteInformation] as `location` argument.
  /// It may contain query string parameters after '?'.
  String get location => '/';

  /// What pages to show when navigating directly to this path.
  PageStackConfiguration get defaultStackConfiguration {
    return PageStackConfiguration(
      paths: defaultStackPaths,
    );
  }

  /// What pages to show when navigating directly to this path.
  List<PagePath> get defaultStackPaths => [this];

  String get defaultStackKey => throw UnimplementedError(
        'If you use multiple navigation stacks, each PagePath class '
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

  /// Parses [location] into a [Uri].
  Uri get uri => Uri.parse(location);

  /// The full [Uri] with schema, domain, port, etc. taken from [baseUri].
  Uri getUriAtBase(Uri baseUri) {
    final uri = this.uri;
    final queryParameters = uri.queryParameters;

    return Uri(
      scheme: baseUri.scheme,
      userInfo: baseUri.userInfo,
      host: baseUri.host,
      port: baseUri.port,
      path: uri.path,
      queryParameters: queryParameters.isEmpty ? null : queryParameters,
    );
  }
}
