import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Роза ветров — фирменный знак: золотая 4-лучевая звезда
/// поверх приглушённой диагональной.
class CompassStar extends StatelessWidget {
  const CompassStar({super.key, this.size = 64, this.dimmed = false});
  final double size;
  final bool dimmed;

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size.square(size), painter: _CompassStarPainter(dimmed: dimmed));
}

class _CompassStarPainter extends CustomPainter {
  _CompassStarPainter({required this.dimmed});
  final bool dimmed;

  Path _star(Offset c, double outerR, double innerR, double rotDeg) {
    final path = Path();
    for (var i = 0; i < 8; i++) {
      final ang = (i * 45 - 90 + rotDeg) * math.pi / 180;
      final r = i.isEven ? outerR : innerR;
      final p = Offset(c.dx + r * math.cos(ang), c.dy + r * math.sin(ang));
      i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
    }
    return path..close();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final s = size.shortestSide;
    final dim = Paint()..color = AppColors.accent.withValues(alpha: dimmed ? 0.25 : 0.45);
    canvas.drawPath(_star(c, s * 0.32, s * 0.06, 45), dim);
    final gold = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [AppColors.goldSoft, AppColors.gold],
      ).createShader(Offset.zero & size);
    if (dimmed) gold.color = AppColors.gold.withValues(alpha: 0.5);
    canvas.drawPath(_star(c, s * 0.42, s * 0.085, 0), gold);
    canvas.drawCircle(c, s * 0.04, Paint()..color = AppColors.goldSoft);
  }

  @override
  bool shouldRepaint(_CompassStarPainter oldDelegate) => oldDelegate.dimmed != dimmed;
}

/// Кнопка входа к Компасу: роза ветров + подпись, стилизована под проводника.
class CompassButton extends StatelessWidget {
  const CompassButton({super.key, required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 14),
          decoration: BoxDecoration(
            gradient: AppGradients.glowCard,
            border: Border.all(color: AppColors.gold),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CompassStar(size: 22),
              const SizedBox(width: 9),
              Text(label, style: const TextStyle(color: AppColors.goldSoft, fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}
