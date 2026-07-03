import 'package:flutter/material.dart';

import '../data/mock_content.dart';
import '../data/models.dart';
import '../theme/app_theme.dart';
import 'ui_kit.dart';

/// Нижняя шторка внутри фрейма: тап по затемнению закрывает.
class SheetOverlay extends StatelessWidget {
  const SheetOverlay({super.key, required this.onClose, required this.child});

  final VoidCallback onClose;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: onClose,
        child: Container(
          color: const Color(0xAA07060F),
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () {},
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
              decoration: const BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                border: Border(top: BorderSide(color: AppColors.line)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.line,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  child,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Содержимое шторки практики: шаги + кнопка «выполнена».
class PracticeSheetContent extends StatelessWidget {
  const PracticeSheetContent({
    super.key,
    required this.title,
    required this.duration,
    required this.steps,
    required this.onDone,
  });

  final String title;
  final String duration;
  final List<PracticeStep> steps;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Eyebrow('Практика'),
        Text('$title · $duration', style: AppText.display.copyWith(fontSize: 19)),
        const SizedBox(height: 12),
        for (var i = 0; i < steps.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 22,
                  height: 22,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.card2,
                    border: Border.all(color: AppColors.line),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Text('${i + 1}',
                      style: const TextStyle(fontSize: 11, color: AppColors.goldSoft)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(steps[i].title,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      Text(steps[i].text, style: AppText.muted.copyWith(fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 4),
        GoldButton(MockApp.practiceDone, onTap: onDone),
      ],
    );
  }
}
