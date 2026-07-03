import 'package:flutter/material.dart';

import '../data/mock_content.dart';
import '../data/models.dart';
import '../theme/app_theme.dart';

/// Панель пояснений: одинаковая структура на каждом шаге —
/// Что это / Как работает / Зачем бизнесу / Решить с Юлей.
class ExplainPanel extends StatelessWidget {
  const ExplainPanel({super.key, required this.step, required this.stepIndex});

  final DemoStep step;
  final int stepIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ШАГ ${stepIndex + 1} ИЗ ${demoSteps.length}',
          style: AppText.eyebrow.copyWith(fontSize: 11),
        ),
        const SizedBox(height: 8),
        Text(step.title, style: AppText.display.copyWith(fontSize: 26)),
        const SizedBox(height: 18),
        _block(
          label: 'Что это',
          child: Text(step.whatIs, style: AppText.body.copyWith(fontSize: 15, height: 1.5)),
        ),
        _block(
          label: 'Как работает',
          child: _bullets(step.howItWorks, marker: '—', markerColor: AppColors.muted),
        ),
        _block(
          label: 'Зачем бизнесу',
          child: _bullets(step.whyBusiness, marker: '✦', markerColor: AppColors.gold),
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 6),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: AppGradients.glowCard,
            border: Border.all(color: AppColors.gold.withValues(alpha: 0.55)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('РЕШИТЬ С ЮЛИЕЙ', style: AppText.eyebrow.copyWith(color: AppColors.goldSoft)),
              const SizedBox(height: 10),
              _bullets(step.decide, marker: '?', markerColor: AppColors.goldSoft),
            ],
          ),
        ),
      ],
    );
  }

  Widget _block({required String label, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(), style: AppText.eyebrow),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Widget _bullets(List<String> items, {required String marker, required Color markerColor}) {
    return Column(
      children: [
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 18,
                  child: Text(marker,
                      style: TextStyle(
                          color: markerColor, fontSize: 13, fontWeight: FontWeight.w600)),
                ),
                Expanded(
                  child: Text(item, style: AppText.body.copyWith(fontSize: 13.5, height: 1.5)),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
