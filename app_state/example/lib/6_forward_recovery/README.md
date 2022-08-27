## 6_forward_recovery

![Recovering Unsaved Input on Back and Forward Navigation](https://raw.githubusercontent.com/alexeyinkin/flutter-app-state/main/img/recovering-unsaved-input.gif)

**Use case:** In a multi-screen app, the user enters some text,
then closes the screen without saving by 'Back' button.
They then click 'Forward' and expect their input is still there.

This could be done in many ways:

- A state object behind the scene.
  The input window should store changes there and get them when re-initializing.
  But that is complex. What if we have many URLs like `/input/something`
  all handled by the same screen? It's too much work to pick the right preserved input.
- A database or local storage. Even more work.

A better way is to just use the browser History API to attach hidden information to the URL itself.
`app_state` wraps it for you.

Home screen is stateless and is of no interest.

`InputState` and `InputPath` are where the magic happens.

`InputState` contains the text editing controller.
On every change, it emits the new `InputPath` object with `text` in it:

```dart
class InputState with PageStateMixin {
  final controller = TextEditingController();

  InputState() {
    controller.addListener(emitPathChanged);
  }

  @override
  InputPath get path => InputPath(
        text: controller.text,
      );

  @override
  void setStateMap(Map<String, dynamic> state) {
    controller.text = state['text'] ?? '';
  }
}
```

The `text` is not a part of the visible page path but it is attached to it
in the browser history accompanying the current URL.
`InputPath` class puts this `text` into the `state` map that is actually stored:

```dart
class InputPath extends PagePath {
  static const _location = '/input';

  final String text;

  InputPath({
    required this.text,
  }) : super(
          key: 'Input',
          factoryKey: InputPage.classFactoryKey,
          state: {'text': text},
        );

  @override
  get location => _location;

  static InputPath? tryParse(RouteInformation ri) {
    return ri.location == _location ? InputPath(text: '') : null;
  }

  @override
  List<PagePath> get defaultStackPaths => [
        const HomePath(),
        this,
      ];
}
```

When the user clicks 'Back', the page and the state are removed from the stack and disposed.

Then on 'Forward' click, `tryParse` method is called (as on any other navigation).
If the URL matches `/input`, Flutter checks if the state was previously stored for this URL.
If it was, app_state's `PageStackRouteInformationParser` detects this
and does not even try to parse the URL.
Instead it recovers everything from that stored map.

So if `tryParse` is called in `InputPath`, the `RouteInformation.state` is definitely empty,
so we create an object with empty text.

Then `InputState` gets created, and `setStateMap` is called on it.
If anything was recovered from browser history, it is passed there.
This way the `text` is back to the controller.

If we had many routes like `/input/something` handled by a single screen,
a history entry for each one would store its text independently.

Other things to store and recover like that:

- Scrolling position in tall screens
  (add the `ScrollController` to your state class, listen to changes).
- Text selection (store the whole `TextEditingValue` and not only the `text`).
