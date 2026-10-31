import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:momotaro/main.dart';
import 'package:momotaro/core/model.dart';
import 'package:momotaro/core/routes.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Capture every Pixso screen and verify native interactions', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final model = AppModel(await SharedPreferences.getInstance());
    final key = GlobalKey<NavigatorState>();
    final captureKey = GlobalKey();
    Future<void> capture(String name) async {
      final boundary =
          captureKey.currentContext!.findRenderObject()!
              as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 2);
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      image.dispose();
      binding.reportData ??= {};
      binding.reportData!['screenshots'] ??= <dynamic>[];
      (binding.reportData!['screenshots'] as List).add({
        'screenshotName': name,
        'bytes': data!.buffer.asUint8List().toList(),
      });
    }

    await tester.pumpWidget(
      RepaintBoundary(
        key: captureKey,
        child: MomotaroApp(
          model: model,
          initialScreen: Screen.home,
          navigatorKey: key,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.pumpAndSettle();
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    await Future.wait(
      manifest
          .listAssets()
          .where((path) => path.startsWith('assets/images/'))
          .map((path) => precacheImage(AssetImage(path), key.currentContext!)),
    );
    await tester.pumpAndSettle();
    const longPages = {
      Screen.home,
      Screen.community,
      Screen.profile,
      Screen.explore,
      Screen.podcast,
      Screen.podcastDetails,
      Screen.food,
      Screen.journal,
      Screen.progress,
      Screen.events,
      Screen.eventDetails,
      Screen.weightReminder,
    };
    const captureOnly = String.fromEnvironment('SCREENSHOT_SCREEN');
    for (final screen in Screen.values.where(
      (s) => captureOnly.isEmpty || captureOnly.split(',').contains(s.name),
    )) {
      key.currentState!.pushNamedAndRemoveUntil(screen.path, (_) => false);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: screen.name);
      await capture(screen.name);
      if (longPages.contains(screen)) {
        final scroll = find.byType(SingleChildScrollView).first;
        await tester.drag(scroll, const Offset(0, -1300));
        await tester.pumpAndSettle();
        expect(
          tester.takeException(),
          isNull,
          reason: '${screen.name} scrolled',
        );
        await capture('${screen.name}-more');
      }
    }
    key.currentState!.pushNamedAndRemoveUntil(Screen.water.path, (_) => false);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Add Drink'));
    await tester.tap(find.text('Add Drink'));
    await tester.pumpAndSettle();
    expect(model.water, 950);
    key.currentState!.pushNamedAndRemoveUntil(Screen.poll.path, (_) => false);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Help with weight loss'));
    await tester.pumpAndSettle();
    expect(model.vote, 1);
    key.currentState!.pushNamedAndRemoveUntil(
      Screen.createPost.path,
      (_) => false,
    );
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextField),
      'A fresh start with Momotaro',
    );
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Post'));
    await tester.pumpAndSettle();
    expect(model.posts.first, 'A fresh start with Momotaro');
    expect(tester.takeException(), isNull);
  });
}
