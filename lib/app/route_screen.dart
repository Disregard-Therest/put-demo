import 'package:flutter/material.dart';

import '../data/mock_content.dart';
import '../theme/app_theme.dart';
import '../widgets/ui_kit.dart';

class RouteScreen extends StatefulWidget {
  const RouteScreen({super.key});

  @override
  State<RouteScreen> createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {
  int? _expanded = 0; // текущий месяц раскрыт по умолчанию

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      children: [
        Text(MockApp.routeTitle, style: AppText.display.copyWith(fontSize: 24)),
        const SizedBox(height: 2),
        Text(MockApp.routeSub, style: AppText.muted.copyWith(fontSize: 13)),
        const SizedBox(height: 14),
        for (var i = 0; i < MockApp.yearMonths.length; i++) _monthTile(i),
      ],
    );
  }

  Widget _monthTile(int index) {
    final m = MockApp.yearMonths[index];
    final isCurrent = index == 0;
    final expanded = _expanded == index;
    return AppCard(
      variant: isCurrent ? AppCardVariant.theme : AppCardVariant.plain,
      margin: const EdgeInsets.only(bottom: 8),
      onTap: () => setState(() => _expanded = expanded ? null : index),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCurrent ? const Color(0x33D9B26A) : AppColors.card2,
                  border: Border.all(color: isCurrent ? AppColors.gold : AppColors.line),
                ),
                child: Text('${index + 1}',
                    style: TextStyle(
                      fontSize: 12,
                      color: isCurrent ? AppColors.goldSoft : AppColors.muted,
                    )),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(m.month,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isCurrent ? AppColors.goldSoft : AppColors.text,
                            )),
                        if (isCurrent) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                            decoration: BoxDecoration(
                              gradient: AppGradients.goldCta,
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: const Text('сейчас',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF241A10),
                                )),
                          ),
                        ],
                      ],
                    ),
                    Text(m.theme,
                        maxLines: expanded ? null : 1,
                        overflow: expanded ? null : TextOverflow.ellipsis,
                        style: AppText.muted.copyWith(fontSize: 11.5)),
                  ],
                ),
              ),
              Text(expanded ? '▾' : '▸',
                  style: const TextStyle(fontSize: 12, color: AppColors.muted)),
            ],
          ),
          if (isCurrent) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: const LinearProgressIndicator(
                value: MockApp.dayProgress,
                minHeight: 3,
                backgroundColor: Color(0x33E7CF9C),
                valueColor: AlwaysStoppedAnimation(AppColors.gold),
              ),
            ),
          ],
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 220),
            crossFadeState: expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: _monthTopics(m.topics),
            ),
          ),
        ],
      ),
    );
  }

  /// Ключевые темы месяца — у каждого свои.
  Widget _monthTopics(List<String> topics) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Eyebrow(MockApp.routeTopicsTitle),
        for (final t in topics)
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('✦ ', style: TextStyle(color: AppColors.gold, fontSize: 11)),
                Expanded(child: Text(t, style: AppText.muted.copyWith(fontSize: 12.5))),
              ],
            ),
          ),
      ],
    );
  }
}
