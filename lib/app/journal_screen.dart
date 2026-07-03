import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../data/mock_content.dart';
import '../data/models.dart';
import '../theme/app_theme.dart';
import '../widgets/effects.dart';
import '../widgets/ui_kit.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final _controller = TextEditingController();
  int _mood = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    if (_controller.text.trim().isEmpty) return;
    AppState.instance.addJournalEntry(JournalEntry(
      dateLabel: 'Сегодня',
      mood: MockApp.moods[_mood],
      text: _controller.text.trim(),
    ));
    _controller.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) => ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          Text('Ваша динамика', style: AppText.muted.copyWith(fontSize: 13)),
          const SizedBox(height: 2),
          Text(MockApp.journalTitle, style: AppText.display.copyWith(fontSize: 24)),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Eyebrow(MockApp.journalChartEyebrow),
                const MoodChart(values: MockApp.journalChart),
                const SizedBox(height: 6),
                Text(MockApp.journalChartCaption, style: AppText.muted),
              ],
            ),
          ),
          AppCard(
            variant: AppCardVariant.glow,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Eyebrow(MockApp.journalPromptEyebrow),
                Text(MockApp.journalPrompt, style: AppText.body),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF171128),
              border: Border.all(color: AppColors.line),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _controller,
              maxLines: 3,
              style: AppText.body.copyWith(fontSize: 13),
              decoration: InputDecoration(
                hintText: MockApp.journalHint,
                hintStyle: AppText.muted.copyWith(fontSize: 13),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              for (var i = 0; i < MockApp.moods.length; i++) ...[
                if (i > 0) const SizedBox(width: 8),
                Expanded(child: _moodTile(i)),
              ],
            ],
          ),
          const SizedBox(height: 12),
          GoldButton(MockApp.journalSave, onTap: _save),
          const SizedBox(height: 18),
          for (final e in state.journalEntries)
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('${e.mood.emoji} ${e.mood.label}',
                          style: AppText.muted.copyWith(
                              fontSize: 11.5, color: AppColors.goldSoft)),
                      const Spacer(),
                      Text(e.dateLabel, style: AppText.muted.copyWith(fontSize: 11)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(e.text, style: AppText.body.copyWith(fontSize: 13)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _moodTile(int index) {
    final mood = MockApp.moods[index];
    final selected = index == _mood;
    return GestureDetector(
      onTap: () => setState(() => _mood = index),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF2C2154) : AppColors.card2,
            border: Border.all(color: selected ? AppColors.gold : AppColors.line),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              Text(mood.emoji, style: const TextStyle(fontSize: 19)),
              const SizedBox(height: 3),
              Text(mood.label,
                  style: TextStyle(
                    fontSize: 10,
                    color: selected ? AppColors.goldSoft : AppColors.muted,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
