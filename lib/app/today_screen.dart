import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../data/mock_content.dart';
import '../data/models.dart';
import '../theme/app_theme.dart';
import '../widgets/compass_star.dart';
import '../widgets/effects.dart';
import '../widgets/ui_kit.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  bool _practiceOpen = false;
  bool _practiceDone = false;

  String get _greeting {
    final h = DateTime.now().hour;
    if (h >= 5 && h < 12) return 'Доброе утро';
    if (h >= 12 && h < 18) return 'Добрый день';
    return 'Добрый вечер';
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          children: [
            Text('$_greeting, ${MockApp.userName}', style: AppText.muted.copyWith(fontSize: 13)),
            const SizedBox(height: 2),
            Text('Сегодня', style: AppText.display.copyWith(fontSize: 24)),
            const SizedBox(height: 12),
            _pathHeader(),
            AppCard(
              variant: AppCardVariant.glow,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Eyebrow(MockApp.weatherDayEyebrow),
                  Text(MockApp.weatherDay, style: AppText.body.copyWith(fontSize: 14.5)),
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  child: TarotFlipCard(
                    name: MockApp.tarotName,
                    meaning: MockApp.tarotMeaning,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(child: _practiceMini()),
              ],
            ),
            const SizedBox(height: 12),
            const AppCard(child: StreakRow(days: MockApp.streakDays)),
            CompassButton(
              label: MockApp.askCompass,
              onTap: () => state.mainTab = MainTab.compass,
            ),
          ],
        ),
        if (_practiceOpen) _practiceSheet(),
      ],
    );
  }

  Widget _pathHeader() {
    return AppCard(
      variant: AppCardVariant.theme,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Eyebrow('☉ ${MockApp.seasonLabel}'),
              const Spacer(),
              Text(MockApp.dayLabel, style: AppText.muted.copyWith(fontSize: 11)),
            ],
          ),
          Text(MockApp.monthTheme,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          // Линия-путь: где я в теме месяца.
          LayoutBuilder(
            builder: (context, constraints) {
              final w = constraints.maxWidth;
              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: MockApp.dayProgress),
                duration: const Duration(milliseconds: 900),
                curve: Curves.easeOutCubic,
                builder: (context, v, _) => SizedBox(
                  height: 14,
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      Container(height: 3, color: const Color(0x33E7CF9C)),
                      Container(height: 3, width: w * v, color: AppColors.gold),
                      Positioned(
                        left: (w - 12) * v,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.goldSoft,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _practiceMini() {
    return GestureDetector(
      onTap: () => setState(() => _practiceOpen = true),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          height: 118,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.card2,
            border: Border.all(color: _practiceDone ? AppColors.gold : AppColors.line),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_practiceDone ? '✦' : '🌬️',
                  style: TextStyle(
                    fontSize: 24,
                    color: _practiceDone ? AppColors.gold : null,
                  )),
              const SizedBox(height: 8),
              const Text('Практика дня',
                  style: TextStyle(fontSize: 12, color: AppColors.text)),
              Text(
                _practiceDone
                    ? 'выполнена'
                    : '${MockApp.practiceTitle} · ${MockApp.practiceDuration}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10, color: AppColors.muted),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _practiceSheet() {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () => setState(() => _practiceOpen = false),
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
                  const Eyebrow('Практика дня'),
                  Text('${MockApp.practiceTitle} · ${MockApp.practiceDuration}',
                      style: AppText.display.copyWith(fontSize: 19)),
                  const SizedBox(height: 12),
                  for (var i = 0; i < MockApp.practiceSteps.length; i++)
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
                                Text(MockApp.practiceSteps[i].title,
                                    style: const TextStyle(
                                        fontSize: 13, fontWeight: FontWeight.w600)),
                                Text(MockApp.practiceSteps[i].text,
                                    style: AppText.muted.copyWith(fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 4),
                  GoldButton(
                    MockApp.practiceDone,
                    onTap: () => setState(() {
                      _practiceOpen = false;
                      _practiceDone = true;
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
