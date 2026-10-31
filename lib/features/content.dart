import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/routes.dart';
import '../core/theme.dart';
import '../core/widgets.dart';

class ContentPage extends StatefulWidget {
  const ContentPage(this.screen, {super.key});
  final Screen screen;
  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  String query = '', topic = 'All';
  bool following = false, offline = true, playing = false;
  int position = 275, selectedDay = 3;
  Timer? timer;
  @override
  void initState() {
    super.initState();
    if (widget.screen == Screen.player) {
      timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (playing && mounted) {
          setState(() => position = (position + 1).clamp(0, 900));
        }
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => switch (widget.screen) {
    Screen.explore => explore(),
    Screen.podcast => podcast(),
    Screen.podcastDetails => podcastDetails(),
    Screen.player => player(),
    Screen.playlist => playlist(),
    Screen.challenge => challenge(),
    Screen.events => events(),
    Screen.eventDetails => eventDetails(),
    Screen.tips => tips(),
    _ => const SizedBox.shrink(),
  };
  Widget explore() => PageLayout(
    color: Palette.cloud,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Txt('Explore', size: 32, weight: FontWeight.w500),
        const SizedBox(height: 20),
        TextField(
          decoration: const InputDecoration(
            hintText: 'Search topic',
            prefixIcon: Icon(Icons.search_rounded),
            fillColor: Colors.white,
          ),
          onChanged: (v) => setState(() => query = v),
        ),
        const SizedBox(height: 22),
        Panel(
          padding: 0,
          shadow: true,
          onTap: () => open(context, Screen.tips),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Picture(
                'outdoor',
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                radius: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Txt(
                      '20-minutes Outdoor Can Make You Less Stress',
                      size: 18,
                      weight: FontWeight.w500,
                    ),
                    Entry(
                      'Jimmy Abrahamson',
                      '',
                      leading: const Avatar(size: 24),
                      trailing: const BookmarkButton('outdoor'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SectionTitle(
          'Topics For You',
          action: () => open(context, Screen.interest),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final t in [
                ('✨', 'All'),
                ('🍉', 'Nutrition'),
                ('🌾', 'Organic'),
                ('🍃', 'Meditation'),
                ('🛏', 'Sleep'),
              ])
                Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: InkWell(
                    onTap: () => setState(() => topic = t.$2),
                    child: Column(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: topic == t.$2 ? Palette.pale : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            t.$1,
                            style: const TextStyle(fontSize: 28),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Txt(t.$2, size: 11),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SectionTitle('Get Inspired'),
        for (final a in [
          ('7 Nutrition Tips to Lose Weight Faster', 'snacks', 'Nutrition'),
          ('Proven Tips to Sleep Better at Night', 'bedtime', 'Sleep'),
          ('10 Ways to Stay Motivated at Gym', 'workout', 'Fitness'),
        ])
          if (a.$1.toLowerCase().contains(query.toLowerCase()) &&
              (topic == 'All' || a.$3 == topic || topic == 'Organic'))
            Entry(
              a.$1,
              a.$3,
              leading: Picture(
                a.$2,
                width: 60,
                height: 60,
                radius: 18,
                fit: BoxFit.cover,
              ),
              trailing: BookmarkButton(a.$1),
              onTap: () =>
                  open(context, a.$3 == 'Sleep' ? Screen.tips : Screen.recipe),
            ),
        const SectionTitle('Collection'),
        Row(
          children: [
            Expanded(
              child: collection(
                'How to Be a Better Runner',
                'runner',
                'HEALTH',
                Screen.challenge,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: collection(
                'Healthy Snacks Idea',
                'snacks',
                'NUTRITION',
                Screen.recipe,
              ),
            ),
          ],
        ),
      ],
    ),
  );
  Widget collection(
    String title,
    String image,
    String category,
    Screen target,
  ) => InkWell(
    onTap: () => open(context, target),
    child: Container(
      height: 230,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: Palette.lilac,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Picture(image, fit: BoxFit.cover),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x15000000), Color(0xAA4C315D)],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(17),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Label(category, color: Colors.white),
                const SizedBox(height: 12),
                Txt(
                  title,
                  size: 18,
                  color: Colors.white,
                  weight: FontWeight.w500,
                ),
                const Spacer(),
                const Pill('8 articles'),
              ],
            ),
          ),
        ],
      ),
    ),
  );
  Widget dailyPick() => Panel(
    color: Palette.lavender,
    onTap: () => open(context, Screen.podcastDetails),
    child: Column(
      children: [
        const Align(
          alignment: Alignment.topLeft,
          child: Picture('bedtime', height: 95),
        ),
        const Label('Daily pick', color: Palette.mint),
        const SizedBox(height: 14),
        const Txt(
          'Sleep With Me\nBedtime Stories',
          size: 25,
          center: true,
          color: Colors.white,
          weight: FontWeight.w500,
        ),
        const SizedBox(height: 14),
        const Txt(
          'Train your mind for a happier, healthier life',
          center: true,
          color: Colors.white,
        ),
        const SizedBox(height: 24),
        PrimaryButton(
          'Let’s Start',
          icon: Icons.play_arrow_rounded,
          onPressed: () => open(context, Screen.podcastDetails),
        ),
      ],
    ),
  );
  Widget podcast() => PageLayout(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Txt('Podcast', size: 32, weight: FontWeight.w500),
        const SizedBox(height: 22),
        dailyPick(),
        const SectionTitle('Wellness'),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: .85,
          children:
              [
                    ('Living Beyond Fear', 'pod-fear'),
                    ('The Twilight Zone', 'pod-twilight'),
                    ('Retrain Your Brain', 'pod-brain'),
                    ('A Meditation Lullaby', 'pod-lullaby'),
                  ]
                  .map(
                    (p) => InkWell(
                      onTap: () => open(context, Screen.podcastDetails),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Picture(
                              p.$2,
                              width: double.infinity,
                              radius: 18,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Txt(
                            p.$1,
                            size: 13,
                            weight: FontWeight.w500,
                            maxLines: 1,
                          ),
                          const Txt(
                            '15 minutes',
                            size: 11,
                            color: Palette.muted,
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
        ),
        const SizedBox(height: 28),
        Panel(
          color: Palette.blue,
          child: Column(
            children: [
              const Label('Go premium', color: Palette.mint),
              const SizedBox(height: 12),
              const Txt(
                'Time to unlock full library',
                size: 22,
                center: true,
                color: Colors.white,
                weight: FontWeight.w500,
              ),
              const SizedBox(height: 22),
              PrimaryButton(
                'Go Premium',
                white: true,
                onPressed: () => open(context, Screen.premium),
              ),
            ],
          ),
        ),
      ],
    ),
  );
  Widget podcastDetails() => PageLayout(
    action: IconButton(
      tooltip: 'Share playlist',
      onPressed: () => open(context, Screen.playlist),
      icon: const Icon(Icons.ios_share_rounded),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Label('Wellness'),
        const SizedBox(height: 12),
        const Txt(
          'Sleep With Me\nBedtime Stories',
          size: 30,
          weight: FontWeight.w500,
        ),
        Entry(
          'by Joseph Fink',
          '',
          leading: const Avatar(size: 30),
          trailing: Pill(
            following ? 'Following' : 'Follow',
            selected: following,
            onTap: () => setState(() => following = !following),
          ),
        ),
        const SizedBox(height: 16),
        Panel(
          color: Palette.lavender,
          child: const Picture('bedtime', height: 185, width: double.infinity),
        ),
        const SizedBox(height: 20),
        const Txt(
          'Train your mind for a happier, healthier life by learning the fundamentals of meditation and mindfulness.',
          color: Palette.slate,
        ),
        const SizedBox(height: 20),
        Panel(
          color: Palette.cloud,
          padding: 6,
          child: SwitchListTile(
            title: const Txt(
              'Offline download',
              size: 13,
              weight: FontWeight.w500,
            ),
            subtitle: const Txt('100 mb', size: 11, color: Palette.muted),
            value: offline,
            onChanged: (v) {
              setState(() => offline = v);
              toast(
                context,
                v ? 'Offline preference saved' : 'Offline preference removed',
              );
            },
          ),
        ),
        const SectionTitle('4 Sessions'),
        for (var i = 0; i < 4; i++)
          Entry(
            i % 2 == 0 ? 'Train Whistle At Night' : 'The Twilight Zone',
            i < 2 ? '${i == 0 ? 15 : 30} mins • Free' : 'Locked',
            leading: IconTile(
              i < 2 ? Icons.play_arrow_rounded : Icons.lock_outline_rounded,
              color: i < 2 ? Palette.lavender : Palette.muted,
            ),
            onTap: () => open(context, i < 2 ? Screen.player : Screen.premium),
          ),
        const SizedBox(height: 25),
        Panel(
          color: Palette.pale,
          child: Column(
            children: [
              const Txt('Rate & review', size: 18, weight: FontWeight.w500),
              const Txt(
                'Share your experience to help others',
                size: 12,
                color: Palette.muted,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (i) => IconButton(
                    tooltip: 'Rate ${i + 1} stars',
                    constraints: const BoxConstraints(
                      minWidth: 36,
                      minHeight: 40,
                    ),
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    onPressed: () => toast(
                      context,
                      'Thank you for your ${i + 1}-star review',
                    ),
                    icon: Icon(
                      i < 3 ? Icons.star_rounded : Icons.star_border_rounded,
                      color: Palette.purple,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SectionTitle('4.7 ★  (28 Reviews)'),
        for (final r in [
          (
            'Marie Smith',
            '👍 I try other meditation podcasts and always come back to this. Beautifully arranged and spoken.',
          ),
          (
            'Jack Snow',
            'I use this most every morning to get me moving with whatever may be on my mind 🤩',
          ),
        ])
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Entry(
                r.$1,
                '1 mo ago',
                leading: const Avatar(size: 32),
                trailing: const Pill('★ 5.0'),
              ),
              Txt(r.$2, size: 13, color: Palette.slate),
              const Divider(),
            ],
          ),
      ],
    ),
  );
  Widget player() => PageLayout(
    color: Palette.lavender,
    light: true,
    action: IconButton(
      tooltip: 'Share session',
      onPressed: () => open(context, Screen.playlist),
      icon: const Icon(Icons.more_horiz_rounded, color: Colors.white),
    ),
    child: Column(
      children: [
        const SizedBox(height: 48),
        const Txt(
          'Welcome to Night\nVale Story',
          size: 28,
          center: true,
          color: Colors.white,
          weight: FontWeight.w500,
        ),
        const SizedBox(height: 65),
        Ring(
          size: 220,
          value: position / 900,
          color: Palette.mint,
          stroke: 12,
          child: Container(
            width: 165,
            height: 165,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              tooltip: playing ? 'Pause' : 'Play',
              onPressed: () => setState(() => playing = !playing),
              icon: Icon(
                playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                color: Palette.purple,
                size: 60,
              ),
            ),
          ),
        ),
        const SizedBox(height: 22),
        Txt(
          '${position ~/ 60} : ${(position % 60).toString().padLeft(2, '0')}',
          size: 18,
          color: Colors.white,
        ),
        Slider(
          value: position.toDouble(),
          max: 900,
          activeColor: Palette.mint,
          inactiveColor: Palette.pale.withValues(alpha: .3),
          onChanged: (v) => setState(() => position = v.toInt()),
        ),
        const SizedBox(height: 40),
        Panel(
          child: Entry(
            'Next : Sleep Reflection',
            '15 minutes',
            leading: const IconTile(Icons.play_arrow_rounded),
            onTap: () => setState(() {
              position = 0;
              playing = true;
            }),
          ),
        ),
      ],
    ),
  );
  Widget playlist() => PageLayout(
    action: IconButton(
      tooltip: 'Copy playlist',
      onPressed: () => copyShare(
        'Sleep With Me — Mindfulness of Breath, A Meditation Lullaby, The Twilight Zone',
      ),
      icon: const Icon(Icons.ios_share_rounded, color: Palette.purple),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Txt('Let’s share', size: 32, weight: FontWeight.w500),
        const SizedBox(height: 24),
        Panel(
          color: Palette.cloud,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Picture('bedtime', height: 190, width: double.infinity),
              const SizedBox(height: 20),
              const Label('Wellness'),
              const SizedBox(height: 10),
              const Txt(
                'Sleep With Me\nBedtime Stories',
                size: 24,
                weight: FontWeight.w500,
              ),
              const SizedBox(height: 20),
              for (final p in [
                (1, 'Mindfulness of Breath', '10 mins'),
                (2, 'A Meditation Lullaby', '5 mins'),
                (3, 'The Twilight Zone', '10 mins'),
              ])
                Entry(
                  p.$2,
                  p.$3,
                  leading: Txt('${p.$1}', color: Palette.purple),
                ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        PrimaryButton(
          'Copy playlist',
          icon: Icons.copy_rounded,
          onPressed: () => copyShare('Sleep With Me — Bedtime Stories'),
        ),
      ],
    ),
  );
  Future<void> copyShare(String content) async {
    await Clipboard.setData(ClipboardData(text: content));
    if (mounted) toast(context, 'Playlist copied — ready to share');
  }

  Widget challenge() => PageLayout(
    color: Palette.cloud,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Txt('Challenge', size: 32, weight: FontWeight.w500),
        const SizedBox(height: 24),
        SizedBox(
          height: 355,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              fit: StackFit.expand,
              children: [
                const Picture('cardio', fit: BoxFit.cover),
                Padding(
                  padding: const EdgeInsets.all(26),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 36),
                      const Label('Fitness', color: Palette.mint),
                      const SizedBox(height: 10),
                      const Txt(
                        'Cardio',
                        size: 40,
                        color: Colors.white,
                        weight: FontWeight.w500,
                      ),
                      const SizedBox(height: 22),
                      const SizedBox(
                        width: 170,
                        child: Txt(
                          'Get active on your off days and challenge your friends',
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          const Avatar(size: 30),
                          const SizedBox(width: 5),
                          const Pill('+12'),
                          const Spacer(),
                          Pill(
                            'Start',
                            onTap: () => showDialog<void>(
                              context: context,
                              builder: (c) => AlertDialog(
                                title: const Text('Ready for your challenge?'),
                                content: const Text(
                                  '7 minutes of movement. Choose a comfortable pace and enjoy your workout.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(c),
                                    child: const Text('Let’s go'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SectionTitle('Trending', action: () => open(context, Screen.events)),
        for (final p in [
          ('Office Workout', 'Beginner • 7 mins', 'workout'),
          ('Abs Intermediate', 'Advance • 7 mins', 'abs'),
        ])
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Panel(
              onTap: () => open(context, Screen.eventDetails),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Txt('🔥🔥', size: 13, color: Palette.purple),
                        const SizedBox(height: 10),
                        Txt(p.$1, size: 17, weight: FontWeight.w500),
                        Txt(p.$2, size: 12, color: Palette.muted),
                      ],
                    ),
                  ),
                  Picture(p.$3, width: 105, height: 120),
                ],
              ),
            ),
          ),
      ],
    ),
  );
  Widget events() {
    final m = AppScope.of(context);
    return PageLayout(
      color: Palette.cloud,
      action: IconButton(
        tooltip: 'Calendar',
        onPressed: () => toast(context, 'Select a day to see events'),
        icon: const Icon(
          Icons.calendar_today_outlined,
          color: Palette.purple,
          size: 21,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Txt('Events', size: 32, weight: FontWeight.w500),
          const SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              7,
              (i) => InkWell(
                onTap: () => setState(() => selectedDay = i),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: i == selectedDay
                        ? Palette.purple
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Txt(
                        ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][i],
                        size: 10,
                        color: i == selectedDay ? Colors.white : Palette.muted,
                      ),
                      const SizedBox(height: 8),
                      Txt(
                        '${10 + i}',
                        color: i == selectedDay ? Colors.white : Palette.ink,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Panel(
            padding: 0,
            onTap: () => open(context, Screen.eventDetails),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Picture(
                  'event',
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  radius: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Label('Events'),
                      const SizedBox(height: 10),
                      const Txt(
                        'National health movement',
                        size: 21,
                        weight: FontWeight.w500,
                      ),
                      const SizedBox(height: 10),
                      const Txt(
                        'Challenge your friends by taking the most steps on Saturday and Sunday!',
                        color: Palette.slate,
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          const Avatar(size: 30),
                          const SizedBox(width: 8),
                          const Pill('+12'),
                          const Spacer(),
                          Pill(
                            m.joinedEvent ? 'Joined' : 'Join',
                            selected: m.joinedEvent,
                            onTap: () {
                              m.joinedEvent = !m.joinedEvent;
                              m.save();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SectionTitle('Nearby Events'),
          const Txt(
            '📍 110 The Embarcadero, San Francisco',
            size: 12,
            color: Palette.muted,
          ),
          const SizedBox(height: 14),
          const Picture(
            'map',
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
            radius: 22,
          ),
          for (final e in [
            ('13', 'Open Water Swim', 'Free Event'),
            ('24', 'Marathon 2020', 'Paid Event'),
          ])
            Entry(
              e.$2,
              e.$3,
              leading: IconTile(
                Icons.directions_run_rounded,
                color: e.$1 == '13' ? Palette.blue : Palette.purple,
              ),
              onTap: () => open(context, Screen.eventDetails),
            ),
        ],
      ),
    );
  }

  Widget eventDetails() {
    final m = AppScope.of(context);
    return PageLayout(
      padding: 0,
      action: const BookmarkButton('event'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Picture(
            'event',
            height: 245,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Label('Events'),
                const SizedBox(height: 12),
                const Txt(
                  'National Health\nMovement',
                  size: 30,
                  weight: FontWeight.w500,
                ),
                Entry(
                  'by The Commonwealth Club',
                  '',
                  trailing: Pill(
                    following ? 'Following' : 'Follow',
                    selected: following,
                    onTap: () => setState(() => following = !following),
                  ),
                ),
                const SizedBox(height: 15),
                const Txt(
                  '24 people are going',
                  size: 16,
                  weight: FontWeight.w500,
                ),
                const SizedBox(height: 14),
                const Row(
                  children: [
                    Avatar(size: 32),
                    SizedBox(width: 8),
                    Avatar(size: 32),
                    SizedBox(width: 8),
                    Pill('+12'),
                  ],
                ),
                const SizedBox(height: 24),
                Entry(
                  'Thursday, 6 Feb 2020',
                  '6:30 PM – 7:30 PM',
                  leading: const Icon(
                    Icons.calendar_today_outlined,
                    color: Palette.slate,
                  ),
                  onTap: () => toast(context, 'Event saved to your local list'),
                ),
                const Entry(
                  'Commonwealth Club',
                  '110 The Embarcadero, San Francisco',
                  leading: Icon(
                    Icons.location_on_outlined,
                    color: Palette.slate,
                  ),
                ),
                const SectionTitle('About'),
                const Txt(
                  'Get active on your off days and challenge your friends by taking the most steps on Saturday and Sunday! Let’s go!',
                  color: Palette.slate,
                ),
                const SectionTitle('Location'),
                const Picture(
                  'map',
                  height: 210,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  radius: 22,
                ),
                const SizedBox(height: 12),
                const Txt(
                  'Commonwealth Club',
                  center: true,
                  weight: FontWeight.w500,
                ),
                const SizedBox(height: 30),
                Panel(
                  color: Palette.cloud,
                  child: Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Txt('US\$29', size: 22, weight: FontWeight.w500),
                            Txt(
                              'ticket per person',
                              size: 11,
                              color: Palette.muted,
                            ),
                          ],
                        ),
                      ),
                      Pill(
                        m.joinedEvent ? 'Joined' : 'Purchase',
                        selected: m.joinedEvent,
                        onTap: () => showDialog<void>(
                          context: context,
                          builder: (c) => AlertDialog(
                            title: const Text('Join National Health Movement'),
                            content: const Text(
                              'Reserve this event in your local activity list. Payment is not connected.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(c),
                                child: const Text('Cancel'),
                              ),
                              FilledButton(
                                onPressed: () {
                                  m.joinedEvent = true;
                                  m.save();
                                  Navigator.pop(c);
                                  toast(
                                    context,
                                    'Event added to your activities',
                                  );
                                },
                                child: const Text('Reserve'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget tips() => PageLayout(
    color: const Color(0xFF414141),
    light: true,
    child: Padding(
      padding: const EdgeInsets.only(top: 95),
      child: Panel(
        color: Palette.lavender,
        padding: 30,
        child: Column(
          children: [
            const Icon(
              Icons.nights_stay_rounded,
              color: Palette.mint,
              size: 90,
            ),
            const SizedBox(height: 30),
            const Txt(
              'Get a good night’s\nsleep, every night',
              size: 25,
              color: Colors.white,
              center: true,
              weight: FontWeight.w500,
            ),
            const SizedBox(height: 20),
            const Txt(
              'Useful Tips: Poor sleep is one of the strongest risk factors for weight gain, so taking care of your sleep is important.',
              color: Palette.pale,
              center: true,
            ),
            const SizedBox(height: 40),
            PrimaryButton(
              'Alright!',
              white: true,
              onPressed: () => open(context, Screen.sleepReminder),
            ),
          ],
        ),
      ),
    ),
  );
}
