import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/model.dart';
import '../core/routes.dart';
import '../core/theme.dart';
import '../core/widgets.dart';

const onboardingSteps = [
  Screen.mobile,
  Screen.verification,
  Screen.password,
  Screen.fingerprint,
  Screen.photo,
  Screen.interest,
  Screen.goal,
  Screen.gender,
  Screen.fitness,
  Screen.weight,
  Screen.permission,
];

class OnboardingPage extends StatefulWidget {
  const OnboardingPage(this.screen, {super.key});
  final Screen screen;
  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final phone = TextEditingController(text: '82227580727'),
      code = TextEditingController(),
      password = TextEditingController();
  String? error;
  bool obscure = true, pounds = true;
  double selectedWeight = 120;
  @override
  void dispose() {
    phone.dispose();
    code.dispose();
    password.dispose();
    super.dispose();
  }

  void next() {
    final index = onboardingSteps.indexOf(widget.screen);
    open(
      context,
      index >= 0 && index < onboardingSteps.length - 1
          ? onboardingSteps[index + 1]
          : Screen.success,
    );
  }

  Widget heading(String title, {String? subtitle}) => Column(
    children: [
      Label(
        'Step ${onboardingSteps.indexOf(widget.screen) + 1}/${onboardingSteps.length}',
      ),
      const SizedBox(height: 12),
      Txt(title, size: 25, center: true, weight: FontWeight.w500),
      if (subtitle != null) ...[
        const SizedBox(height: 16),
        Txt(subtitle, center: true, color: Palette.muted),
      ],
      const SizedBox(height: 30),
    ],
  );
  @override
  Widget build(BuildContext context) {
    final m = AppScope.of(context);
    if (widget.screen == Screen.welcome) {
      return PageLayout(
        back: false,
        showHeader: false,
        child: Column(
          children: [
            const SizedBox(height: 32),
            const Icon(
              Icons.all_inclusive_rounded,
              color: Palette.purple,
              size: 58,
            ),
            const SizedBox(height: 26),
            const Txt(
              'Welcome to\nMomotaro',
              size: 29,
              center: true,
              weight: FontWeight.w500,
            ),
            const SizedBox(height: 12),
            const Txt(
              'Your everyday companion for\na healthier, happier life.',
              center: true,
              color: Palette.slate,
            ),
            const SizedBox(height: 24),
            const Picture('welcome', height: 285),
            const SizedBox(height: 32),
            PrimaryButton(
              'Get Started',
              onPressed: () => open(context, Screen.mobile),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => open(context, Screen.mobile),
              child: const Text('Already have account? Sign in'),
            ),
          ],
        ),
      );
    }
    if (widget.screen == Screen.success) {
      return PageLayout(
        back: false,
        showHeader: false,
        color: Palette.lavender,
        light: true,
        child: Column(
          children: [
            const SizedBox(height: 60),
            const Picture('success', height: 290),
            const SizedBox(height: 40),
            const Txt(
              'You are ready to go!',
              size: 27,
              color: Colors.white,
              weight: FontWeight.w500,
              center: true,
            ),
            const SizedBox(height: 18),
            const Txt(
              'Thanks for taking your time to create account with us. Now this is the fun part, let’s explore the app.',
              color: Colors.white,
              center: true,
            ),
            const SizedBox(height: 45),
            PrimaryButton(
              'Get Started!',
              white: true,
              onPressed: () async {
                m.completed = true;
                await m.save();
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    Screen.home.path,
                    (_) => false,
                  );
                }
              },
            ),
          ],
        ),
      );
    }
    final index = onboardingSteps.indexOf(widget.screen);
    return PageLayout(
      color: const Color(0xFFFAFAFD),
      action: TextButton(onPressed: next, child: const Text('Skip')),
      title: null,
      child: Column(
        children: [
          SizedBox(
            width: 120,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: (index + 1) / onboardingSteps.length,
                minHeight: 6,
                color: Palette.purple,
                backgroundColor: Palette.pale,
              ),
            ),
          ),
          const SizedBox(height: 48),
          ...content(m),
          if (error != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Txt(error!, color: const Color(0xFFCF4A62), center: true),
            ),
        ],
      ),
    );
  }

  List<Widget> content(AppModel m) => switch (widget.screen) {
    Screen.mobile => [
      heading(
        'Let’s start with your\nmobile number',
        subtitle: 'Number we can use to reach you',
      ),
      TextField(
        controller: phone,
        keyboardType: TextInputType.phone,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(15),
        ],
        decoration: const InputDecoration(
          prefixText: '🇮🇩 +62   ',
          hintText: 'Mobile number',
        ),
      ),
      const SizedBox(height: 85),
      PrimaryButton(
        'Verify Now',
        onPressed: () {
          if (phone.text.length < 8) {
            setState(() => error = 'Enter a valid mobile number');
            return;
          }
          next();
        },
      ),
    ],
    Screen.verification => [
      heading('Verify your number', subtitle: 'We’ll text you on 08223780727.'),
      TextField(
        controller: code,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w500,
          letterSpacing: 18,
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(4),
        ],
        decoration: const InputDecoration(hintText: '• • • •'),
      ),
      const SizedBox(height: 25),
      TextButton(
        onPressed: () => toast(context, 'Your verification code is 2828'),
        child: const Text('Send me a new code'),
      ),
      const SizedBox(height: 70),
      PrimaryButton(
        'Continue',
        onPressed: () {
          if (code.text != '2828') {
            setState(() => error = 'Please enter the 4-digit code sent to you');
            return;
          }
          next();
        },
      ),
    ],
    Screen.password => [
      heading('Set your password'),
      TextField(
        controller: password,
        obscureText: obscure,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          hintText: 'Your password',
          suffixIcon: IconButton(
            tooltip: 'Show password',
            onPressed: () => setState(() => obscure = !obscure),
            icon: Icon(
              obscure
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
            ),
          ),
        ),
      ),
      const SizedBox(height: 20),
      LinearProgressIndicator(
        value:
            [
              password.text.length >= 8,
              RegExp('[A-Z]').hasMatch(password.text),
              RegExp('[0-9]').hasMatch(password.text),
              RegExp(r'[^a-zA-Z0-9]').hasMatch(password.text),
            ].where((v) => v).length /
            4,
        color: Palette.lilac,
        backgroundColor: Palette.pale,
        minHeight: 5,
      ),
      const SizedBox(height: 18),
      const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Txt('• 8+ characters\n• 1 symbol', size: 13, color: Palette.slate),
          Txt('• 1 uppercase\n• 1 number', size: 13, color: Palette.slate),
        ],
      ),
      const SizedBox(height: 85),
      PrimaryButton(
        'Continue',
        onPressed: () {
          if (password.text.length < 8 ||
              !RegExp('[A-Z]').hasMatch(password.text) ||
              !RegExp('[0-9]').hasMatch(password.text) ||
              !RegExp(r'[^a-zA-Z0-9]').hasMatch(password.text)) {
            setState(
              () => error = 'Please meet all four password requirements',
            );
            return;
          }
          next();
        },
      ),
    ],
    Screen.fingerprint => [
      const Picture('fingerprint', height: 230),
      const SizedBox(height: 34),
      heading(
        'Enable Fingerprint',
        subtitle:
            'If you enable touch ID, you don’t need to enter your password when you login.',
      ),
      const SizedBox(height: 55),
      PrimaryButton(
        'Activate',
        onPressed: () {
          toast(context, 'Fingerprint preference saved');
          next();
        },
      ),
    ],
    Screen.photo => [
      heading('Profile Picture'),
      const SizedBox(height: 32),
      Wrap(
        spacing: 12,
        runSpacing: 12,
        alignment: WrapAlignment.center,
        children: ['👻', '🐵', '😺', '🐼', '🦊']
            .map(
              (e) => GestureDetector(
                onTap: () {
                  m.avatar = e;
                  m.save();
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: m.avatar == e ? 88 : 70,
                  height: 88,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: m.avatar == e ? Palette.lavender : Colors.white,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Text(e, style: const TextStyle(fontSize: 40)),
                ),
              ),
            )
            .toList(),
      ),
      const SizedBox(height: 32),
      const Txt(
        'You can select a photo from one of these emoji as your profile picture',
        center: true,
        color: Palette.muted,
      ),
      const SizedBox(height: 28),
      TextButton(
        onPressed: () {
          m.avatar = '';
          m.save();
        },
        child: const Text('Use original profile photo'),
      ),
      const SizedBox(height: 55),
      PrimaryButton('Continue', onPressed: next),
    ],
    Screen.interest => [
      heading('Time to customize\nyour interest'),
      const SizedBox(height: 16),
      GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 20,
        crossAxisSpacing: 12,
        childAspectRatio: .88,
        children:
            [
                  ('🍉', 'Nutrition'),
                  ('🌾', 'Organic'),
                  ('🍃', 'Meditation'),
                  ('🏂', 'Sports'),
                  ('🚬', 'Smoke Free'),
                  ('🛏', 'Sleep'),
                  ('💪', 'Health'),
                  ('👟', 'Running'),
                  ('🥑', 'Vegan'),
                ]
                .map(
                  (i) => InkWell(
                    onTap: () {
                      if (!m.interests.add(i.$2)) m.interests.remove(i.$2);
                      m.save();
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: m.interests.contains(i.$2)
                                ? Palette.lilac
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            i.$1,
                            style: const TextStyle(fontSize: 30),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Txt(i.$2, size: 11, center: true),
                      ],
                    ),
                  ),
                )
                .toList(),
      ),
      const SizedBox(height: 40),
      PrimaryButton('Continue', onPressed: next),
    ],
    Screen.goal => [
      heading(
        'Let us know how\nwe can help you',
        subtitle: 'You always can change this later',
      ),
      for (final g in [
        ('🍉', 'Weight loss'),
        ('🛏', 'Better sleeping habit'),
        ('🥑', 'Track my nutrition'),
        ('💪', 'Improve overall fitness'),
      ])
        Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Panel(
            padding: 16,
            color: m.goals.contains(g.$2)
                ? (g.$2 == 'Weight loss' ? Palette.coral : Palette.slate)
                : Colors.white,
            onTap: () {
              if (!m.goals.add(g.$2)) m.goals.remove(g.$2);
              m.save();
            },
            child: Row(
              children: [
                Text(g.$1, style: const TextStyle(fontSize: 26)),
                const SizedBox(width: 14),
                Expanded(
                  child: Txt(
                    g.$2,
                    color: m.goals.contains(g.$2) ? Colors.white : Palette.ink,
                    weight: FontWeight.w500,
                  ),
                ),
                Icon(
                  m.goals.contains(g.$2)
                      ? Icons.check_circle_rounded
                      : Icons.circle_outlined,
                  color: m.goals.contains(g.$2) ? Colors.white : Palette.muted,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      const SizedBox(height: 40),
      PrimaryButton('Continue', onPressed: next),
    ],
    Screen.gender => [
      heading('Which one are you?'),
      const SizedBox(height: 15),
      Row(
        children: [
          for (final g in ['Male', 'Female'])
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Panel(
                  color: m.gender == g ? Palette.lavender : Colors.white,
                  onTap: () {
                    m.gender = g;
                    m.save();
                  },
                  child: Column(
                    children: [
                      Picture(g.toLowerCase(), height: 145),
                      const SizedBox(height: 15),
                      Txt(g, color: m.gender == g ? Colors.white : Palette.ink),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      const SizedBox(height: 30),
      const Txt(
        'To give you a customized experience we need to know your gender',
        center: true,
        color: Palette.muted,
      ),
      const SizedBox(height: 60),
      PrimaryButton('Continue', onPressed: next),
      const SizedBox(height: 15),
      TextButton(
        onPressed: () {
          m.gender = 'Prefer not to choose';
          m.save();
          next();
        },
        child: const Text('Prefer not to choose'),
      ),
    ],
    Screen.fitness => [
      heading('What’s your current\nfitness level?'),
      Panel(
        color: Palette.pale,
        child: Column(
          children: [
            const Picture('fitness', height: 225),
            const SizedBox(height: 20),
            DropdownButton<String>(
              value: m.fitness,
              isExpanded: true,
              underline: const SizedBox(),
              items: ['Low Intensity', 'Moderate Intensity', 'High Intensity']
                  .map(
                    (s) => DropdownMenuItem(
                      value: s,
                      child: Txt(s, size: 18, weight: FontWeight.w500),
                    ),
                  )
                  .toList(),
              onChanged: (v) {
                m.fitness = v!;
                m.save();
              },
            ),
            const Txt(
              'I always work out regularly two or three times a week.',
              center: true,
              color: Palette.slate,
            ),
            const SizedBox(height: 25),
            PrimaryButton('Select', onPressed: next),
          ],
        ),
      ),
    ],
    Screen.weight => [
      const Picture('scale', height: 155),
      const SizedBox(height: 22),
      heading('What is your weight?'),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Pill(
            'lbs',
            selected: pounds,
            onTap: () => setState(() {
              if (!pounds) selectedWeight *= 2.20462;
              pounds = true;
            }),
          ),
          const SizedBox(width: 12),
          Pill(
            'kg',
            selected: !pounds,
            onTap: () => setState(() {
              if (pounds) selectedWeight /= 2.20462;
              pounds = false;
            }),
          ),
        ],
      ),
      const SizedBox(height: 35),
      Txt(
        '${selectedWeight.round()} ${pounds ? 'lbs' : 'kg'}',
        size: 45,
        weight: FontWeight.w500,
      ),
      const SizedBox(height: 16),
      Slider(
        value: selectedWeight.clamp(pounds ? 44 : 20, pounds ? 550 : 250),
        min: pounds ? 44 : 20,
        max: pounds ? 550 : 250,
        divisions: pounds ? 506 : 230,
        onChanged: (v) => setState(() => selectedWeight = v),
      ),
      const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Txt('Light', size: 11, color: Palette.muted),
          Icon(Icons.arrow_drop_up_rounded, color: Palette.purple),
          Txt('Heavy', size: 11, color: Palette.muted),
        ],
      ),
      const SizedBox(height: 50),
      PrimaryButton(
        'Continue',
        onPressed: () async {
          await m.updateWeight(
            pounds ? selectedWeight / 2.20462 : selectedWeight,
          );
          if (mounted) next();
        },
      ),
    ],
    Screen.permission => [
      heading('Do you want to turn\non notification?'),
      const SizedBox(height: 16),
      Container(
        width: 200,
        height: 200,
        decoration: const BoxDecoration(
          color: Palette.pale,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.notifications_active_rounded,
          color: Palette.purple,
          size: 110,
        ),
      ),
      const SizedBox(height: 32),
      for (final p in [
        (Icons.auto_awesome_rounded, 'New weekly healthy reminder'),
        (Icons.local_fire_department_rounded, 'Motivational reminder'),
        (Icons.favorite_rounded, 'Personalised program'),
      ])
        Entry(p.$2, '', leading: Icon(p.$1, color: Palette.purple)),
      const SizedBox(height: 30),
      PrimaryButton(
        'Allow',
        onPressed: () {
          m.notificationEnabled = true;
          m.save();
          next();
        },
      ),
    ],
    _ => [],
  };
}
