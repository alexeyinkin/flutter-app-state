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
  group('PageStackBloc.', () {
    test(
        'handleRemoved completes the future, calls didPopNext, '
        'schedules disposal, works with bottomPage too', () async {
      fakeAsync((async) {
        dynamic complete0Result;
        dynamic complete1Result;
        const event0 = PageBlocPopEvent(data: 0, cause: PopCause.pageBloc);
        const event1 = PageBlocPopEvent(data: 1, cause: PopCause.pageBloc);

        final page0Bloc = mockPageBloc();
        final page0 = createBlocPage(page0Bloc);

        final page1Bloc = mockPageBloc<int>();
        final page1 = createBlocPage(page1Bloc);

        final bloc = PageStackBloc(bottomPage: page0);
        bloc.push(page0).then((v) => complete0Result = v);
        bloc.push(page1).then((v) => complete1Result = v);

        bloc.handleRemoved(page0, page1, event1);
        bloc.handleRemoved(null, page0, event0);

        async.elapse(Duration.zero);
        expect(complete0Result, 0);
        expect(complete1Result, 1);
        verify(page0Bloc.didPopNext(page1, event1));
        // ignore: deprecated_member_use_from_same_package
        verify(page0Bloc.onForegroundClosed(event1));

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

      final bloc = _PopTestPageStackBloc(bottomPage: page0);
      unawaited(bloc.push(page1));
      unawaited(bloc.push(page2));

      bloc.popUntilBottom();

      expect(bloc.pages.length, 1);
      expect(identical(bloc.calls[0].page, page2), true);
      expect(bloc.calls[0].event.data, null);
      expect(bloc.calls[0].event.cause, PopCause.pageStackBloc);
      expect(identical(bloc.calls[1].page, page1), true);
      expect(bloc.calls[1].event.data, null);
      expect(bloc.calls[1].event.cause, PopCause.pageStackBloc);
    });

    test(
        'setConfiguration pops gone pages top to bottom, '
        'with null data and correct cause', () {
      final page0 = AltHomePage();
      final page1 = BooksStatefulPage();
      final page2 = BookPage(id: 1);
      final page3 = BookPage(id: 2);

      final bloc = _PopTestPageStackBloc(bottomPage: page0);
      final setter = _PageStackCutter(1, 3);

      unawaited(bloc.push(page1));
      unawaited(bloc.push(page2));
      unawaited(bloc.push(page3));

      bloc.setConfiguration(
        const PageStackConfiguration(paths: []),
        setter: setter,
      );

      expect(bloc.pages.length, 2);
      expect(identical(bloc.calls[0].page, page2), true);
      expect(bloc.calls[0].event.data, null);
      expect(bloc.calls[0].event.cause, PopCause.diff);
      expect(identical(bloc.calls[1].page, page1), true);
      expect(bloc.calls[1].event.data, null);
      expect(bloc.calls[1].event.cause, PopCause.diff);
    });

    test(
        'setConfiguration throws exception if pages would become empty, '
        'keeps the pages, not disposes them.', () {
      final page0 = AltHomePage();
      final bloc = _PopTestPageStackBloc(bottomPage: page0);
      final setter = _PageStackCutter(0, 1);

      expect(
        () => bloc.setConfiguration(
          const PageStackConfiguration(paths: []),
          setter: setter,
        ),
        throwsException,
      );

      expect(identical(bloc.pages[0], page0), true);
      expect(bloc.calls, []);
      expect(page0.isDisposed, false);
    });

    test('replacePath throws without routeInformationParser', () async {
      final bloc = PageStackBloc(
        createPage: CommonPageFactory.createPage,
        bottomPage: AltHomePage(),
      );

      expect(() => bloc.replacePath(const HomePath()), throwsException);
    });

    test('replacePath uses correct setters', () async {
      final b = _SetConfigurationWithTestPageStackBloc();

      await b.replacePath(
        const HomePath(),
        mode: PageStackMatchMode.none,
      );
      expect(b.setter, isA<CNonePageStackConfigurationSetter>());

      await b.replacePath(
        const HomePath(),
        mode: PageStackMatchMode.keyOrNullPathNoGap,
      );
      expect(b.setter, isA<CKeyOrNullPathNoGapPageStackConfigurationSetter>());
    });

    test('Creates pages in setConfiguration, listens to their events',
        () async {
      final bloc = PageStackBloc(
        bottomPage: AltHomePage(),
        createPage: CommonPageFactory.createPage,
      );
      final events = <PageStackBlocEvent>[];
      bloc.events.listen(events.add);

      final configuration = BooksStatefulPath().defaultStackConfiguration;
      const event = TestPageBlocEvent();

      bloc.setConfiguration(configuration, mode: PageStackMatchMode.none);
      final page0 = bloc.pages[0];
      final page1 = bloc.pages[1];
      page1.bloc?.emitEvent(event);

      await Future.delayed(Duration.zero);
      expect(page0, isA<HomePage>());
      expect(page1, isA<BooksStatefulPage>());
      expect((events.last as PageStackPageBlocEvent).pageBlocEvent, event);
    });

    test('PageBloc.pop() on non-bottom calls handleRemoved', () async {
      const data = 7;
      final page0 = HomePage();
      final page1 = BooksStatefulPage();
      final bloc = _PopTestPageStackBloc(bottomPage: page0);
      unawaited(bloc.push(page1));

      page1.bloc.pop(7);

      await Future.delayed(Duration.zero);
      expect(bloc.calls.length, 1);
      expect(bloc.calls[0].event.data, data);
      expect(bloc.calls[0].event.cause, PopCause.pageBloc);
    });

    test('PageBloc.pop() on bottom does not pop', () async {
      final page0 = BooksStatefulPage();
      final bloc = _PopTestPageStackBloc(bottomPage: page0);

      page0.bloc.pop(7);

      await Future.delayed(Duration.zero);
      expect(bloc.calls.length, 0);
    });

    group('Back button.', () {
      test('Pops without bloc', () async {
        final bloc = _PopTestPageStackBloc(bottomPage: HomePage());
        final page1 = AltHomePage();
        unawaited(bloc.push(page1));

        await bloc.onBackPressed();

        expect(bloc.calls.length, 1);
        expect(bloc.calls[0].page, page1);
        expect(bloc.calls[0].event.data, null);
        expect(bloc.calls[0].event.cause, PopCause.backButton);
      });

      test('Pops with bloc if not prevented', () async {
        final bloc = _PopTestPageStackBloc(bottomPage: HomePage());
        final page1 = BooksStatefulPage();
        unawaited(bloc.push(page1));

        await bloc.onBackPressed();

        expect(bloc.calls.length, 1);
        expect(bloc.calls[0].page, page1);
        expect(bloc.calls[0].event.data, null);
        expect(bloc.calls[0].event.cause, PopCause.backButton);
      });

      test('Does not pop if prevented', () async {
        final bloc = _PopTestPageStackBloc(bottomPage: HomePage());
        final page1 = BooksStatefulPage();
        page1.bloc.backPressedResult = BackPressedResult.keep;
        unawaited(bloc.push(page1));

        await bloc.onBackPressed();

        expect(bloc.calls.length, 0);
      });
    });
  });
}

class _PopTestPageStackBloc<P extends PagePath> extends CPageStackBloc {
  final calls = <_PopTestPageStackBlocCall>[];

  _PopTestPageStackBloc({required super.bottomPage})
      : super(
          createPage: CommonPageFactory.createPage,
        );

  @override
  void handleRemoved<R>(
    CAbstractPage<PagePath, dynamic>? pageBelow,
    CAbstractPage page,
    PageBlocPopEvent event,
  ) {
    calls.add(_PopTestPageStackBlocCall(pageBelow, page, event));
  }
}

class _PopTestPageStackBlocCall<P extends PagePath> {
  final CAbstractPage<P, dynamic>? pageBelow;
  final CAbstractPage<P, dynamic> page;
  final PageBlocPopEvent event;

  _PopTestPageStackBlocCall(this.pageBelow, this.page, this.event);
}

class _PageStackCutter extends CAbstractPageStackConfigurationSetter {
  final int start;
  final int end;

  _PageStackCutter(this.start, this.end);

  @override
  void set({
    required List<CAbstractPage<PagePath, dynamic>> pages,
    required PageStackConfiguration configuration,
    required void Function(PagePath) createAndPushPage,
  }) {
    pages.removeRange(start, end);
  }
}

class _SetConfigurationWithTestPageStackBloc extends PageStackBloc {
  CAbstractPageStackConfigurationSetter? setter;

  _SetConfigurationWithTestPageStackBloc()
      : super(
          bottomPage: HomePage(),
          routeInformationParser: CommonPageStackRouteInformationParser(),
        );

  @override
  void setConfiguration(
    PageStackConfiguration configuration, {
    PageStackMatchMode mode = PageStackMatchMode.keyOrNullPathNoGap,
    CAbstractPageStackConfigurationSetter? setter,
    bool fire = true,
  }) {
    this.setter = setter;
  }
}
