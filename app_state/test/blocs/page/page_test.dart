import 'package:app_state/app_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late PPageState sut;

  setUp(() {
    sut = PPageState<PagePath, int>();
  });

  test('pop pushes PagePopEvent', () async {
    PageEvent? received;
    sut.events.listen((PageEvent e) {
      received = e;
    });

    sut.pop(7);
    await Future.delayed(Duration.zero);

    expect(received.runtimeType, PagePopEvent<int>);
    expect((received! as PagePopEvent).data, 7);
  });
}
