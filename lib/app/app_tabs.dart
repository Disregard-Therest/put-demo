import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../data/models.dart';
import '../theme/app_theme.dart';
import '../widgets/compass_star.dart';
import 'curator_screen.dart';
import 'journal_screen.dart';
import 'profile_screen.dart';
import 'route_screen.dart';
import 'today_screen.dart';

/// Основной интерфейс приложения: 5 вкладок, Компас — FAB по центру.
class AppTabs extends StatelessWidget {
  const AppTabs({super.key});

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
            padding: const EdgeInsets.only(top: 7, bottom: 10, left: 6, right: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _tab(state, MainTab.today, '☀', 'Главная'),
                _tab(state, MainTab.route, '☉', 'Маршрут'),
                _compassFab(state),
                _tab(state, MainTab.journal, '📖', 'Дневник'),
                _tab(state, MainTab.profile, '◎', 'Профиль'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tab(AppState state, MainTab tab, String glyph, String label) {
    final active = state.mainTab == tab;
    return Expanded(
      child: GestureDetector(
        onTap: () => state.mainTab = tab,
        behavior: HitTestBehavior.opaque,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                glyph,
                style: TextStyle(
                  fontSize: 16,
                  color: active
                      ? AppColors.goldSoft
                      : AppColors.muted.withValues(alpha: 0.85),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  fontSize: 9.5,
                  color: active ? AppColors.goldSoft : AppColors.muted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Компас — приподнятый FAB в центре таббара.
  Widget _compassFab(AppState state) {
    final active = state.mainTab == MainTab.compass;
    return Expanded(
      child: GestureDetector(
        onTap: () => state.mainTab = MainTab.compass,
        behavior: HitTestBehavior.opaque,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Transform.translate(
                offset: const Offset(0, -16),
                child: Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    gradient: AppGradients.glowCard,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: active ? AppColors.goldSoft : AppColors.gold,
                      width: active ? 1.8 : 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFD9B26A)
                            .withValues(alpha: active ? 0.45 : 0.25),
                        blurRadius: active ? 22 : 14,
                        spreadRadius: 1,
                      ),
                      const BoxShadow(
                        color: Color(0xCC07060F),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const CompassStar(size: 30),
                ),
              ),
              Transform.translate(
                offset: const Offset(0, -12),
                child: Text(
                  'Компас',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w600,
                    color: active ? AppColors.goldSoft : AppColors.gold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
