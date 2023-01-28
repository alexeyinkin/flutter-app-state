/// A routing library and state management solution on top of Router
/// API for larger apps.
///
/// Instead of routes or widgets, in the core there is a stack of stateful
/// objects (Blocs, ChangeNotifiers, or anything else, collectively
/// referred to as page states as opposed to widget states).
/// This package translates navigation intents to operations on those.
/// The page states are then wrapped into widgets to form the navigator's stack.
/// This simplifies state management: no need for providers, stateful widgets,
/// manual bloc creation and disposal, or BuildContext.
library app_state;

export 'src/models/back_pressed_result_enum.dart';

export 'src/page_stack/back_button_dispatcher.dart';
export 'src/page_stack/configuration.dart';
export 'src/page_stack/duplicate_page_key_action.dart';
export 'src/page_stack/event.dart';
export 'src/page_stack/match_mode.dart';
export 'src/page_stack/page_event.dart';
export 'src/page_stack/page_stack.dart';
export 'src/page_stack/route_information_parser.dart';
export 'src/page_stack/router_delegate.dart';

export 'src/page_stacks/back_button_dispatcher.dart';
export 'src/page_stacks/configuration.dart';
export 'src/page_stacks/current_page_stack_changed_event.dart';
export 'src/page_stacks/event.dart';
export 'src/page_stacks/material_router_delegate.dart';
export 'src/page_stacks/page_stack_event.dart';
export 'src/page_stacks/page_stacks.dart';
export 'src/page_stacks/route_information_parser.dart';
export 'src/page_stacks/router_delegate.dart';

export 'src/page_state/event.dart';
export 'src/page_state/page_state.dart';
export 'src/page_state/page_state_mixin.dart';
export 'src/page_state/path.dart';
export 'src/page_state/path_changed_event.dart';
export 'src/page_state/pop_cause.dart';
export 'src/page_state/pop_event.dart';
export 'src/page_state/stateful_bloc.dart';

export 'src/pages/abstract.dart';
export 'src/pages/material.dart';
export 'src/pages/stateful_material.dart';
export 'src/pages/stateless_material.dart';

export 'src/widgets/navigator.dart';
export 'src/widgets/page_stacks_builder.dart';
export 'src/widgets/single_entry_overlay.dart';
export 'src/widgets/stateful_bloc_widget.dart';
