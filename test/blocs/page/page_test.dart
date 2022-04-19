import 'package:app_state/app_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late PageBloc sut;

  setUp(() {
    sut = PageBloc();
  });

  test('closeScreen pushes PageBlocCloseEvent', () async {
    PageBlocEvent? received;
    sut.events.listen((PageBlocEvent e) {
      received = e;
    });

    sut.closeScreen();
    await Future.delayed(Duration.zero);

    expect(received.runtimeType, PageBlocCloseEvent);
  });
}
