import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'model.dart';
import 'routes.dart';
import 'theme.dart';

class AppScope extends InheritedNotifier<AppModel> {
  const AppScope({super.key, required AppModel model, required super.child})
    : super(notifier: model);
  static AppModel of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppScope>()!.notifier!;
}

void open(BuildContext context, Screen screen) =>
    Navigator.of(context).pushNamed(screen.path);
void toast(BuildContext context, String message) =>
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));

class PageLayout extends StatelessWidget {
  const PageLayout({
    super.key,
    required this.child,
    this.title,
    this.action,
    this.color = Colors.white,
    this.light = false,
    this.padding = 28,
    this.back = true,
    this.showHeader = true,
  });
  final Widget child;
  final String? title;
  final Widget? action;
  final Color color;
  final bool light, back, showHeader;
  final double padding;
  @override
  Widget build(BuildContext context) => ColoredBox(
    color: color,
    child: SafeArea(
      bottom: false,
      child: Column(
        children: [
          if (showHeader)
            SizedBox(
              height: 54,
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  if (back)
                    IconButton(
                      tooltip: 'Back',
                      icon: Icon(
                        Icons.chevron_left_rounded,
                        color: light ? Colors.white : Palette.ink,
                      ),
                      onPressed: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        } else {
                          open(context, Screen.home);
                        }
                      },
                    )
                  else
                    const SizedBox(width: 48),
                  Expanded(
                    child: Text(
                      title ?? '',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: light ? Colors.white : Palette.ink,
                      ),
                    ),
                  ),
                  action ?? const SizedBox(width: 48),
                  const SizedBox(width: 12),
                ],
              ),
            ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(padding, 10, padding, 28),
              child: child,
            ),
          ),
        ],
      ),
    ),
  );
}

class Txt extends StatelessWidget {
  const Txt(
    this.data, {
    super.key,
    this.size = 14,
    this.color = Palette.ink,
    this.weight = FontWeight.w400,
    this.center = false,
    this.height = 1.55,
    this.maxLines,
  });
  final String data;
  final double size, height;
  final Color color;
  final FontWeight weight;
  final bool center;
  final int? maxLines;
  @override
  Widget build(BuildContext context) => Text(
    data,
    maxLines: maxLines,
    overflow: maxLines == null ? null : TextOverflow.ellipsis,
    textAlign: center ? TextAlign.center : TextAlign.start,
    style: TextStyle(
      fontSize: size,
      color: color,
      fontWeight: weight,
      height: height,
    ),
  );
}

class Label extends StatelessWidget {
  const Label(this.text, {super.key, this.color = Palette.purple});
  final String text;
  final Color color;
  @override
  Widget build(BuildContext context) => Text(
    text.toUpperCase(),
    style: TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: color,
      letterSpacing: 1.8,
    ),
  );
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, {super.key, this.action});
  final String title;
  final VoidCallback? action;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 26, bottom: 16),
    child: Row(
      children: [
        Expanded(child: Txt(title, size: 20, weight: FontWeight.w500)),
        if (action != null)
          IconButton(
            tooltip: 'More $title',
            onPressed: action,
            icon: const Icon(Icons.more_horiz_rounded, color: Palette.muted),
          ),
      ],
    ),
  );
}

class Panel extends StatelessWidget {
  const Panel({
    super.key,
    required this.child,
    this.color = Colors.white,
    this.padding = 20,
    this.onTap,
    this.shadow = false,
  });
  final Widget child;
  final Color color;
  final double padding;
  final VoidCallback? onTap;
  final bool shadow;
  @override
  Widget build(BuildContext context) => Material(
    color: color,
    borderRadius: BorderRadius.circular(22),
    child: InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          boxShadow: shadow
              ? [
                  BoxShadow(
                    color: Palette.purple.withValues(alpha: .08),
                    blurRadius: 25,
                    offset: const Offset(0, 12),
                  ),
                ]
              : null,
        ),
        child: child,
      ),
    ),
  );
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
    this.text, {
    super.key,
    required this.onPressed,
    this.icon,
    this.white = false,
  });
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool white;
  @override
  Widget build(BuildContext context) => FilledButton(
    onPressed: onPressed,
    style: white
        ? FilledButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Palette.purple,
          )
        : null,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[Icon(icon, size: 18), const SizedBox(width: 10)],
        Flexible(child: Text(text, textAlign: TextAlign.center)),
      ],
    ),
  );
}

class Pill extends StatelessWidget {
  const Pill(
    this.text, {
    super.key,
    this.onTap,
    this.selected = false,
    this.color = Palette.pale,
  });
  final String text;
  final VoidCallback? onTap;
  final bool selected;
  final Color color;
  @override
  Widget build(BuildContext context) => Material(
    color: selected ? Palette.purple : color,
    borderRadius: BorderRadius.circular(11),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(11),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Txt(
          text,
          size: 12,
          color: selected ? Colors.white : Palette.purple,
          weight: FontWeight.w500,
        ),
      ),
    ),
  );
}

class Picture extends StatelessWidget {
  const Picture(
    this.name, {
    super.key,
    this.height,
    this.width,
    this.fit = BoxFit.contain,
    this.radius = 0,
  });
  final String name;
  final double? height, width;
  final BoxFit fit;
  final double radius;
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(radius),
    child: Image.asset(
      'assets/images/$name.png',
      height: height,
      width: width,
      fit: fit,
      gaplessPlayback: true,
    ),
  );
}

class Avatar extends StatelessWidget {
  const Avatar({super.key, this.size = 42, this.person});
  final double size;
  final int? person;
  @override
  Widget build(BuildContext context) {
    final emoji = person == null ? AppScope.of(context).avatar : '';
    return SizedBox(
      width: size,
      height: size,
      child: emoji.isEmpty
          ? Picture(
              person == null ? 'avatar' : 'avatar-$person',
              radius: 14,
              fit: BoxFit.cover,
            )
          : DecoratedBox(
              decoration: BoxDecoration(
                color: Palette.pale,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(emoji, style: TextStyle(fontSize: size * .6)),
              ),
            ),
    );
  }
}

class IconTile extends StatelessWidget {
  const IconTile(
    this.icon, {
    super.key,
    this.color = Palette.lavender,
    this.size = 48,
  });
  final IconData icon;
  final Color color;
  final double size;
  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Icon(icon, size: size * .48, color: Colors.white),
  );
}

class Entry extends StatelessWidget {
  const Entry(
    this.title,
    this.subtitle, {
    super.key,
    this.leading,
    this.trailing,
    this.onTap,
  });
  final String title, subtitle;
  final Widget? leading, trailing;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(14),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          if (leading != null) ...[leading!, const SizedBox(width: 14)],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Txt(title, size: 14, weight: FontWeight.w500),
                if (subtitle.isNotEmpty)
                  Txt(subtitle, size: 12, color: Palette.muted),
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    ),
  );
}

class Ring extends StatelessWidget {
  const Ring({
    super.key,
    this.value = .72,
    this.color = Palette.purple,
    this.size = 160,
    this.stroke = 10,
    this.child,
  });
  final double value, size, stroke;
  final Color color;
  final Widget? child;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: size,
    height: size,
    child: CustomPaint(
      painter: RingPainter(value, color, stroke),
      child: Center(child: child),
    ),
  );
}

class RingPainter extends CustomPainter {
  RingPainter(this.value, this.color, this.stroke);
  final double value, stroke;
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    final rect =
        Offset(stroke, stroke) &
        Size(size.width - stroke * 2, size.height - stroke * 2);
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      rect,
      -math.pi / 2,
      2 * math.pi,
      false,
      p..color = color.withValues(alpha: .13),
    );
    canvas.drawArc(
      rect,
      -math.pi / 2,
      math.pi * 2 * value.clamp(0, 1),
      false,
      p..color = color,
    );
  }

  @override
  bool shouldRepaint(RingPainter old) =>
      old.value != value || old.color != color || old.stroke != stroke;
}

class TrendChart extends StatelessWidget {
  const TrendChart({
    super.key,
    this.color = Palette.purple,
    this.height = 140,
    this.bars = false,
    this.labels = true,
    this.values = const [.3, .55, .45, .62, .5, .8, .68],
  });
  final Color color;
  final double height;
  final bool bars, labels;
  final List<double> values;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      SizedBox(
        height: height,
        width: double.infinity,
        child: CustomPaint(painter: TrendPainter(color, bars, values)),
      ),
      if (labels)
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su']
                .map(
                  (d) => Txt(d, size: 10, color: color.withValues(alpha: .65)),
                )
                .toList(),
          ),
        ),
    ],
  );
}

class TrendPainter extends CustomPainter {
  TrendPainter(this.color, this.bars, this.values);
  final Color color;
  final bool bars;
  final List<double> values;
  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = color.withValues(alpha: .1)
      ..strokeWidth = 1;
    for (var i = 0; i < 5; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
    if (bars) {
      for (var i = 0; i < 28; i++) {
        final v = values[i % values.length] * (.45 + (i % 5) * .13);
        final w = size.width / 28;
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(
              i * w,
              size.height * (1 - v),
              w * .48,
              size.height * v,
            ),
            const Radius.circular(3),
          ),
          Paint()..color = color.withValues(alpha: i % 3 == 0 ? 0.5 : 1.0),
        );
      }
    } else {
      final p = Path();
      for (var i = 0; i < values.length; i++) {
        final x = size.width * i / (values.length - 1);
        final y = size.height * (1 - values[i]);
        if (i == 0) {
          p.moveTo(x, y);
        } else {
          final px = size.width * (i - 1) / (values.length - 1),
              py = size.height * (1 - values[i - 1]);
          p.cubicTo((px + x) / 2, py, (px + x) / 2, y, x, y);
        }
      }
      canvas.drawPath(
        p,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round,
      );
      for (var i = 0; i < values.length; i++) {
        canvas.drawCircle(
          Offset(
            size.width * i / (values.length - 1),
            size.height * (1 - values[i]),
          ),
          3,
          Paint()..color = Palette.mint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(TrendPainter old) =>
      old.color != color || old.bars != bars || !identical(old.values, values);
}

class BookmarkButton extends StatelessWidget {
  const BookmarkButton(this.id, {super.key});
  final String id;
  @override
  Widget build(BuildContext context) {
    final m = AppScope.of(context);
    return IconButton(
      tooltip: 'Save $id',
      onPressed: () => m.toggleBookmark(id),
      icon: Icon(
        m.bookmarks.contains(id)
            ? Icons.favorite_rounded
            : Icons.favorite_border_rounded,
        color: m.bookmarks.contains(id) ? Palette.purple : Palette.muted,
        size: 20,
      ),
    );
  }
}
