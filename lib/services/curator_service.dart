import 'dart:math';

import '../data/mock_content.dart';
import '../data/models.dart';

/// Абстракция ИИ-проводника. В демке — скрипт; в MVP сюда встаёт
/// реализация поверх Claude API (системный промпт на материалах метода).
abstract class CuratorService {
  Future<CuratorReply> ask(String text, {String? promptId});
}

class ScriptedCuratorService implements CuratorService {
  final _random = Random();

  @override
  Future<CuratorReply> ask(String text, {String? promptId}) async {
    // Имитация «думает» — как у реального ассистента.
    await Future<void>.delayed(Duration(milliseconds: 600 + _random.nextInt(400)));
    if (promptId != null) {
      final scripted = MockApp.compassReplies[promptId];
      if (scripted != null) return scripted;
    }
    return MockApp.compassFallback;
  }
}
