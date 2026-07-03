import 'package:flutter/foundation.dart';

import 'mock_content.dart';
import 'models.dart';

/// Состояние демки: текущий шаг презентации + «живое» состояние приложения во фрейме.
class AppState extends ChangeNotifier {
  AppState._();
  static final instance = AppState._();

  // ── Единый стейт: канонично только состояние фрейма. ────────────────────
  // Номер шага презентации ВЫЧИСЛЯЕТСЯ из него — расходиться нечему.
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

  /// Текущий шаг презентации — производное от экрана фрейма.
  int get stepIndex {
    // Пейволл-оверлей поверх приложения — это тоже «экран пейволла».
    final screen = _paywallOverlay ? FrameScreen.paywall : _frameScreen;
    final exact = demoSteps.indexWhere((s) =>
        s.frameScreen == screen &&
        (s.frameScreen != FrameScreen.main || s.mainTab == _mainTab));
    if (exact >= 0) return exact;
    // Вкладки без собственного шага (Дневник, Профиль) — шаг «Ещё экраны».
    final fallback = demoSteps.lastIndexWhere((s) => s.frameScreen == screen);
    return fallback >= 0 ? fallback : 0;
  }

  DemoStep get step => demoSteps[stepIndex];

  void goToStep(int index) {
    if (index < 0 || index >= demoSteps.length) return;
    final s = demoSteps[index];
    _paywallOverlay = false;
    _frameScreen = s.frameScreen;
    if (s.frameScreen == FrameScreen.main) _mainTab = s.mainTab;
    notifyListeners();
  }

  void nextStep() => goToStep(stepIndex + 1);
  void prevStep() => goToStep(stepIndex - 1);

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
  final selectedTopics = <String>{};
  void toggleTopic(String topic) {
    selectedTopics.contains(topic) ? selectedTopics.remove(topic) : selectedTopics.add(topic);
    notifyListeners();
  }

  // ── Компас ───────────────────────────────────────────────────────────────
  final messages = <ChatMessage>[
    const ChatMessage(role: ChatRole.compass, text: MockApp.compassGreeting),
  ];
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

  // ── Программа месяца/года ────────────────────────────────────────────────
  void completeTask(ProgramTask task) {
    task.done = true;
    notifyListeners();
  }

  /// Сохранение цели НЕ отмечает её выполненной: текст появляется в списке,
  /// а выполненной цель отмечают отдельно, когда она достигнута.
  void saveGoal(ProgramTask task, String text) {
    task.goalText = text.trim();
    notifyListeners();
  }
}
