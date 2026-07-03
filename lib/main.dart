import 'package:flutter/material.dart';

import 'data/app_state.dart';
import 'presentation/presentation_shell.dart';
import 'theme/app_theme.dart';

void main() {
  // Диплинк на шаг презентации: ?step=3 (нумерация с единицы).
  final stepParam = int.tryParse(Uri.base.queryParameters['step'] ?? '');
  if (stepParam != null) AppState.instance.goToStep(stepParam - 1);
  runApp(const DemoApp());
}

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Путь · демо',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const PresentationShell(),
    );
  }
}
