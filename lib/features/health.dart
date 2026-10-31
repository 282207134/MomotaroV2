import 'package:flutter/material.dart';
import '../core/model.dart';
import '../core/routes.dart';
import '../core/theme.dart';
import '../core/widgets.dart';

class HealthPage extends StatefulWidget {
  const HealthPage(this.screen, {super.key});
  final Screen screen;
  @override
  State<HealthPage> createState() => _HealthPageState();
}

class _HealthPageState extends State<HealthPage> {
  int glasses = 1, selectedDay = 3, serving = 1;
  String period = 'WEEK', mealQuery = '';
  @override
  Widget build(BuildContext context) {
    final m = AppScope.of(context);
    return switch (widget.screen) {
      Screen.home => home(m),
      Screen.steps => steps(),
      Screen.insight => insight(),
      Screen.water => water(m),
      Screen.nutrition => nutrition(m),
      Screen.journal => journal(m),
      Screen.recipe => recipe(),
      Screen.food => food(m),
      Screen.progress => progress(m),
      Screen.sleepReminder => sleepReminder(m),
      Screen.weightReminder => weightReminder(m),
      _ => const SizedBox.shrink(),
    };
  }

  Widget home(AppModel m) => PageLayout(
    back: false,
    action: IconButton(
      tooltip: 'Notifications',
      onPressed: () => open(context, Screen.notifications),
      icon: const Icon(Icons.notifications_none_rounded),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.wb_sunny_rounded,
                        size: 16,
                        color: Palette.purple,
                      ),
                      SizedBox(width: 9),
                      Label('Tues 13 Oct'),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Txt(
                    'Hi, ${m.name.split(' ').first}',
                    size: 32,
                    weight: FontWeight.w500,
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () => open(context, Screen.profile),
              child: const Avatar(size: 48),
            ),
          ],
        ),
        const SizedBox(height: 22),
        Panel(
          color: Palette.cloud,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 64,
                height: 70,
                decoration: BoxDecoration(
                  color: Palette.lavender,
                  borderRadius: BorderRadius.circular(22),
                ),
                alignment: Alignment.center,
                child: const Txt(
                  '84',
                  size: 24,
                  color: Colors.white,
                  weight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Txt(
                      'Health Score',
                      size: 18,
                      weight: FontWeight.w500,
                    ),
                    const Txt(
                      'Based on your overall health test, your score is 84 and consider good..',
                      color: Palette.slate,
                    ),
                    const SizedBox(height: 6),
                    InkWell(
                      onTap: () => open(context, Screen.tips),
                      child: const Txt(
                        'Read more',
                        color: Palette.purple,
                        weight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SectionTitle('Metrics', action: () => open(context, Screen.progress)),
        LayoutBuilder(
          builder: (context, c) => Wrap(
            spacing: 14,
            runSpacing: 14,
            children: [
              metric(
                'CALORIES',
                '${m.calories}',
                'cal',
                Palette.lavender,
                const Ring(
                  size: 78,
                  color: Palette.mint,
                  stroke: 18,
                  value: .27,
                ),
                Screen.nutrition,
                c.maxWidth,
              ),
              metric(
                'WEIGHT',
                m.weight.toStringAsFixed(m.weight % 1 == 0 ? 0 : 1),
                'kg',
                Palette.lilac,
                const TrendChart(
                  height: 58,
                  labels: false,
                  values: [
                    .3,
                    .55,
                    .46,
                    .7,
                    .45,
                    .56,
                    .4,
                    .65,
                    .58,
                    .8,
                    .42,
                    .62,
                  ],
                ),
                Screen.progress,
                c.maxWidth,
              ),
              metric(
                'WATER',
                '${m.water}',
                'ml',
                Palette.blue,
                const Icon(
                  Icons.local_drink_rounded,
                  color: Palette.mint,
                  size: 78,
                ),
                Screen.water,
                c.maxWidth,
              ),
              metric(
                'STEPS',
                '9,890',
                '',
                Palette.slate,
                const Ring(
                  size: 78,
                  color: Palette.lavender,
                  value: .52,
                  stroke: 8,
                  child: Icon(
                    Icons.directions_walk_rounded,
                    color: Colors.white,
                    size: 34,
                  ),
                ),
                Screen.steps,
                c.maxWidth,
              ),
            ],
          ),
        ),
      ],
    ),
  );
  Widget metric(
    String label,
    String value,
    String unit,
    Color color,
    Widget visual,
    Screen target,
    double width,
  ) => SizedBox(
    width: (width - 14) / 2,
    height: 210,
    child: Panel(
      color: color,
      onTap: () => open(context, target),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Label(label, color: Colors.white),
          Expanded(child: Center(child: visual)),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(text: ' $unit', style: const TextStyle(fontSize: 13)),
              ],
            ),
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Txt('last update 3m', size: 12, color: Color(0xFFE7E2FF)),
        ],
      ),
    ),
  );

  Widget steps() => PageLayout(
    action: Pill('Insight', onTap: () => open(context, Screen.insight)),
    child: Column(
      children: [
        const SizedBox(height: 24),
        const Label('Daily steps'),
        const SizedBox(height: 10),
        const Txt(
          'You have walked\n40% of your goal',
          size: 24,
          center: true,
          weight: FontWeight.w500,
        ),
        const SizedBox(height: 24),
        const Ring(
          size: 232,
          value: .72,
          stroke: 15,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.directions_walk_rounded,
                color: Palette.purple,
                size: 36,
              ),
              Txt('7,235', size: 36, weight: FontWeight.w500),
              Txt('steps', size: 12, color: Palette.muted),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            miniMetric(
              Icons.local_fire_department_rounded,
              '31 kcal',
              Palette.mint,
            ),
            miniMetric(Icons.location_on_rounded, '2 km', Palette.lilac),
            miniMetric(Icons.schedule_rounded, '50 min', Palette.blue),
          ],
        ),
        const SizedBox(height: 28),
        Panel(
          color: Palette.lavender,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: ['DAILY', 'WEEK', 'MONTH']
                    .map(
                      (p) => TextButton(
                        onPressed: () => setState(() => period = p),
                        child: Txt(
                          p,
                          size: 10,
                          color: Colors.white,
                          weight: period == p
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    )
                    .toList(),
              ),
              TrendChart(
                color: Palette.mint,
                height: 95,
                values: period == 'MONTH'
                    ? [.3, .7, .4, .8, .5, .6, .9]
                    : [.3, .4, .35, .65, .6, .68, .25],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        TextButton.icon(
          onPressed: () => open(context, Screen.share),
          icon: const Icon(Icons.ios_share_rounded, size: 18),
          label: const Text('Share progress'),
        ),
      ],
    ),
  );
  Widget miniMetric(IconData icon, String label, Color color) => Column(
    children: [
      Ring(
        size: 60,
        value: .7,
        color: color,
        stroke: 5,
        child: Icon(icon, color: color),
      ),
      const SizedBox(height: 8),
      Txt(label, size: 12),
    ],
  );
  Widget insight() => PageLayout(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Txt('Insight', size: 32, weight: FontWeight.w500),
        const SizedBox(height: 38),
        Panel(
          color: Palette.purple,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Label('Insight', color: Palette.pale),
              const SizedBox(height: 20),
              const Txt(
                'You’re taking fewer steps than you normally do',
                size: 22,
                color: Colors.white,
                weight: FontWeight.w500,
              ),
              const SizedBox(height: 32),
              const TrendChart(
                height: 140,
                color: Palette.mint,
                bars: true,
                labels: false,
              ),
              const SizedBox(height: 12),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Txt('6AM', size: 10, color: Palette.pale),
                  Txt('12PM', size: 10, color: Palette.pale),
                  Txt('6PM', size: 10, color: Palette.pale),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Panel(
          color: Palette.pale,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.directions_walk_rounded, color: Palette.purple),
              const SizedBox(height: 24),
              const Txt(
                'You took an average\nof 4,260 steps this week',
                size: 22,
                weight: FontWeight.w500,
              ),
              const SizedBox(height: 24),
              const TrendChart(height: 120),
              const SizedBox(height: 24),
              Panel(
                padding: 12,
                child: Entry(
                  'Most steps',
                  'Friday',
                  leading: const IconTile(Icons.calendar_today_rounded),
                  trailing: const Txt('13,450', color: Palette.purple),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
  Widget water(AppModel m) => PageLayout(
    child: Column(
      children: [
        const SizedBox(height: 35),
        const Label('Hydration'),
        const SizedBox(height: 12),
        Txt(
          'Today you took\n${m.water} ml of water 💧',
          size: 25,
          center: true,
          weight: FontWeight.w500,
        ),
        const SizedBox(height: 12),
        const Txt(
          'Almost there! Keep hydrated',
          size: 13,
          color: Palette.muted,
        ),
        const SizedBox(height: 65),
        Container(
          padding: const EdgeInsets.all(22),
          decoration: const BoxDecoration(
            color: Palette.lavender,
            shape: BoxShape.circle,
          ),
          child: Txt('${m.water}', size: 24, color: Colors.white),
        ),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: LinearProgressIndicator(
            value: (m.water / 2000).clamp(0, 1),
            minHeight: 48,
            color: Palette.mint,
            backgroundColor: Palette.cloud,
          ),
        ),
        const SizedBox(height: 12),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Txt('Poor', size: 11, color: Palette.muted),
            Txt('Good', size: 11, color: Palette.muted),
            Txt('Almost', size: 11, color: Palette.muted),
            Txt('Perfect!', size: 11, color: Palette.muted),
          ],
        ),
        const SizedBox(height: 42),
        Panel(
          color: Palette.cloud,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    tooltip: 'Fewer glasses',
                    onPressed: glasses > 1
                        ? () => setState(() => glasses--)
                        : null,
                    icon: const Icon(Icons.remove_circle_rounded),
                  ),
                  const Icon(
                    Icons.local_drink_rounded,
                    color: Palette.mint,
                    size: 68,
                  ),
                  IconButton(
                    tooltip: 'More glasses',
                    onPressed: glasses < 10
                        ? () => setState(() => glasses++)
                        : null,
                    icon: const Icon(
                      Icons.add_circle_rounded,
                      color: Palette.purple,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Txt('${glasses}x Glass ${glasses * 200} ml', size: 13),
              const SizedBox(height: 24),
              PrimaryButton(
                'Add Drink',
                icon: Icons.water_drop_rounded,
                onPressed: () async {
                  await m.addWater(glasses * 200);
                  if (mounted) {
                    toast(context, '${glasses * 200} ml added to your day');
                  }
                },
              ),
            ],
          ),
        ),
      ],
    ),
  );
  Widget nutrition(AppModel m) => PageLayout(
    action: Pill('Journal', onTap: () => open(context, Screen.journal)),
    child: Column(
      children: [
        const SizedBox(height: 28),
        const Label('Daily intake'),
        const SizedBox(height: 12),
        Txt(
          'Today you have\nconsumed ${m.calories} cal',
          size: 25,
          center: true,
          weight: FontWeight.w500,
        ),
        const SizedBox(height: 22),
        Ring(
          size: 235,
          value: .72,
          color: Palette.blue,
          stroke: 10,
          child: Ring(
            size: 204,
            value: .8,
            color: Palette.purple,
            stroke: 10,
            child: Ring(
              size: 173,
              value: .63,
              color: Palette.mint,
              stroke: 10,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Txt(
                    '${(m.calories / 1250 * 100).round()}%',
                    size: 28,
                    weight: FontWeight.w500,
                  ),
                  const Txt('of daily goals', size: 12, color: Palette.muted),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
        for (final row in [
          ('Carb', '100 g', '32%', Palette.blue),
          ('Protein', '90 g', '40%', Palette.purple),
          ('Fat', '100 g', '28%', Palette.mint),
        ])
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 13),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: row.$4,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: Txt(row.$1)),
                Txt(row.$2, color: Palette.muted),
                const SizedBox(width: 40),
                Txt(row.$3),
              ],
            ),
          ),
        const SizedBox(height: 32),
        PrimaryButton(
          'Add Meal',
          icon: Icons.restaurant_rounded,
          onPressed: () => open(context, Screen.recipe),
        ),
      ],
    ),
  );
  Widget calendar() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: List.generate(
      7,
      (i) => InkWell(
        onTap: () => setState(() => selectedDay = i),
        child: Container(
          width: 36,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: i == selectedDay ? Palette.purple : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
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
                size: 14,
                color: i == selectedDay ? Colors.white : Palette.slate,
              ),
            ],
          ),
        ),
      ),
    ),
  );
  Widget journal(AppModel m) => PageLayout(
    title: 'Journal',
    color: Palette.cloud,
    child: Column(
      children: [
        calendar(),
        const SizedBox(height: 16),
        TextField(
          onChanged: (s) => setState(() => mealQuery = s),
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search_rounded, size: 20),
            hintText: 'Search meal..',
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        for (final meal in ['BREAKFAST', 'LUNCH'])
          Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Panel(
              shadow: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Label(meal)),
                      IconButton(
                        tooltip: 'Add $meal',
                        onPressed: () => open(context, Screen.recipe),
                        icon: const Icon(
                          Icons.add_box_rounded,
                          color: Palette.purple,
                        ),
                      ),
                    ],
                  ),
                  Txt(
                    meal == 'BREAKFAST'
                        ? '🔥 120 kcal /450 kcal'
                        : '🔥 715 kcal /450 kcal',
                    size: 16,
                    weight: FontWeight.w500,
                  ),
                  const SizedBox(height: 16),
                  for (final item in [
                    ('Salad with wheat and white egg', 'meal'),
                    (
                      meal == 'BREAKFAST' ? 'Pumpkin soup' : 'Fried chicken',
                      'soup',
                    ),
                    ...m.meals.map((s) => (s, 'salad')),
                  ])
                    if (item.$1.toLowerCase().contains(mealQuery.toLowerCase()))
                      Entry(
                        item.$1,
                        '200 cals',
                        leading: Picture(
                          item.$2,
                          width: 64,
                          height: 64,
                          radius: 16,
                          fit: BoxFit.cover,
                        ),
                        onTap: () => open(context, Screen.food),
                      ),
                  if (meal == 'BREAKFAST') ...[
                    const Divider(),
                    const Label('Very high carb!', color: Palette.coral),
                    const SizedBox(height: 8),
                    const Txt(
                      'Your pumpkin soup is high on carb. Try a lighter alternative.',
                      size: 13,
                      color: Palette.slate,
                    ),
                    TextButton(
                      onPressed: () => open(context, Screen.food),
                      child: const Text('Read more'),
                    ),
                  ],
                ],
              ),
            ),
          ),
      ],
    ),
  );
  Widget recipe() => PageLayout(
    color: Palette.cloud,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Panel(
          color: Palette.lavender,
          child: Column(
            children: [
              const Label('Daily pick', color: Palette.pale),
              const SizedBox(height: 10),
              const Txt(
                'Breakfast ideas',
                size: 26,
                color: Colors.white,
                weight: FontWeight.w500,
              ),
              const SizedBox(height: 26),
              const Picture('meal', height: 180),
              const SizedBox(height: 24),
              const Txt(
                'Start your day off right with these healthy breakfast recipes',
                center: true,
                color: Colors.white,
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                'Let’s try',
                white: true,
                onPressed: () => open(context, Screen.food),
              ),
            ],
          ),
        ),
        const SectionTitle('New recipe'),
        for (final i in [
          ('Mango and avocado salad', 'salad'),
          ('Sweet sauce honey chicken', 'meal'),
        ])
          Panel(
            child: Entry(
              i.$1,
              '200 cals',
              leading: Picture(
                i.$2,
                width: 90,
                height: 90,
                radius: 16,
                fit: BoxFit.cover,
              ),
              trailing: BookmarkButton(i.$1),
              onTap: () => open(context, Screen.food),
            ),
          ),
      ],
    ),
  );
  Widget food(AppModel m) => PageLayout(
    padding: 0,
    action: const BookmarkButton('breakfast'),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Picture(
          'salad',
          height: 250,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Label('Nutrition'),
              const SizedBox(height: 12),
              const Txt(
                'Salad with wheat and white egg breakfast',
                size: 26,
                weight: FontWeight.w500,
              ),
              const SizedBox(height: 16),
              Txt(
                '🔥 ${345 * serving} kcal',
                size: 26,
                weight: FontWeight.w500,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  IconButton(
                    tooltip: 'Decrease serving',
                    onPressed: serving > 1
                        ? () => setState(() => serving--)
                        : null,
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                  Expanded(
                    child: Txt('$serving Serving (2,000 g)', center: true),
                  ),
                  IconButton(
                    tooltip: 'Increase serving',
                    onPressed: serving < 5
                        ? () => setState(() => serving++)
                        : null,
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              PrimaryButton(
                'Add to journal',
                onPressed: () async {
                  for (var i = 0; i < serving; i++) {
                    m.meals.add('Salad with wheat and white egg');
                  }
                  await m.save();
                  if (mounted) {
                    toast(context, 'Meal added to your journal');
                    open(context, Screen.journal);
                  }
                },
              ),
              const SectionTitle('Nutrition Fact'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  for (final r in [
                    ('78%', Palette.mint),
                    ('13%', Palette.lilac),
                    ('9%', Palette.blue),
                  ])
                    Ring(
                      size: 78,
                      stroke: 7,
                      color: r.$2,
                      value: double.parse(r.$1.replaceAll('%', '')) / 100,
                      child: Txt(r.$1, weight: FontWeight.w500),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              for (final r in [
                ('Protein', '4 g'),
                ('Carbs', '44 g'),
                ('Fats', '2 g'),
                ('Fibers', '4 g'),
                ('Saturated fat', '1.2 g'),
                ('Sugars', '40 g'),
                ('Unsaturated fat', '0.8 g'),
              ])
                Entry(r.$1, '', trailing: Txt(r.$2, color: Palette.slate)),
              const SizedBox(height: 16),
              Panel(
                color: Palette.pale,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Txt('Suggestion', weight: FontWeight.w500),
                    const SizedBox(height: 8),
                    const Txt(
                      'Whether you have a gluten allergy or are looking to cut back on wheat, try a fresh vegetable salad.',
                      size: 13,
                      color: Palette.slate,
                    ),
                    TextButton(
                      onPressed: () => open(context, Screen.recipe),
                      child: const Text('More recipes'),
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
  Widget progress(AppModel m) => PageLayout(
    title: 'Weight',
    light: true,
    color: Palette.lavender,
    padding: 0,
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Label('Current', color: Palette.pale),
                  Txt(
                    '${m.weight.toStringAsFixed(1)} kg',
                    size: 32,
                    color: Colors.white,
                    weight: FontWeight.w500,
                  ),
                ],
              ),
              const Icon(Icons.monitor_weight_rounded, color: Colors.white),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Label('Target', color: Palette.pale),
                  Txt(
                    '55 kg',
                    size: 32,
                    color: Colors.white,
                    weight: FontWeight.w500,
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Txt(
                      'My progress',
                      size: 20,
                      weight: FontWeight.w500,
                    ),
                  ),
                  DropdownButton<String>(
                    value: period == 'WEEK' ? 'Weekly' : 'Monthly',
                    underline: const SizedBox(),
                    items: ['Weekly', 'Monthly']
                        .map(
                          (s) => DropdownMenuItem(
                            value: s,
                            child: Txt(s, size: 12, color: Palette.purple),
                          ),
                        )
                        .toList(),
                    onChanged: (s) => setState(
                      () => period = s == 'Weekly' ? 'WEEK' : 'MONTH',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 26),
              TrendChart(
                height: 180,
                color: Palette.lilac,
                values: period == 'WEEK'
                    ? [.8, .5, .3, .4, .28, .45, .6]
                    : [.9, .65, .7, .35, .45, .28, .5],
              ),
              const SizedBox(height: 32),
              Panel(
                color: Palette.cloud,
                child: Row(
                  children: [
                    const IconTile(
                      Icons.monitor_weight_rounded,
                      color: Palette.coral,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Txt(
                        'BMI ${(m.weight / (1.6 * 1.6)).toStringAsFixed(1)}\nTrack your progress at your own pace.',
                        size: 13,
                        color: Palette.slate,
                      ),
                    ),
                  ],
                ),
              ),
              const SectionTitle('Journal'),
              for (var i = 0; i < m.weightHistory.length.clamp(0, 5); i++)
                Entry(
                  i == 0 ? 'Today' : '${i + 1} days ago',
                  '',
                  trailing: Txt('${m.weightHistory[i].toStringAsFixed(1)} kg'),
                ),
              const SizedBox(height: 20),
              PrimaryButton(
                'Update weight',
                onPressed: () => editWeight(context, m),
              ),
            ],
          ),
        ),
      ],
    ),
  );
  Widget sleepReminder(AppModel m) => PageLayout(
    child: Column(
      children: [
        const SizedBox(height: 26),
        const Icon(Icons.nights_stay_rounded, size: 90, color: Palette.lilac),
        const SizedBox(height: 26),
        const Txt(
          'What time would you like to sleep?',
          size: 24,
          center: true,
          weight: FontWeight.w500,
        ),
        const SizedBox(height: 16),
        const Txt(
          'Sets a reminder to alert you at what point you should go to sleep.',
          center: true,
          color: Palette.muted,
        ),
        const SizedBox(height: 50),
        TextButton(
          onPressed: () async {
            final parts = m.sleepTime.split(':');
            final t = await showTimePicker(
              context: context,
              initialTime: TimeOfDay(
                hour: int.parse(parts[0]),
                minute: int.parse(parts[1]),
              ),
            );
            if (t != null) {
              m.sleepTime =
                  '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
              await m.save();
            }
          },
          child: Txt(
            m.sleepTime,
            size: 60,
            color: Palette.purple,
            weight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 48),
        Panel(
          color: Palette.cloud,
          padding: 12,
          child: SwitchListTile(
            title: const Txt('Add alarm sound'),
            value: m.notificationEnabled,
            onChanged: (v) {
              m.notificationEnabled = v;
              m.save();
            },
          ),
        ),
        const SizedBox(height: 40),
        PrimaryButton(
          'Set reminder',
          onPressed: () {
            m.save();
            toast(context, 'Sleep reminder saved for ${m.sleepTime}');
          },
        ),
      ],
    ),
  );
  Widget weightReminder(AppModel m) => PageLayout(
    child: Column(
      children: [
        const Picture('scale', height: 160),
        const SizedBox(height: 24),
        const Txt('Weight Reminder', size: 24, weight: FontWeight.w500),
        const SizedBox(height: 12),
        const Txt(
          'Choose a day to weigh yourself and we will send you the reminder',
          center: true,
          color: Palette.muted,
        ),
        const SizedBox(height: 32),
        Align(
          alignment: Alignment.centerLeft,
          child: Label('Selected day (${m.reminderDays.length})'),
        ),
        const SizedBox(height: 12),
        for (var i = 0; i < 7; i++)
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            title: Txt(
              [
                'Monday',
                'Tuesday',
                'Wednesday',
                'Thursday',
                'Friday',
                'Saturday',
                'Sunday',
              ][i],
            ),
            value: m.reminderDays.contains(i),
            onChanged: (v) {
              if (v == true) {
                m.reminderDays.add(i);
              } else {
                m.reminderDays.remove(i);
              }
              m.save();
            },
          ),
        const SizedBox(height: 20),
        PrimaryButton(
          'Set reminder',
          onPressed: m.reminderDays.isEmpty
              ? null
              : () {
                  m.save();
                  toast(context, 'Weekly reminder saved');
                },
        ),
      ],
    ),
  );
}

Future<void> editWeight(BuildContext context, AppModel model) async {
  final controller = TextEditingController(
    text: model.weight.toStringAsFixed(1),
  );
  String? error;
  await showDialog<void>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: const Text('Update weight'),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'Weight (kg)',
            errorText: error,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final v = double.tryParse(controller.text);
              if (v == null || v < 20 || v > 350) {
                setState(() => error = 'Enter a weight from 20 to 350 kg');
                return;
              }
              await model.updateWeight(v);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    ),
  );
  controller.dispose();
}
