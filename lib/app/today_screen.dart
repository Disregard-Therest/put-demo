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
  bool _tarotOpen = false;
  int _programTab = 0; // 0 — месяц, 1 — год
  bool _programExpanded = false;
  ProgramTask? _openTask;
  final _goalController = TextEditingController();

  @override
  void dispose() {
    _goalController.dispose();
    super.dispose();
  }

  void _demoSnack(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), behavior: SnackBarBehavior.floating),
    );
  }

  void _openTaskSheet(ProgramTask task) {
    _goalController.text = task.goalText;
    setState(() => _openTask = task);
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          children: [
            Text('${MockApp.userName}, привет!',
                style: AppText.display.copyWith(fontSize: 21)),
            const SizedBox(height: 14),
            const AppCard(child: StreakRow(days: MockApp.streakDays)),
            _programCard(state),
            _compassTaskCard(state),
            _warningBadge(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _tarotMini()),
                const SizedBox(width: 10),
                Expanded(child: _practiceMini()),
              ],
            ),
            const SizedBox(height: 12),
            AppCard(
              onTap: () => state.mainTab = MainTab.journal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Eyebrow(MockApp.journalNudgeEyebrow),
                  Text(MockApp.journalNudgeText, style: AppText.body.copyWith(fontSize: 13)),
                  const SizedBox(height: 6),
                  Text('записать →',
                      style: AppText.muted.copyWith(fontSize: 11.5, color: AppColors.goldSoft)),
                ],
              ),
            ),
          ],
        ),
        if (_practiceOpen) _practiceSheet(),
        if (_tarotOpen) _tarotSheet(),
        if (_openTask != null) _taskSheet(_openTask!),
      ],
    );
  }

  // ── Главный виджет: месяц/год + программа ────────────────────────────────

  Widget _programCard(AppState state) {
    final isYear = _programTab == 1;
    return AppCard(
      variant: AppCardVariant.theme,
      // Разворот — только у месяца; год всегда показан целиком.
      onTap: isYear ? null : () => setState(() => _programExpanded = !_programExpanded),
      child: ListenableBuilder(
        listenable: state,
        builder: (context, _) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Eyebrow(
                      isYear ? MockApp.weatherYearEyebrow : '☉ ${MockApp.monthLabel}'),
                ),
                SizedBox(
                  width: 128,
                  child: SegmentedControl(
                    labels: const ['Месяц', 'Год'],
                    selected: _programTab,
                    onChanged: (i) => setState(() => _programTab = i),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            // AnimatedSize: скрытый контент плавно выезжает, без «дёрганья».
            AnimatedSize(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOutCubic,
              alignment: Alignment.topCenter,
              child: Column(
                key: ValueKey(_programTab),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: isYear ? _yearContent() : _monthContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _monthContent() {
    final tasks = MockApp.monthTasks;
    final visible = _programExpanded ? tasks : tasks.where((t) => !t.done).toList();
    final doneCount = tasks.where((t) => t.done).length;
    return [
      Row(
        children: [
          Expanded(
            child: Text(MockApp.monthTheme,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(width: 8),
          Text(MockApp.dayLabel, style: AppText.muted.copyWith(fontSize: 11)),
        ],
      ),
      if (_programExpanded) ...[
        const SizedBox(height: 4),
        Text(MockApp.weatherMonthText, style: AppText.muted.copyWith(fontSize: 12.5)),
      ],
      const SizedBox(height: 10),
      _progressLine(),
      const SizedBox(height: 10),
      for (final t in visible) _taskRow(t),
      const SizedBox(height: 4),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(doneCount > 0 ? 'выполнено: $doneCount ✓' : '',
              style: AppText.muted.copyWith(fontSize: 10.5)),
          Text(
            _programExpanded ? MockApp.programLess : MockApp.programMore,
            style: AppText.muted.copyWith(fontSize: 11, color: AppColors.goldSoft),
          ),
        ],
      ),
    ];
  }

  List<Widget> _yearContent() {
    return [
      Text(MockApp.weatherYearTitle,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
      const SizedBox(height: 4),
      Text(MockApp.weatherYearText, style: AppText.muted.copyWith(fontSize: 12.5)),
      const SizedBox(height: 10),
      for (final t in MockApp.yearTasks) _taskRow(t),
    ];
  }

  Widget _progressLine() {
    // Стабильный ключ: при развороте карточки позиция в колонке меняется,
    // без ключа Flutter пересоздаёт состояние и анимация проигрывается заново.
    return LayoutBuilder(
      key: const ValueKey('month-progress'),
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
    );
  }

  /// Пункт программы: выполненные — приглушены, закрытые — с датой открытия.
  Widget _taskRow(ProgramTask task) {
    final done = task.done;
    return GestureDetector(
      onTap: () => _openTaskSheet(task),
      behavior: HitTestBehavior.opaque,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 7),
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: done ? AppColors.gold : const Color(0x2207060F),
                  border: Border.all(color: done ? AppColors.gold : AppColors.line),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: done
                    ? const Text('✓',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            height: 1.1,
                            color: Color(0xFF241A10)))
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: done || task.locked ? AppColors.muted : AppColors.text,
                        decoration: done ? TextDecoration.lineThrough : null,
                        decorationColor: AppColors.muted,
                      ),
                    ),
                    if (!done && (task.locked || task.goalText.isNotEmpty))
                      Text(
                        task.locked ? task.lockedNote! : '«${task.goalText}»',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.muted.copyWith(
                          fontSize: 10.5,
                          color: task.goalText.isNotEmpty
                              ? AppColors.goldSoft
                              : AppColors.muted,
                        ),
                      ),
                  ],
                ),
              ),
              if (!done && task.meta != null) ...[
                const SizedBox(width: 6),
                Text(task.meta!, style: AppText.muted.copyWith(fontSize: 10.5)),
              ],
              const SizedBox(width: 6),
              Text('▸',
                  style: TextStyle(
                      fontSize: 11, color: done ? AppColors.line : AppColors.muted)),
            ],
          ),
        ),
      ),
    );
  }

  // ── Задание от Компаса ───────────────────────────────────────────────────

  Widget _compassTaskCard(AppState state) {
    return AppCard(
      variant: AppCardVariant.glow,
      onTap: () => state.mainTab = MainTab.compass,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Eyebrow(MockApp.compassTaskEyebrow),
          Text(MockApp.compassTaskText, style: AppText.body.copyWith(fontSize: 13.5)),
          const SizedBox(height: 8),
          Row(
            children: [
              const CompassStar(size: 15, dimmed: true),
              const SizedBox(width: 6),
              Text(MockApp.compassTaskCta,
                  style: AppText.muted.copyWith(fontSize: 11.5, color: AppColors.goldSoft)),
            ],
          ),
        ],
      ),
    );
  }

  /// Один бадж-предостережение периода на всю ширину.
  Widget _warningBadge() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2150),
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        MockApp.periodWarning,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 12, color: AppColors.goldSoft),
      ),
    );
  }

  // ── Шторка пункта программы ──────────────────────────────────────────────

  Widget _taskSheet(ProgramTask task) {
    final state = AppState.instance;
    void close() => setState(() => _openTask = null);
    return _sheet(
      onClose: close,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Eyebrow(switch (task.kind) {
            TaskKind.video => '▶ Видео',
            TaskKind.webinar => '◉ Вебинар',
            TaskKind.task => '✦ Задание',
            TaskKind.goal => '◈ Личная цель',
          }),
          Text(task.title, style: AppText.display.copyWith(fontSize: 19)),
          if (task.meta != null) ...[
            const SizedBox(height: 2),
            Text(task.meta!, style: AppText.muted.copyWith(fontSize: 12)),
          ],
          const SizedBox(height: 10),
          Text(task.description, style: AppText.body.copyWith(fontSize: 13.5)),
          const SizedBox(height: 14),
          if (task.locked)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF171128),
                border: Border.all(color: AppColors.line),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text('🔒 ${task.lockedNote!}',
                  textAlign: TextAlign.center,
                  style: AppText.muted.copyWith(fontSize: 13)),
            )
          else if (task.kind == TaskKind.video) ...[
            GhostButton(
              MockApp.taskWatch,
              onTap: () => _demoSnack('Демо: видео появится в рабочей версии'),
            ),
            const SizedBox(height: 8),
            GoldButton(
              MockApp.taskMarkWatched,
              onTap: () {
                state.completeTask(task);
                close();
              },
            ),
          ] else if (task.kind == TaskKind.goal) ...[
            const Eyebrow(MockApp.taskGoalHintTitle),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF171128),
                border: Border.all(color: AppColors.line),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _goalController,
                maxLines: 2,
                style: AppText.body.copyWith(fontSize: 13),
                decoration: InputDecoration(
                  hintText: task.goalHint,
                  hintStyle: AppText.muted.copyWith(fontSize: 13),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Пока цель не задана — сохранить; заданную можно обновить
            // или отметить выполненной, когда она достигнута.
            if (task.goalText.isEmpty)
              GoldButton(
                MockApp.taskSaveGoal,
                onTap: () {
                  state.saveGoal(task, _goalController.text);
                  close();
                },
              )
            else ...[
              GhostButton(
                'Обновить цель',
                onTap: () {
                  state.saveGoal(task, _goalController.text);
                  close();
                },
              ),
              const SizedBox(height: 8),
              GoldButton(
                'Отметить выполненной ✦',
                onTap: () {
                  state.completeTask(task);
                  close();
                },
              ),
            ],
          ] else
            GoldButton(
              MockApp.taskMarkDone,
              onTap: () {
                state.completeTask(task);
                close();
              },
            ),
        ],
      ),
    );
  }

  // ── Карта дня ────────────────────────────────────────────────────────────

  Widget _tarotMini() {
    return GestureDetector(
      onTap: () => setState(() => _tarotOpen = true),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          height: 126,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
            gradient: AppGradients.glowCard,
            border: Border.all(color: const Color(0xFF4B3A86)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CompassStar(size: 24, dimmed: true),
              const SizedBox(height: 5),
              const Text('Карта дня',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11.5, color: AppColors.muted)),
              const SizedBox(height: 2),
              Flexible(
                child: Text(
                  MockApp.tarotName,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.display.copyWith(fontSize: 12.5, color: AppColors.goldSoft),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tarotSheet() {
    return _sheet(
      onClose: () => setState(() => _tarotOpen = false),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(child: CompassStar(size: 44)),
          const SizedBox(height: 10),
          Center(
            child: Text(MockApp.tarotName,
                style: AppText.display.copyWith(fontSize: 20, color: AppColors.goldSoft)),
          ),
          const SizedBox(height: 4),
          const Center(
            child: Text('Карта дня', style: TextStyle(fontSize: 11, color: AppColors.muted)),
          ),
          const SizedBox(height: 12),
          Text(MockApp.tarotMeaning,
              textAlign: TextAlign.center, style: AppText.body.copyWith(fontSize: 13.5)),
          const SizedBox(height: 14),
          GoldButton(
            'Понятно ✦',
            onTap: () => setState(() => _tarotOpen = false),
          ),
        ],
      ),
    );
  }

  // ── Практика дня ─────────────────────────────────────────────────────────

  Widget _practiceMini() {
    return GestureDetector(
      onTap: () => setState(() => _practiceOpen = true),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          height: 126,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
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
                    fontSize: 22,
                    color: _practiceDone ? AppColors.gold : null,
                  )),
              const SizedBox(height: 5),
              const Text('Практика дня',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11.5, color: AppColors.muted)),
              const SizedBox(height: 2),
              Flexible(
                child: Text(
                  _practiceDone
                      ? 'выполнена ✦'
                      : '${MockApp.practiceTitle} · ${MockApp.practiceDuration}',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.display.copyWith(fontSize: 12.5, color: AppColors.text),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _practiceSheet() {
    return _sheet(
      onClose: () => setState(() => _practiceOpen = false),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                            style:
                                const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
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
    );
  }

  // ── Общий каркас нижней шторки внутри фрейма ─────────────────────────────

  Widget _sheet({required VoidCallback onClose, required Widget child}) {
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
