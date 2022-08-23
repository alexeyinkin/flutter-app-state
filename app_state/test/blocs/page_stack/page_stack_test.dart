import 'dart:async';

import 'package:app_state/app_state.dart';
import 'package:app_state/src/blocs/page_stack/configuration_setters/abstract.dart';
import 'package:app_state/src/blocs/page_stack/configuration_setters/key_or_null_path_no_gap.dart';
import 'package:app_state/src/blocs/page_stack/configuration_setters/none.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../common/common.dart';

void main() {
  group('PageStack.', () {
    test(
        'handleRemoved completes the future, calls didPopNext, '
        'schedules disposal, works with bottomPage too', () async {
      fakeAsync((async) {
        dynamic complete0Result;
        dynamic complete1Result;
        const event0 = PagePopEvent(data: 0, cause: PopCause.page);
        const event1 = PagePopEvent(data: 1, cause: PopCause.page);

        final page0State = mockPageState();
        final page0 = createStatefulPage(page0State);

        final page1State = mockPageState<int>();
        final page1 = createStatefulPage(page1State);

        final stack = PageStack(bottomPage: page0);
        stack.push(page0).then((v) => complete0Result = v);
        stack.push(page1).then((v) => complete1Result = v);

        stack.handleRemoved(page0, page1, event1);
        stack.handleRemoved(null, page0, event0);

        async.elapse(Duration.zero);
        expect(complete0Result, 0);
        expect(complete1Result, 1);
        verify(page0State.didPopNext(page1, event1));
        // ignore: deprecated_member_use_from_same_package
        // verify(page0State.onForegroundClosed(event1));

        // TODO(alexeyinkin): Update when fixed, https://github.com/alexeyinkin/flutter-app-state/issues/4
        async.elapse(const Duration(seconds: 11));

        expect(page0.isDisposed, true);
        expect(page1.isDisposed, true);
      });
    });

    test(
        'popUntilBottom pops pages top to bottom, '
        'with null data and correct cause', () {
      final page0 = AltHomePage();
      final page1 = BooksStatefulPage();
      final page2 = BookPage(id: 1);

      final stack = _PopTestPageStack(bottomPage: page0);
      unawaited(stack.push(page1));
      unawaited(stack.push(page2));

      stack.popUntilBottom();

      expect(stack.pages.length, 1);
      expect(identical(stack.calls[0].page, page2), true);
      expect(stack.calls[0].event.data, null);
      expect(stack.calls[0].event.cause, PopCause.pageStack);
      expect(identical(stack.calls[1].page, page1), true);
      expect(stack.calls[1].event.data, null);
      expect(stack.calls[1].event.cause, PopCause.pageStack);
    });

    test(
        'setConfiguration pops gone pages top to bottom, '
        'with null data and correct cause', () {
      final page0 = AltHomePage();
      final page1 = BooksStatefulPage();
      final page2 = BookPage(id: 1);
      final page3 = BookPage(id: 2);

      final stack = _PopTestPageStack(bottomPage: page0);
      final setter = _PageStackCutter(1, 3);

      unawaited(stack.push(page1));
      unawaited(stack.push(page2));
      unawaited(stack.push(page3));

      stack.setConfiguration(
        const PageStackConfiguration(paths: []),
        setter: setter,
      );

      expect(stack.pages.length, 2);
      expect(identical(stack.calls[0].page, page2), true);
      expect(stack.calls[0].event.data, null);
      expect(stack.calls[0].event.cause, PopCause.diff);
      expect(identical(stack.calls[1].page, page1), true);
      expect(stack.calls[1].event.data, null);
      expect(stack.calls[1].event.cause, PopCause.diff);
    });

    test(
        'setConfiguration throws exception if pages would become empty, '
        'keeps the pages, not disposes them.', () {
      final page0 = AltHomePage();
      final stack = _PopTestPageStack(bottomPage: page0);
      final setter = _PageStackCutter(0, 1);

      expect(
        () => stack.setConfiguration(
          const PageStackConfiguration(paths: []),
          setter: setter,
        ),
        throwsException,
      );

      expect(identical(stack.pages[0], page0), true);
      expect(stack.calls, []);
      expect(page0.isDisposed, false);
    });

    test('replacePath throws without routeInformationParser', () async {
      final stack = PageStack(
        createPage: CommonPageFactory.createPage,
        bottomPage: AltHomePage(),
      );

      expect(() => stack.replacePath(const HomePath()), throwsException);
    });

    test('replacePath uses correct setters', () async {
      final s = _SetConfigurationTestPageStack();

      await s.replacePath(
        const HomePath(),
        mode: PageStackMatchMode.none,
      );
      expect(s.setter, isA<PNonePageStackConfigurationSetter>());

      await s.replacePath(
        const HomePath(),
        mode: PageStackMatchMode.keyOrNullPathNoGap,
      );
      expect(s.setter, isA<PKeyOrNullPathNoGapPageStackConfigurationSetter>());
    });

    test('Creates pages in setConfiguration, listens to their events',
        () async {
      final stack = PageStack(
        bottomPage: AltHomePage(),
        createPage: CommonPageFactory.createPage,
      );
      final events = <PageStackEvent>[];
      stack.events.listen(events.add);

      final configuration = BooksStatefulPath().defaultStackConfiguration;
      const event = TestPageEvent();

      stack.setConfiguration(configuration, mode: PageStackMatchMode.none);
      final page0 = stack.pages[0];
      final page1 = stack.pages[1];
      page1.state?.emitEvent(event);

      await Future.delayed(Duration.zero);
      expect(page0, isA<HomePage>());
      expect(page1, isA<BooksStatefulPage>());
      expect((events.last as PageStackPageEvent).pageEvent, event);
    });

    test('PageStateMixin.pop() on non-bottom calls handleRemoved', () async {
      const data = 7;
      final page0 = HomePage();
      final page1 = BooksStatefulPage();
      final stack = _PopTestPageStack(bottomPage: page0);
      unawaited(stack.push(page1));

      page1.state.pop(7);

      await Future.delayed(Duration.zero);
      expect(stack.calls.length, 1);
      expect(stack.calls[0].event.data, data);
      expect(stack.calls[0].event.cause, PopCause.page);
    });

    test('PageStateMixin.pop() on bottom does not pop', () async {
      final page0 = BooksStatefulPage();
      final stack = _PopTestPageStack(bottomPage: page0);

      page0.state.pop(7);

      await Future.delayed(Duration.zero);
      expect(stack.calls.length, 0);
    });

    group('Back button.', () {
      test('Pops without state', () async {
        final stack = _PopTestPageStack(bottomPage: HomePage());
        final page1 = AltHomePage();
        unawaited(stack.push(page1));

        await stack.onBackPressed();

        expect(stack.calls.length, 1);
        expect(stack.calls[0].page, page1);
        expect(stack.calls[0].event.data, null);
        expect(stack.calls[0].event.cause, PopCause.backButton);
      });

      test('Pops with state if not prevented', () async {
        final stack = _PopTestPageStack(bottomPage: HomePage());
        final page1 = BooksStatefulPage();
        unawaited(stack.push(page1));

        await stack.onBackPressed();

        expect(stack.calls.length, 1);
        expect(stack.calls[0].page, page1);
        expect(stack.calls[0].event.data, null);
        expect(stack.calls[0].event.cause, PopCause.backButton);
      });

      test('Does not pop if prevented', () async {
        final stack = _PopTestPageStack(bottomPage: HomePage());
        final page1 = BooksStatefulPage();
        page1.state.backPressedResult = BackPressedResult.keep;
        unawaited(stack.push(page1));

        await stack.onBackPressed();

        expect(stack.calls.length, 0);
      });
    });
  });
}

class _PopTestPageStack<P extends PagePath> extends PPageStack {
  final calls = <_PopTestPageStackCall>[];

  _PopTestPageStack({required super.bottomPage})
      : super(
          createPage: CommonPageFactory.createPage,
        );

  @override
  void handleRemoved<R>(
    PAbstractPage<PagePath, dynamic>? pageBelow,
    PAbstractPage page,
    PagePopEvent event,
  ) {
    calls.add(_PopTestPageStackCall(pageBelow, page, event));
  }
}

class _PopTestPageStackCall<P extends PagePath> {
  final PAbstractPage<P, dynamic>? pageBelow;
  final PAbstractPage<P, dynamic> page;
  final PagePopEvent event;

  _PopTestPageStackCall(this.pageBelow, this.page, this.event);
}

class _PageStackCutter extends PAbstractPageStackConfigurationSetter {
  final int start;
  final int end;

  _PageStackCutter(this.start, this.end);

  @override
  void set({
    required List<PAbstractPage<PagePath, dynamic>> pages,
    required PageStackConfiguration configuration,
    required void Function(PagePath) createAndPushPage,
  }) {
    pages.removeRange(start, end);
  }
}

class _SetConfigurationTestPageStack extends PageStack {
  PAbstractPageStackConfigurationSetter? setter;

  _SetConfigurationTestPageStack()
      : super(
          bottomPage: HomePage(),
          routeInformationParser: CommonPageStackRouteInformationParser(),
        );

  @override
  void setConfiguration(
    PageStackConfiguration configuration, {
    PageStackMatchMode mode = PageStackMatchMode.keyOrNullPathNoGap,
    PAbstractPageStackConfigurationSetter? setter,
    bool fire = true,
  }) {
    this.setter = setter;
  }
}
