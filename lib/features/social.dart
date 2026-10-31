import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/model.dart';
import '../core/routes.dart';
import '../core/theme.dart';
import '../core/widgets.dart';

class SocialPage extends StatefulWidget {
  const SocialPage(this.screen, {super.key});
  final Screen screen;
  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  final post = TextEditingController(), comment = TextEditingController();
  bool liked = false, yearly = true;
  int card = 0;
  double mood = 4;
  String attachment = '';
  final Set<String> reasons = {'Slow loading', 'Not responsive'};
  final List<String> comments = [];
  @override
  void dispose() {
    post.dispose();
    comment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final m = AppScope.of(context);
    return switch (widget.screen) {
      Screen.community => community(m),
      Screen.createPost => createPost(m),
      Screen.poll => poll(m),
      Screen.share => share(m),
      Screen.profile => profile(m),
      Screen.premium => premium(),
      Screen.notifications => notifications(),
      Screen.invite => invite(),
      Screen.feedback => feedback(),
      Screen.feedbackDetails => feedbackDetails(m),
      _ => const SizedBox.shrink(),
    };
  }

  Widget community(AppModel m) => PageLayout(
    color: Palette.cloud,
    action: IconButton(
      tooltip: 'Create post',
      onPressed: () => open(context, Screen.createPost),
      icon: const Icon(Icons.add_circle_outline_rounded, color: Palette.purple),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Txt('Community', size: 32, weight: FontWeight.w500),
        const SizedBox(height: 22),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            5,
            (i) => InkWell(
              onTap: () =>
                  open(context, i == 4 ? Screen.invite : Screen.profile),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: i == 0 ? Palette.purple : Palette.mint,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(19),
                ),
                child: i == 4
                    ? const IconTile(
                        Icons.person_add_alt_1_rounded,
                        color: Palette.lilac,
                        size: 38,
                      )
                    : Avatar(size: 38, person: i + 1),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        for (final text in m.posts)
          Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: postPanel(
              m.name,
              'Just now',
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Txt(text), reactions()],
              ),
            ),
          ),
        postPanel(
          'Jessica Mendez',
          'Food • 10m ago',
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Txt('Yummy breakfast on weekend', size: 13),
              const Txt('#brekkie', size: 13, color: Palette.purple),
              const SizedBox(height: 14),
              Row(
                children: [
                  const Expanded(
                    child: Picture(
                      'salad',
                      height: 130,
                      fit: BoxFit.cover,
                      radius: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Picture(
                      'meal',
                      height: 130,
                      fit: BoxFit.cover,
                      radius: 16,
                    ),
                  ),
                ],
              ),
              reactions(),
            ],
          ),
        ),
        const SizedBox(height: 20),
        postPanel(
          'Sebastian',
          'Achievement • 10m ago',
          Column(
            children: [
              Panel(
                color: Palette.cloud,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Label('Leaderboard'),
                    const SizedBox(height: 15),
                    const Txt(
                      'You are on 1st place among your friends',
                      size: 22,
                      weight: FontWeight.w500,
                    ),
                    const SizedBox(height: 16),
                    for (final p in [
                      ('🥇', 'You', '55 km'),
                      ('🥈', 'Amanda', '53 km'),
                      ('🥉', 'Claire', '50 km'),
                    ])
                      Entry(
                        p.$2,
                        p.$3,
                        leading: Text(
                          p.$1,
                          style: const TextStyle(fontSize: 28),
                        ),
                        trailing: const Avatar(size: 28),
                      ),
                  ],
                ),
              ),
              reactions(),
            ],
          ),
        ),
        const SizedBox(height: 20),
        postPanel(
          'John Smith',
          'Walk • 10m ago',
          Column(
            children: [
              Panel(
                color: Palette.lavender,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.directions_walk_rounded, color: Colors.white),
                    SizedBox(height: 14),
                    Label('Average steps', color: Palette.pale),
                    Txt(
                      '8,560',
                      size: 38,
                      color: Colors.white,
                      weight: FontWeight.w500,
                    ),
                    SizedBox(height: 20),
                    TrendChart(color: Palette.mint, bars: true, height: 110),
                  ],
                ),
              ),
              reactions(),
            ],
          ),
        ),
        SectionTitle('Quick polls', action: () => open(context, Screen.poll)),
        Panel(
          color: const Color(0xFFFFE189),
          onTap: () => open(context, Screen.poll),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Picture('banana', height: 125, width: double.infinity),
              const Label('Health'),
              const SizedBox(height: 12),
              const Txt(
                'Do Bananas Cause Weight Gain or Help With Weight Loss?',
                size: 20,
                weight: FontWeight.w500,
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  const Expanded(
                    child: Txt('123 votes', size: 12, color: Palette.slate),
                  ),
                  Pill('Vote', onTap: () => open(context, Screen.poll)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        PrimaryButton(
          'Find events near you',
          icon: Icons.event_rounded,
          onPressed: () => open(context, Screen.events),
        ),
      ],
    ),
  );
  Widget postPanel(String name, String subtitle, Widget body) => Panel(
    padding: 18,
    shadow: true,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Entry(
          name,
          subtitle,
          leading: Avatar(
            size: 36,
            person: const {
              'Jessica Mendez': 1,
              'Sebastian': 2,
              'John Smith': 3,
            }[name],
          ),
          trailing: const Icon(Icons.more_horiz_rounded, color: Palette.muted),
        ),
        const SizedBox(height: 8),
        body,
      ],
    ),
  );
  Widget reactions() => Padding(
    padding: const EdgeInsets.only(top: 14),
    child: Row(
      children: [
        InkWell(
          onTap: () => setState(() => liked = !liked),
          child: Row(
            children: [
              Icon(
                liked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                size: 18,
                color: liked ? Palette.coral : Palette.muted,
              ),
              const SizedBox(width: 6),
              Txt('${45 + (liked ? 1 : 0)}', size: 12, color: Palette.slate),
            ],
          ),
        ),
        const SizedBox(width: 22),
        InkWell(
          onTap: () => open(context, Screen.poll),
          child: const Row(
            children: [
              Icon(
                Icons.chat_bubble_outline_rounded,
                size: 17,
                color: Palette.muted,
              ),
              SizedBox(width: 6),
              Txt('4', size: 12, color: Palette.slate),
            ],
          ),
        ),
        const Spacer(),
        TextButton.icon(
          onPressed: () => open(context, Screen.share),
          icon: const Icon(Icons.reply_rounded, size: 17),
          label: const Text('Share', style: TextStyle(fontSize: 12)),
        ),
      ],
    ),
  );
  Widget createPost(AppModel m) => PageLayout(
    action: Pill(
      'Post',
      onTap: () async {
        if (post.text.trim().isEmpty) {
          toast(context, 'Write something to share with the community');
          return;
        }
        m.posts.insert(
          0,
          '${post.text.trim()}${attachment.isEmpty ? '' : '\n#$attachment'}',
        );
        await m.save();
        if (mounted) {
          toast(context, 'Your post has been published locally');
          open(context, Screen.community);
        }
      },
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Txt('Create post', size: 28, weight: FontWeight.w500),
        const SizedBox(height: 25),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Avatar(),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: post,
                minLines: 4,
                maxLines: 8,
                maxLength: 500,
                decoration: const InputDecoration(
                  hintText: 'What’s on your mind?',
                  fillColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
        if (attachment.isNotEmpty)
          Pill(
            '$attachment attached',
            onTap: () => setState(() => attachment = ''),
          ),
        const Divider(),
        const Txt('Add attachment', size: 15, weight: FontWeight.w500),
        const SizedBox(height: 20),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 18,
          mainAxisSpacing: 18,
          childAspectRatio: .8,
          children:
              [
                    (Icons.camera_alt_rounded, 'Photo', Palette.mint),
                    (Icons.favorite_rounded, 'Health', Palette.coral),
                    (Icons.directions_walk_rounded, 'Steps', Palette.lilac),
                    (Icons.water_drop_rounded, 'Water', Palette.lavender),
                    (Icons.restaurant_rounded, 'Nutrition', Palette.purple),
                    (Icons.bar_chart_rounded, 'Polls', Palette.mint),
                    (Icons.monitor_weight_rounded, 'Weight', Palette.blue),
                    (Icons.verified_rounded, 'Badge', Palette.blue),
                    (Icons.nights_stay_rounded, 'Sleep', Palette.muted),
                  ]
                  .map(
                    (a) => InkWell(
                      onTap: () => setState(() => attachment = a.$2),
                      child: Column(
                        children: [
                          IconTile(a.$1, color: a.$3, size: 64),
                          const SizedBox(height: 10),
                          Txt(
                            a.$2,
                            size: 12,
                            color: attachment == a.$2
                                ? Palette.purple
                                : Palette.slate,
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
        ),
      ],
    ),
  );
  Widget poll(AppModel m) => PageLayout(
    color: const Color(0xFFFFE189),
    padding: 0,
    child: Column(
      children: [
        const Picture('banana', height: 160, width: double.infinity),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(28),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              const Label('Health polls'),
              const SizedBox(height: 16),
              const Txt(
                'Do Bananas Cause Weight Gain or\nHelp With Weight Loss?',
                size: 22,
                center: true,
                weight: FontWeight.w500,
              ),
              const SizedBox(height: 26),
              for (var i = 0; i < 2; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: () {
                      m.vote = i;
                      m.save();
                    },
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: Palette.cloud,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: m.vote == i
                              ? Palette.purple
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Stack(
                        children: [
                          FractionallySizedBox(
                            widthFactor: i == 0 ? 0.3 : 0.7,
                            child: Container(
                              height: 52,
                              color: Palette.lilac.withValues(alpha: .55),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Txt(
                                    i == 0
                                        ? 'Gain weight'
                                        : 'Help with weight loss',
                                    size: 13,
                                  ),
                                ),
                                Txt(
                                  i == 0 ? '30%' : '70%',
                                  size: 12,
                                  weight: FontWeight.w500,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              if (m.vote != null)
                const Txt(
                  'Your vote has been recorded',
                  size: 12,
                  color: Palette.purple,
                ),
              reactions(),
              const Divider(),
              const Entry(
                'Marie Smith',
                '1 mo ago',
                leading: Avatar(size: 34),
                trailing: Pill('★ 5.0'),
              ),
              const Txt(
                'Bananas are healthy and nutritious, there is no doubt about that. They are also high in fiber, but low in calories.',
                color: Palette.slate,
              ),
              for (final c in comments)
                Entry(m.name, c, leading: const Avatar(size: 30)),
              const SizedBox(height: 28),
              TextField(
                controller: comment,
                decoration: InputDecoration(
                  hintText: 'Write comment..',
                  suffixIcon: IconButton(
                    tooltip: 'Send comment',
                    icon: const Icon(Icons.send_rounded, color: Palette.purple),
                    onPressed: () {
                      if (comment.text.trim().isNotEmpty) {
                        setState(() => comments.add(comment.text.trim()));
                        comment.clear();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
  Widget share(AppModel m) => PageLayout(
    title: 'Share',
    action: IconButton(
      tooltip: 'Copy progress',
      onPressed: () =>
          copy('My average steps: 9,789 · 131 kcal · 93 mins. #Momotaro'),
      icon: const Icon(Icons.ios_share_rounded, color: Palette.purple),
    ),
    child: Column(
      children: [
        Container(
          height: 420,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Palette.lavender,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Picture(['share', 'profile', 'cardio'][card], fit: BoxFit.cover),
              Container(color: Palette.ink.withValues(alpha: .18)),
              const Padding(
                padding: EdgeInsets.all(28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.directions_walk_rounded,
                      color: Colors.white,
                      size: 38,
                    ),
                    Spacer(),
                    Label('Average steps', color: Colors.white),
                    SizedBox(height: 12),
                    Txt(
                      '9,789',
                      size: 48,
                      color: Colors.white,
                      weight: FontWeight.w500,
                    ),
                    SizedBox(height: 14),
                    Txt('🔥 131 kcal     ◷ 93 mins', color: Colors.white),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 26),
        const Align(
          alignment: Alignment.centerLeft,
          child: Label('Change card'),
        ),
        const SizedBox(height: 15),
        Row(
          children: List.generate(
            3,
            (i) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: InkWell(
                  onTap: () => setState(() => card = i),
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: card == i ? Palette.purple : Colors.transparent,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Picture(
                      ['share', 'profile', 'cardio'][i],
                      height: 65,
                      radius: 14,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 26),
        PrimaryButton(
          'Share',
          icon: Icons.ios_share_rounded,
          onPressed: () =>
              copy('My average steps: 9,789 · 131 kcal · 93 mins. #Momotaro'),
        ),
      ],
    ),
  );
  Future<void> copy(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (mounted) toast(context, 'Copied — ready to share');
  }

  Widget profile(AppModel m) => PageLayout(
    padding: 0,
    back: false,
    color: Palette.cloud,
    action: IconButton(
      tooltip: 'Edit profile',
      onPressed: () => editProfile(m),
      icon: const Icon(Icons.tune_rounded, color: Palette.purple),
    ),
    child: Column(
      children: [
        const Picture(
          'profile',
          height: 170,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Avatar(size: 60),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Txt(m.name, size: 24, weight: FontWeight.w500),
                  ),
                  Pill('Edit', onTap: () => editProfile(m)),
                ],
              ),
              const Label('Basic member'),
              const SizedBox(height: 20),
              const Txt(
                'I decided I was going to actively pursue a better life, and take better care of my mind, body and soul',
                size: 13,
                color: Palette.slate,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (final p in [
                    ('Weight', '${m.weight.toStringAsFixed(1)} kg'),
                    ('Age', '26 yo'),
                    ('Height', '160 cm'),
                  ])
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Label(p.$1, color: Palette.muted),
                        const SizedBox(height: 7),
                        Txt(p.$2, size: 20, weight: FontWeight.w500),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 26),
              Row(
                children: [
                  Expanded(
                    child: Panel(
                      color: Palette.lavender,
                      onTap: () => open(context, Screen.steps),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Label('Steps', color: Colors.white),
                          SizedBox(height: 20),
                          Icon(
                            Icons.directions_walk_rounded,
                            color: Palette.mint,
                            size: 46,
                          ),
                          SizedBox(height: 18),
                          Txt(
                            '9,890',
                            size: 25,
                            color: Colors.white,
                            weight: FontWeight.w500,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Panel(
                      color: Palette.coral,
                      onTap: () => open(context, Screen.progress),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Label('Heart rate', color: Colors.white),
                          SizedBox(height: 20),
                          Icon(
                            Icons.monitor_heart_outlined,
                            color: Colors.white,
                            size: 46,
                          ),
                          SizedBox(height: 18),
                          Txt(
                            '105 bpm',
                            size: 25,
                            color: Colors.white,
                            weight: FontWeight.w500,
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
        Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle('My badges'),
              Panel(
                child: Column(
                  children: [
                    for (final b in [
                      ('🍉', 'Nutrition Expert', 'Hit all daily Goals'),
                      ('🍃', 'Yoga Master', 'Complete 3 meditations'),
                      ('👟', 'Moon Walker', 'Walk 20,000 a day'),
                    ])
                      Entry(
                        b.$2,
                        b.$3,
                        leading: Container(
                          width: 48,
                          height: 48,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Palette.pale,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            b.$1,
                            style: const TextStyle(fontSize: 27),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Panel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Label('Go premium'),
                    const SizedBox(height: 12),
                    const Txt(
                      'Unlock all features to improve your health',
                      size: 23,
                      weight: FontWeight.w500,
                    ),
                    const SizedBox(height: 12),
                    const Txt(
                      'Be a part of our healthy group',
                      color: Palette.muted,
                    ),
                    const SizedBox(height: 25),
                    PrimaryButton(
                      'Unlock now',
                      onPressed: () => open(context, Screen.premium),
                    ),
                  ],
                ),
              ),
              const SectionTitle('Your space'),
              for (final p in [
                (Screen.progress, Icons.monitor_weight_outlined),
                (Screen.sleepReminder, Icons.nights_stay_outlined),
                (Screen.weightReminder, Icons.calendar_today_outlined),
                (Screen.invite, Icons.person_add_alt_1_rounded),
                (Screen.notifications, Icons.notifications_none_rounded),
                (Screen.feedback, Icons.sentiment_satisfied_alt_rounded),
                (Screen.welcome, Icons.auto_awesome_rounded),
              ])
                Entry(
                  p.$1.title,
                  '',
                  leading: Icon(p.$2, color: Palette.purple),
                  trailing: const Icon(
                    Icons.chevron_right_rounded,
                    color: Palette.muted,
                  ),
                  onTap: () => open(context, p.$1),
                ),
            ],
          ),
        ),
      ],
    ),
  );
  Future<void> editProfile(AppModel m) async {
    final controller = TextEditingController(text: m.name);
    await showDialog<void>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Edit profile'),
        content: TextField(
          controller: controller,
          maxLength: 40,
          decoration: const InputDecoration(labelText: 'Your name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (controller.text.trim().isEmpty) return;
              m.name = controller.text.trim();
              m.save();
              Navigator.pop(c);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
    controller.dispose();
  }

  Widget premium() => PageLayout(
    child: Column(
      children: [
        const Picture('premium', height: 175, width: double.infinity),
        const SizedBox(height: 22),
        const Txt(
          'Go premium\nGet unlimited access',
          size: 27,
          center: true,
          weight: FontWeight.w500,
        ),
        const SizedBox(height: 14),
        const Txt(
          'When you subscribe, you’ll gain instant unlimited access',
          center: true,
          color: Palette.muted,
        ),
        const SizedBox(height: 30),
        for (final annual in [true, false])
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Panel(
              color: yearly == annual ? Palette.lavender : Palette.cloud,
              onTap: () => setState(() => yearly = annual),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Txt(
                          annual ? '\$4.99' : '\$5.99',
                          size: 23,
                          color: yearly == annual ? Colors.white : Palette.ink,
                          weight: FontWeight.w500,
                        ),
                      ),
                      if (annual) const Pill('SAVE 30%'),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Txt(
                    annual
                        ? '\$4.99/month, billed yearly \$60'
                        : 'Billed monthly \$5.99',
                    size: 12,
                    color: yearly == annual ? Colors.white : Palette.muted,
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 14),
        PrimaryButton(
          'Go Premium',
          icon: Icons.star_rounded,
          onPressed: () => showDialog<void>(
            context: context,
            builder: (c) => AlertDialog(
              title: const Text('Membership preview'),
              content: Text(
                'You selected the ${yearly ? 'yearly' : 'monthly'} plan. Store billing is not connected in this preview.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(c),
                  child: const Text('Got it'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 26),
        const Txt(
          'Subscription billed as one payment. Recurring billing. Cancel anytime for any reason.',
          size: 11,
          color: Palette.muted,
          center: true,
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => showDialog<void>(
            context: context,
            builder: (c) => AlertDialog(
              title: const Text('Privacy & terms'),
              content: const Text(
                'This offline preview stores your health entries on this device. No payment or account data is sent to a server. You can clear local data in system app settings.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(c),
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
          child: const Text(
            'Terms • Privacy Policy',
            style: TextStyle(fontSize: 11),
          ),
        ),
      ],
    ),
  );
  Widget notifications() => PageLayout(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Txt('Notification', size: 32, weight: FontWeight.w500),
        const SizedBox(height: 30),
        const Txt('Earlier  ⁺³', size: 20, weight: FontWeight.w500),
        Entry(
          'Tommy Parker',
          'commented your post.',
          leading: const Avatar(),
          onTap: () => open(context, Screen.community),
        ),
        Entry(
          'Drink more',
          'You drink less than 200ml today',
          leading: const IconTile(Icons.water_drop_rounded),
          onTap: () => open(context, Screen.water),
        ),
        const SectionTitle('Last week'),
        Entry(
          'Daily target',
          'Congrats you just hit your goal!',
          leading: const IconTile(
            Icons.directions_walk_rounded,
            color: Palette.lilac,
          ),
          trailing: Pill('Share', onTap: () => open(context, Screen.share)),
          onTap: () => open(context, Screen.steps),
        ),
        Entry(
          'Achievement',
          'You are the first among your friends',
          leading: const IconTile(Icons.verified_rounded, color: Palette.blue),
          onTap: () => open(context, Screen.community),
        ),
        Entry(
          'Nutrition',
          'Your breakfast has high cals',
          leading: const IconTile(
            Icons.restaurant_rounded,
            color: Palette.mint,
          ),
          onTap: () => open(context, Screen.journal),
        ),
      ],
    ),
  );
  Widget invite() => PageLayout(
    title: 'Share',
    child: Column(
      children: [
        const Picture('invite', height: 200),
        const SizedBox(height: 18),
        const Txt('Get \$5 off!', size: 30, weight: FontWeight.w500),
        const SizedBox(height: 15),
        const Txt(
          'Each time a friend signs up through\nyour referral link we’ll reward you both \$5',
          center: true,
          color: Palette.muted,
        ),
        const SizedBox(height: 26),
        Panel(
          color: Palette.lilac,
          onTap: () => copy('MMTR123'),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Txt(
                'M M T R 1 2 3',
                size: 20,
                color: Colors.white,
                weight: FontWeight.w500,
              ),
              SizedBox(width: 20),
              Icon(Icons.copy_rounded, color: Colors.white, size: 20),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Label('Or send invite', color: Palette.muted),
        const SizedBox(height: 20),
        Entry(
          'Add friend',
          '',
          leading: const IconTile(Icons.person_add_alt_1_rounded),
          onTap: () => copy('Join me on Momotaro! Referral code: MMTR123'),
        ),
        for (final n in ['Danny', 'Jessica'])
          Entry(
            n,
            'Joined',
            leading: const Avatar(size: 44),
            trailing: const Pill('+\$5'),
          ),
      ],
    ),
  );
  Widget feedback() => PageLayout(
    color: Palette.lavender,
    light: true,
    child: Column(
      children: [
        const SizedBox(height: 50),
        const Label('User feedback', color: Palette.pale),
        const SizedBox(height: 18),
        const Txt(
          'How was your overall\nexperience?',
          size: 27,
          center: true,
          color: Colors.white,
          weight: FontWeight.w500,
        ),
        const SizedBox(height: 60),
        Text(
          ['😞', '😐', '🙂', '😊', '🤩'][mood.round() - 1],
          style: const TextStyle(fontSize: 100),
        ),
        const SizedBox(height: 24),
        Txt(
          [
            'Could be better',
            'It was okay',
            'I am happy!',
            'I am satisfied!',
            'I love it!',
          ][mood.round() - 1],
          size: 20,
          color: Colors.white,
        ),
        const SizedBox(height: 60),
        Slider(
          value: mood,
          min: 1,
          max: 5,
          divisions: 4,
          activeColor: Palette.mint,
          inactiveColor: Palette.pale,
          label: '${mood.round()}/5',
          onChanged: (v) => setState(() => mood = v),
        ),
        const SizedBox(height: 45),
        PrimaryButton(
          'Continue',
          white: true,
          onPressed: () => open(context, Screen.feedbackDetails),
        ),
      ],
    ),
  );
  Widget feedbackDetails(AppModel m) => PageLayout(
    color: Palette.lavender,
    light: true,
    child: Column(
      children: [
        const SizedBox(height: 45),
        const Icon(
          Icons.sentiment_satisfied_alt_rounded,
          color: Palette.mint,
          size: 75,
        ),
        const SizedBox(height: 25),
        Panel(
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Txt(
                'Which area that\nneed improvement?',
                size: 24,
                center: true,
                weight: FontWeight.w500,
              ),
              const SizedBox(height: 28),
              Wrap(
                spacing: 10,
                runSpacing: 14,
                alignment: WrapAlignment.center,
                children:
                    [
                          'Slow loading',
                          'Customer Service',
                          'App crash',
                          'Navigation',
                          'Not responsive',
                          'Not functional',
                          'Security issue',
                        ]
                        .map(
                          (r) => Pill(
                            r,
                            selected: reasons.contains(r),
                            color: Palette.cloud,
                            onTap: () => setState(() {
                              if (!reasons.add(r)) reasons.remove(r);
                            }),
                          ),
                        )
                        .toList(),
              ),
              const SizedBox(height: 50),
              PrimaryButton(
                'Submit',
                icon: Icons.mail_rounded,
                onPressed: () async {
                  await m.preferences.setStringList(
                    'feedback',
                    reasons.toList(),
                  );
                  if (mounted) {
                    toast(context, 'Thank you — your feedback has been saved');
                    open(context, Screen.home);
                  }
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ],
    ),
  );
}
