import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/model.dart';
import 'core/routes.dart';
import 'core/theme.dart';
import 'core/widgets.dart';
import 'features/content.dart';
import 'features/health.dart';
import 'features/onboarding.dart';
import 'features/social.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final model = AppModel(await SharedPreferences.getInstance());
  runApp(MomotaroApp(model: model));
}

class MomotaroApp extends StatelessWidget {
  const MomotaroApp({
    super.key,
    required this.model,
    this.initialScreen,
    this.navigatorKey,
  });
  final AppModel model;
  final Screen? initialScreen;
  final GlobalKey<NavigatorState>? navigatorKey;
  @override
  Widget build(BuildContext context) => AppScope(
    model: model,
    child: MaterialApp(
      title: 'Momotaro',
      debugShowCheckedModeBanner: false,
      theme: appTheme(),
      navigatorKey: navigatorKey,
      initialRoute:
          (initialScreen ?? (model.completed ? Screen.home : Screen.welcome))
              .path,
      onGenerateRoute: (settings) {
        final s = Screen.fromPath(settings.name);
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => AppShell(screen: s),
        );
      },
    ),
  );
}

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.screen});
  final Screen screen;
  @override
  Widget build(BuildContext context) {
    final light = {
      Screen.player,
      Screen.success,
      Screen.feedback,
      Screen.feedbackDetails,
      Screen.progress,
    }.contains(screen);
    final page = switch (screen) {
      Screen.home ||
      Screen.steps ||
      Screen.insight ||
      Screen.water ||
      Screen.nutrition ||
      Screen.journal ||
      Screen.recipe ||
      Screen.food ||
      Screen.progress ||
      Screen.sleepReminder ||
      Screen.weightReminder => HealthPage(screen),
      Screen.welcome ||
      Screen.mobile ||
      Screen.verification ||
      Screen.password ||
      Screen.fingerprint ||
      Screen.photo ||
      Screen.interest ||
      Screen.goal ||
      Screen.gender ||
      Screen.fitness ||
      Screen.weight ||
      Screen.permission ||
      Screen.success => OnboardingPage(screen),
      Screen.explore ||
      Screen.tips ||
      Screen.podcast ||
      Screen.podcastDetails ||
      Screen.player ||
      Screen.playlist ||
      Screen.challenge ||
      Screen.events ||
      Screen.eventDetails => ContentPage(screen),
      _ => SocialPage(screen),
    };
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: light ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: ColoredBox(
        color: Palette.cloud,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Scaffold(
              body: page,
              bottomNavigationBar: screen.hasNavigation
                  ? BottomBar(screen)
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}

class BottomBar extends StatelessWidget {
  const BottomBar(this.screen, {super.key});
  final Screen screen;
  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      boxShadow: [
        BoxShadow(
          color: Color(0x0E4C5980),
          blurRadius: 25,
          offset: Offset(0, -6),
        ),
      ],
    ),
    child: SafeArea(
      top: false,
      child: SizedBox(
        height: 74,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            item(context, Screen.home, Icons.home_rounded),
            item(context, Screen.podcast, Icons.mic_none_rounded),
            Transform.translate(
              offset: const Offset(0, -13),
              child: SizedBox(
                width: 60,
                height: 60,
                child: FloatingActionButton(
                  heroTag: null,
                  tooltip: 'Quick actions',
                  elevation: 5,
                  backgroundColor: Palette.purple,
                  foregroundColor: Colors.white,
                  shape: const CircleBorder(),
                  onPressed: () => quickActions(context),
                  child: const Icon(Icons.add_rounded, size: 30),
                ),
              ),
            ),
            item(context, Screen.community, Icons.format_list_bulleted_rounded),
            item(context, Screen.profile, Icons.person_rounded),
          ],
        ),
      ),
    ),
  );
  Widget item(BuildContext context, Screen target, IconData icon) => IconButton(
    tooltip: target.title,
    onPressed: () =>
        Navigator.pushNamedAndRemoveUntil(context, target.path, (_) => false),
    icon: Icon(
      icon,
      color: screen == target ? Palette.ink : const Color(0xFFD7D9E2),
      size: 25,
    ),
  );
}

void quickActions(BuildContext context) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  backgroundColor: Colors.white,
  builder: (c) => SafeArea(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(26, 0, 26, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Txt('Make time for you', size: 25, weight: FontWeight.w500),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children:
                [
                      (Screen.water, Icons.water_drop_rounded),
                      (Screen.recipe, Icons.restaurant_rounded),
                      (Screen.progress, Icons.monitor_weight_rounded),
                      (Screen.explore, Icons.explore_rounded),
                      (Screen.challenge, Icons.directions_run_rounded),
                      (Screen.events, Icons.event_rounded),
                      (Screen.createPost, Icons.edit_rounded),
                      (Screen.sleepReminder, Icons.nights_stay_rounded),
                    ]
                    .map(
                      (a) => SizedBox(
                        width:
                            (MediaQuery.sizeOf(c).width.clamp(0, 520) - 88) / 4,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(c);
                            open(context, a.$1);
                          },
                          child: Column(
                            children: [
                              IconTile(
                                a.$2,
                                size: 50,
                                color: a.$1 == Screen.water
                                    ? Palette.blue
                                    : Palette.lavender,
                              ),
                              const SizedBox(height: 7),
                              Txt(
                                a.$1.title,
                                size: 10,
                                center: true,
                                maxLines: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),
          const SizedBox(height: 22),
          const Divider(height: 1),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.grid_view_rounded, color: Palette.purple),
            title: const Text('All pages'),
            subtitle: const Text('Browse your wellness companion'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {
              Navigator.pop(c);
              showPageGallery(context);
            },
          ),
        ],
      ),
    ),
  ),
);

void showPageGallery(BuildContext context) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (c) => SafeArea(
    child: SizedBox(
      height: MediaQuery.sizeOf(c).height * .8,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(18),
            child: Txt('Explore Momotaro', size: 25, weight: FontWeight.w500),
          ),
          Expanded(
            child: ListView(
              children: [
                for (final group in <String, List<Screen>>{
                  'Daily health': [
                    Screen.home,
                    Screen.steps,
                    Screen.insight,
                    Screen.water,
                    Screen.nutrition,
                    Screen.journal,
                    Screen.recipe,
                    Screen.food,
                    Screen.progress,
                    Screen.sleepReminder,
                    Screen.weightReminder,
                  ],
                  'Discover': [
                    Screen.explore,
                    Screen.tips,
                    Screen.podcast,
                    Screen.podcastDetails,
                    Screen.player,
                    Screen.playlist,
                    Screen.challenge,
                    Screen.events,
                    Screen.eventDetails,
                  ],
                  'Community & you': [
                    Screen.community,
                    Screen.createPost,
                    Screen.poll,
                    Screen.share,
                    Screen.profile,
                    Screen.premium,
                    Screen.notifications,
                    Screen.invite,
                    Screen.feedback,
                    Screen.feedbackDetails,
                  ],
                  'Get started': [
                    Screen.welcome,
                    ...onboardingSteps,
                    Screen.success,
                  ],
                }.entries) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
                    child: Label(group.key),
                  ),
                  for (final s in group.value)
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 24,
                      ),
                      title: Txt(s.title),
                      subtitle: Txt(s.label, size: 11, color: Palette.muted),
                      trailing: const Icon(
                        Icons.chevron_right_rounded,
                        color: Palette.muted,
                      ),
                      onTap: () {
                        Navigator.pop(c);
                        open(context, s);
                      },
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    ),
  ),
);
