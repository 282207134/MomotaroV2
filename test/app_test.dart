import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:momotaro/main.dart';
import 'package:momotaro/core/model.dart';
import 'package:momotaro/core/routes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    final loader = FontLoader('Rubik')
      ..addFont(rootBundle.load('assets/fonts/Rubik.ttf'));
    await loader.load();
  });
  setUp(() => SharedPreferences.setMockInitialValues({}));
  Future<AppModel> model() async =>
      AppModel(await SharedPreferences.getInstance());
  test(
    'Health entries, selections and posts survive reload; invalid weight is rejected',
    () async {
      final m = await model();
      await m.addWater(400);
      expect(m.water, 1150);
      await m.addWater(-100);
      expect(m.water, 1150);
      expect(await m.updateWeight(double.nan), false);
      expect(await m.updateWeight(8), false);
      expect(await m.updateWeight(56.4), true);
      m.vote = 1;
      m.posts.add('My first walk');
      m.meals.add('Salad');
      m.reminderDays = {0, 3};
      m.sleepTime = '23:15';
      m.completed = true;
      await m.toggleBookmark('breakfast');
      await m.save();
      final restored = await model();
      expect(restored.water, 1150);
      expect(restored.weight, 56.4);
      expect(restored.weightHistory.first, 56.4);
      expect(restored.vote, 1);
      expect(restored.posts, ['My first walk']);
      expect(restored.calories, 845);
      expect(restored.reminderDays, {0, 3});
      expect(restored.sleepTime, '23:15');
      expect(restored.completed, true);
      expect(restored.bookmarks, {'breakfast'});
    },
  );
  test('Malformed saved JSON falls back to a usable sample profile', () async {
    final p = await SharedPreferences.getInstance();
    await p.setString('momotaro.v1', 'not-json');
    final m = AppModel(p);
    expect(m.water, 750);
    expect(m.name, 'Grace Saraswati');
  });
  for (final size in [const Size(375, 812), const Size(320, 640)]) {
    testWidgets(
      'All 43 routes render without errors at ${size.width.toInt()} px',
      (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final m = await model();
        final failures = <String>[];
        for (final s in Screen.values) {
          await tester.pumpWidget(
            MomotaroApp(key: UniqueKey(), model: m, initialScreen: s),
          );
          await tester.pumpAndSettle();
          final error = tester.takeException();
          if (error != null) failures.add('${s.name}: $error');
        }
        await tester.pumpWidget(const SizedBox());
        expect(failures, isEmpty, reason: failures.join("\n"));
      },
    );
  }
  testWidgets('Drink action updates the total and persists it', (tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final m = await model();
    await tester.pumpWidget(MomotaroApp(model: m, initialScreen: Screen.water));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Add Drink'));
    await tester.tap(find.text('Add Drink'));
    await tester.pumpAndSettle();
    expect(m.water, 950);
    expect((await model()).water, 950);
    expect(find.textContaining('950 ml of water'), findsOneWidget);
  });
  testWidgets(
    'Phone verification rejects a wrong code and accepts the issued code',
    (tester) async {
      final m = await model();
      await tester.pumpWidget(
        MomotaroApp(model: m, initialScreen: Screen.verification),
      );
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), '0000');
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      expect(
        find.text('Please enter the 4-digit code sent to you'),
        findsOneWidget,
      );
      await tester.enterText(find.byType(TextField), '2828');
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      expect(find.text('Set your password'), findsOneWidget);
    },
  );
  testWidgets(
    'Quick actions and the complete page gallery work on a small screen',
    (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final m = await model();
      await tester.pumpWidget(
        MomotaroApp(model: m, initialScreen: Screen.home),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Quick actions'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.tap(find.text('All pages'));
      await tester.pumpAndSettle();
      expect(find.text('Explore Momotaro'), findsOneWidget);
      await tester.ensureVisible(find.text('Hydration'));
      await tester.tap(find.text('Hydration'));
      await tester.pumpAndSettle();
      expect(find.textContaining('750 ml of water'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
