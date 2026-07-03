import 'package:flutter/widgets.dart';

/// Какой экран показан внутри мобильного фрейма.
enum FrameScreen { welcome, onboarding, auth, paywall, main }

/// Вкладки основного интерфейса (доступны с шага «Главная»).
enum MainTab { today, route, compass, journal, profile }

/// Шаг демо-презентации: состояние фрейма + структурированная панель пояснений.
class DemoStep {
  const DemoStep({
    required this.title,
    required this.navLabel,
    required this.frameScreen,
    this.mainTab = MainTab.today,
    required this.whatIs,
    required this.howItWorks,
    required this.whyBusiness,
    required this.decide,
  });

  final String title;
  final String navLabel;
  final FrameScreen frameScreen;
  final MainTab mainTab;

  /// «Что это» — одна фраза: роль экрана в пути клиента.
  final String whatIs;

  /// «Как работает» — буллиты механики.
  final List<String> howItWorks;

  /// «Зачем бизнесу» — связь с удержанием / монетизацией / rev-share.
  final List<String> whyBusiness;

  /// «Решить с Юлей» — открытые вопросы.
  final List<String> decide;
}

class ChatPrompt {
  const ChatPrompt({required this.id, required this.label});
  final String id;
  final String label;
}

class PracticeRec {
  const PracticeRec({required this.title, required this.duration});
  final String title;
  final String duration;
}

class CuratorReply {
  const CuratorReply({required this.text, this.rec});
  final String text;
  final PracticeRec? rec;
}

enum ChatRole { user, compass }

class ChatMessage {
  const ChatMessage({required this.role, required this.text, this.rec, this.animate = false});
  final ChatRole role;
  final String text;
  final PracticeRec? rec;
  final bool animate;
}

class MoodOption {
  const MoodOption({required this.emoji, required this.label});
  final String emoji;
  final String label;
}

class JournalEntry {
  const JournalEntry({required this.dateLabel, required this.mood, required this.text});
  final String dateLabel;
  final MoodOption mood;
  final String text;
}

class OnboardingSlide {
  const OnboardingSlide({
    required this.glyph,
    required this.title,
    required this.text,
    this.badges = const [],
    this.isTopicPicker = false,
  });
  final String glyph;
  final String title;
  final String text;
  final List<String> badges;
  final bool isTopicPicker;
}

class PracticeStep {
  const PracticeStep({required this.title, required this.text});
  final String title;
  final String text;
}

/// Пункт программы месяца/года: видео, вебинар, задание или личная цель.
enum TaskKind { video, webinar, task, goal }

class ProgramTask {
  ProgramTask({
    required this.kind,
    required this.title,
    this.meta,
    this.description = '',
    this.lockedNote,
    this.goalHint,
    this.done = false,
  });

  final TaskKind kind;
  final String title;
  final String? meta; // «12 мин», «21 день»
  final String description;
  final String? lockedNote; // «Откроется 14 июля» — пункт ещё закрыт
  final String? goalHint;
  bool done;
  String goalText = '';

  bool get locked => lockedNote != null;
}

class PaywallPlan {
  const PaywallPlan({
    required this.title,
    required this.price,
    required this.per,
    this.badge,
    this.highlighted = false,
  });
  final String title;
  final String price;
  final String per;
  final String? badge;
  final bool highlighted;
}

/// Обёртка, чтобы панель могла подсвечивать блоки одинаково.
class PanelBlockStyle {
  const PanelBlockStyle({required this.label, required this.icon});
  final String label;
  final IconData icon;
}
