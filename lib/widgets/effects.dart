import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'compass_star.dart';

/// Текст, печатающийся посимвольно — «ассистент отвечает».
class TypingText extends StatefulWidget {
  const TypingText(
    this.text, {
    super.key,
    this.style = AppText.body,
    this.speed = const Duration(milliseconds: 18),
    this.onDone,
    this.onTick,
  });

  final String text;
  final TextStyle style;
  final Duration speed;
  final VoidCallback? onDone;
  final VoidCallback? onTick;

  @override
  State<TypingText> createState() => _TypingTextState();
}

class _TypingTextState extends State<TypingText> {
  Timer? _timer;
  int _visible = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(widget.speed, (t) {
      if (_visible >= widget.text.length) {
        t.cancel();
        widget.onDone?.call();
        return;
      }
      setState(() => _visible += 2);
      widget.onTick?.call();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final done = _visible >= widget.text.length;
    final shown = widget.text.substring(0, _visible.clamp(0, widget.text.length));
    return Text.rich(
      TextSpan(children: [
        TextSpan(text: shown),
        if (!done) const TextSpan(text: ' ▍', style: TextStyle(color: AppColors.gold)),
      ]),
      style: widget.style,
    );
  }
}

/// Карта дня: рубашка → тап → флип с переворотом → значение.
class TarotFlipCard extends StatefulWidget {
  const TarotFlipCard({super.key, required this.name, required this.meaning});
  final String name;
  final String meaning;

  @override
  State<TarotFlipCard> createState() => _TarotFlipCardState();
}

class _TarotFlipCardState extends State<TarotFlipCard> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 550),
  );

  void _flip() {
    _controller.isDismissed
        ? _controller.forward()
        : _controller.reverse();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final t = Curves.easeInOutCubic.transform(_controller.value);
            final angle = t * 3.14159;
            final showFace = angle > 3.14159 / 2;
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.0015)
                ..rotateY(angle),
              child: showFace
                  ? Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..rotateY(3.14159),
                      child: _face(),
                    )
                  : _back(),
            );
          },
        ),
      ),
    );
  }

  Widget _back() => Container(
        height: 118,
        decoration: BoxDecoration(
          gradient: AppGradients.glowCard,
          border: Border.all(color: const Color(0xFF4B3A86)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CompassStar(size: 34, dimmed: true),
            SizedBox(height: 8),
            Text('Карта дня', style: TextStyle(fontSize: 12, color: AppColors.muted)),
            Text('нажмите, чтобы открыть',
                style: TextStyle(fontSize: 10, color: AppColors.muted)),
          ],
        ),
      );

  Widget _face() => Container(
        height: 118,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          gradient: AppGradients.themeCard,
          border: Border.all(color: AppColors.gold),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.name,
                style: AppText.display.copyWith(fontSize: 15, color: AppColors.goldSoft)),
            const SizedBox(height: 6),
            Text(
              widget.meaning,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10.5, height: 1.35, color: AppColors.text),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );
}

/// Стрик: огонёк + точки, зажигающиеся по очереди.
class StreakRow extends StatelessWidget {
  const StreakRow({super.key, required this.days});
  final int days;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('🔥 $days дней подряд', style: const TextStyle(fontSize: 13)),
        Row(
          children: [
            for (var i = 0; i < 7; i++)
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: Duration(milliseconds: 250 + i * 120),
                curve: Curves.easeOut,
                builder: (context, v, _) {
                  final lit = i < days && v > (i / 7);
                  return Container(
                    width: 15,
                    height: 15,
                    margin: const EdgeInsets.only(left: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: lit ? AppColors.gold : const Color(0xFF2A2150),
                      border: Border.all(color: lit ? AppColors.gold : AppColors.line),
                    ),
                  );
                },
              ),
          ],
        ),
      ],
    );
  }
}

/// График состояния — бары, подрастающие при появлении.
class MoodChart extends StatelessWidget {
  const MoodChart({super.key, required this.values});
  final List<double> values;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeOutCubic,
        builder: (context, v, _) => Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (final h in values)
              Expanded(
                child: Container(
                  height: 70 * h * v,
                  margin: const EdgeInsets.symmetric(horizontal: 2.5),
                  decoration: const BoxDecoration(
                    gradient: AppGradients.chartBar,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
