import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../data/mock_content.dart';
import '../data/models.dart';
import '../theme/app_theme.dart';
import '../widgets/ui_kit.dart';

class RouteScreen extends StatelessWidget {
  const RouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) => ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          Text(MockApp.routeTitle, style: AppText.display.copyWith(fontSize: 24)),
          const SizedBox(height: 2),
          Text(MockApp.routeSub, style: AppText.muted.copyWith(fontSize: 13)),
          const SizedBox(height: 14),
          for (final ch in MockApp.routeChapters) _ChapterTile(chapter: ch),
          const SizedBox(height: 4),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Eyebrow(MockApp.monthChecklistTitle),
                for (final item in MockApp.monthChecklist)
                  GestureDetector(
                    onTap: () => state.toggleChecklist(item),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        child: Row(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 160),
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: item.done ? AppColors.gold : AppColors.card2,
                                border: Border.all(
                                    color: item.done ? AppColors.gold : AppColors.line),
                                borderRadius: BorderRadius.circular(7),
                              ),
                              alignment: Alignment.center,
                              child: item.done
                                  ? const Text('✓',
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          height: 1.1,
                                          color: Color(0xFF241A10)))
                                  : null,
                            ),
                            const SizedBox(width: 11),
                            Expanded(
                              child: Text(item.title,
                                  style: AppText.body.copyWith(
                                    fontSize: 13,
                                    color: item.done ? AppColors.muted : AppColors.text,
                                    decoration:
                                        item.done ? TextDecoration.lineThrough : null,
                                    decorationColor: AppColors.muted,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          AppCard(
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [for (final p in MockApp.routePills) Pill(p)],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChapterTile extends StatelessWidget {
  const _ChapterTile({required this.chapter});
  final RouteChapter chapter;

  @override
  Widget build(BuildContext context) {
    final locked = chapter.state == ChapterState.locked;
    final current = chapter.state == ChapterState.current;
    return AppCard(
      variant: current ? AppCardVariant.theme : AppCardVariant.plain,
      onTap: locked ? () => AppState.instance.showPaywallOverlay() : null,
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: current ? const Color(0x33D9B26A) : AppColors.card2,
              border: Border.all(color: current ? AppColors.gold : AppColors.line),
            ),
            child: chapter.state == ChapterState.done
                ? const Text('✓',
                    style: TextStyle(fontSize: 15, height: 1.1, color: AppColors.gold))
                : Text(
                    chapter.numeral,
                    style: AppText.display.copyWith(
                      fontSize: 15,
                      color: locked ? AppColors.muted : AppColors.goldSoft,
                    ),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(chapter.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: locked ? AppColors.muted : AppColors.text,
                    )),
                Text(chapter.subtitle, style: AppText.muted.copyWith(fontSize: 11.5)),
                if (current) ...[
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: chapter.progress,
                      minHeight: 3,
                      backgroundColor: const Color(0x33E7CF9C),
                      valueColor: const AlwaysStoppedAnimation(AppColors.gold),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (locked)
            const Text('🔒', style: TextStyle(fontSize: 13, color: AppColors.muted)),
        ],
      ),
    );
  }
}
