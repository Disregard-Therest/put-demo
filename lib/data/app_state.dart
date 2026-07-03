import 'package:flutter/foundation.dart';

import 'mock_content.dart';
import 'models.dart';

/// Состояние демки: текущий шаг презентации + «живое» состояние приложения во фрейме.
class AppState extends ChangeNotifier {
  AppState._();
  static final instance = AppState._();

  // ── Презентация ─────────────────────────────────────────────────────────
  int _stepIndex = 0;
  int get stepIndex => _stepIndex;
  DemoStep get step => demoSteps[_stepIndex];

  void goToStep(int index) {
    if (index < 0 || index >= demoSteps.length) return;
    _stepIndex = index;
    final s = demoSteps[index];
    _frameScreen = s.frameScreen;
    if (s.frameScreen == FrameScreen.main) _mainTab = s.mainTab;
    notifyListeners();
  }

  void nextStep() => goToStep(_stepIndex + 1);
  void prevStep() => goToStep(_stepIndex - 1);

  // ── Фрейм ────────────────────────────────────────────────────────────────
  FrameScreen _frameScreen = FrameScreen.welcome;
  FrameScreen get frameScreen => _frameScreen;
  set frameScreen(FrameScreen value) {
    _frameScreen = value;
    notifyListeners();
  }

  MainTab _mainTab = MainTab.today;
  MainTab get mainTab => _mainTab;
  set mainTab(MainTab value) {
    _mainTab = value;
    notifyListeners();
  }

  /// Пейволл, открытый изнутри приложения (лимит Компаса, глава под замком) —
  /// поверх main, с кнопкой «назад».
  bool _paywallOverlay = false;
  bool get paywallOverlay => _paywallOverlay;
  void showPaywallOverlay() {
    _paywallOverlay = true;
    notifyListeners();
  }

  void closePaywallOverlay() {
    _paywallOverlay = false;
    notifyListeners();
  }

  // ── Онбординг / темы ─────────────────────────────────────────────────────
  final selectedTopics = <String>{'Деньги'};
  void toggleTopic(String topic) {
    selectedTopics.contains(topic) ? selectedTopics.remove(topic) : selectedTopics.add(topic);
    notifyListeners();
  }

  // ── Компас ───────────────────────────────────────────────────────────────
  final messages = <ChatMessage>[
    const ChatMessage(role: ChatRole.compass, text: MockApp.compassGreeting),
  ];
  bool freeQuestionUsed = false;
  bool compassTyping = false;

  void addMessage(ChatMessage message) {
    messages.add(message);
    notifyListeners();
  }

  void setCompassTyping(bool value) {
    compassTyping = value;
    notifyListeners();
  }

  // ── Дневник ──────────────────────────────────────────────────────────────
  final journalEntries = List<JournalEntry>.of(MockApp.seedJournalEntries);
  void addJournalEntry(JournalEntry entry) {
    journalEntries.insert(0, entry);
    notifyListeners();
  }

  // ── Чек-лист темы месяца ─────────────────────────────────────────────────
  void toggleChecklist(ChecklistItem item) {
    item.done = !item.done;
    notifyListeners();
  }
}
