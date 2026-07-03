import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_web_app/data/app_state.dart';
import 'package:my_web_app/data/mock_content.dart';
import 'package:my_web_app/data/models.dart';
import 'package:my_web_app/main.dart';

void main() {
  setUp(() {
    AppState.instance
      ..goToStep(0)
      ..selectedTopics.clear();
  });

  Future<void> pumpApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1600, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const DemoApp());
    await tester.pumpAndSettle();
  }

  testWidgets('назад с первого слайда онбординга возвращает на приветствие и синхронизирует шаг',
      (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text(MockApp.welcomeCta));
    await tester.pumpAndSettle();
    expect(AppState.instance.frameScreen, FrameScreen.onboarding);
    expect(AppState.instance.stepIndex, 1, reason: 'панель должна перейти на шаг онбординга');

    await tester.tap(find.byKey(const Key('onboarding-back')));
    await tester.pumpAndSettle();
    expect(AppState.instance.frameScreen, FrameScreen.welcome,
        reason: 'фрейм должен вернуться на приветствие');
    expect(AppState.instance.stepIndex, 0, reason: 'панель должна вернуться на шаг 1');
  });

  testWidgets('онбординг: без выбранной темы дальше не пускает, с темой — ведёт на вход',
      (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text(MockApp.welcomeCta));
    await tester.pumpAndSettle();
    await tester.tap(find.text(MockApp.onboardingCta));
    await tester.pumpAndSettle();
    await tester.tap(find.text(MockApp.onboardingCta));
    await tester.pumpAndSettle();

    // Слайд запроса: кнопка неактивна, пока не выбрана тема.
    await tester.tap(find.text(MockApp.onboardingCta));
    await tester.pumpAndSettle();
    expect(AppState.instance.frameScreen, FrameScreen.onboarding,
        reason: 'без темы «Продолжить» не должна срабатывать');

    await tester.tap(find.text('Деньги'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(MockApp.onboardingCta));
    await tester.pumpAndSettle();
    expect(AppState.instance.frameScreen, FrameScreen.auth);
    expect(AppState.instance.stepIndex, 2, reason: 'панель должна перейти на шаг входа');
  });

  testWidgets('вход → пейволл → главная: шаги презентации следуют за фреймом', (tester) async {
    await pumpApp(tester);
    AppState.instance.frameScreen = FrameScreen.auth;
    await tester.pumpAndSettle();

    await tester.tap(find.text(MockApp.authCta));
    await tester.pumpAndSettle();
    expect(AppState.instance.stepIndex, 3, reason: 'после входа — шаг пейволла');

    await tester.tap(find.text('✕'));
    await tester.pumpAndSettle();
    expect(AppState.instance.frameScreen, FrameScreen.main);
    expect(AppState.instance.stepIndex, 4, reason: 'после закрытия пейволла — шаг главной');
  });
}
