import 'dart:async';

import 'package:flutter/material.dart';

import '../data/mock_content.dart';
import '../theme/app_theme.dart';

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

/// Стрик: огонёк + точки, зажигающиеся по очереди.
class StreakRow extends StatelessWidget {
  const StreakRow({super.key, required this.days});
  final int days;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text('🔥 $days дней подряд',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13)),
        ),
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

/// График состояния: стек светлых (золото) и трудных (фиолет) чувств по дням —
/// видно, как меняется соотношение.
class MoodChart extends StatelessWidget {
  const MoodChart({super.key, required this.positive, required this.negative});
  final List<double> positive;
  final List<double> negative;

  static const _posColor = AppColors.gold;
  static const _negColor = AppColors.accent;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 70,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeOutCubic,
            builder: (context, v, _) => Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var i = 0; i < positive.length; i++)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: 70 * negative[i] * v,
                            decoration: BoxDecoration(
                              color: _negColor.withValues(alpha: 0.75),
                              borderRadius:
                                  const BorderRadius.vertical(top: Radius.circular(4)),
                            ),
                          ),
                          const SizedBox(height: 1.5),
                          Container(
                            height: 70 * positive[i] * v,
                            decoration: const BoxDecoration(
                              color: _posColor,
                              borderRadius:
                                  BorderRadius.vertical(bottom: Radius.circular(4)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _legendDot(_posColor, MockApp.journalLegendPos),
            const SizedBox(width: 14),
            _legendDot(_negColor.withValues(alpha: 0.75), MockApp.journalLegendNeg),
          ],
        ),
      ],
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 5),
        Text(label, style: AppText.muted.copyWith(fontSize: 10.5)),
      ],
    );
  }
}
