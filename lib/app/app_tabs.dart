import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../data/models.dart';
import '../theme/app_theme.dart';
import 'curator_screen.dart';
import 'journal_screen.dart';
import 'profile_screen.dart';
import 'route_screen.dart';
import 'today_screen.dart';

/// Основной интерфейс приложения: 5 вкладок + нижний таббар.
class AppTabs extends StatelessWidget {
  const AppTabs({super.key});

  static const _tabs = [
    (tab: MainTab.today, glyph: '☀', label: 'Сегодня'),
    (tab: MainTab.route, glyph: '☉', label: 'Маршрут'),
    (tab: MainTab.compass, glyph: '✦', label: 'Компас'),
    (tab: MainTab.journal, glyph: '📖', label: 'Дневник'),
    (tab: MainTab.profile, glyph: '◎', label: 'Профиль'),
  ];

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) => Column(
        children: [
          Expanded(
            child: IndexedStack(
              index: MainTab.values.indexOf(state.mainTab),
              children: const [
                TodayScreen(),
                RouteScreen(),
                CuratorScreen(),
                JournalScreen(),
                ProfileScreen(),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.line)),
            ),
            padding: const EdgeInsets.only(top: 9, bottom: 12, left: 6, right: 6),
            child: Row(
              children: [
                for (final t in _tabs)
                  Expanded(
                    child: GestureDetector(
                      onTap: () => state.mainTab = t.tab,
                      behavior: HitTestBehavior.opaque,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Column(
                          children: [
                            Text(
                              t.glyph,
                              style: TextStyle(
                                fontSize: 16,
                                color: state.mainTab == t.tab
                                    ? AppColors.goldSoft
                                    : AppColors.muted.withValues(alpha: 0.85),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              t.label,
                              style: TextStyle(
                                fontSize: 9.5,
                                color: state.mainTab == t.tab
                                    ? AppColors.goldSoft
                                    : AppColors.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
