import 'package:app_state/app_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late PageBloc sut;

  setUp(() {
    sut = CPageBloc<PageConfiguration, int>();
  });

  test('pop pushes PageBlocCloseEvent', () async {
    PageBlocEvent? received;
    sut.events.listen((PageBlocEvent e) {
      received = e;
    });

    sut.pop(7);
    await Future.delayed(Duration.zero);

    expect(received.runtimeType, PageBlocCloseEvent<int>);
    expect((received! as PageBlocCloseEvent).data, 7);
  });
}
