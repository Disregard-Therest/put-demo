import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../data/mock_content.dart';
import '../data/models.dart';
import '../services/curator_service.dart';
import '../theme/app_theme.dart';
import '../widgets/compass_star.dart';
import '../widgets/effects.dart';
import '../widgets/sheets.dart';
import '../widgets/ui_kit.dart';

class CuratorScreen extends StatefulWidget {
  const CuratorScreen({super.key});

  @override
  State<CuratorScreen> createState() => _CuratorScreenState();
}

class _CuratorScreenState extends State<CuratorScreen> {
  final CuratorService _service = ScriptedCuratorService();
  final _inputController = TextEditingController();
  final _scrollController = ScrollController();
  PracticeRec? _activePractice;

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _send(String text, {String? promptId}) async {
    final state = AppState.instance;
    if (text.trim().isEmpty || state.compassTyping) return;
    _inputController.clear();
    state.addMessage(ChatMessage(role: ChatRole.user, text: text.trim()));
    state.setCompassTyping(true);
    _scrollToBottom();

    final reply = await _service.ask(text, promptId: promptId);
    if (!mounted) return;
    state.setCompassTyping(false);
    state.addMessage(ChatMessage(
      role: ChatRole.compass,
      text: reply.text,
      rec: reply.rec,
      animate: true,
    ));
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _chat(),
        if (_activePractice != null)
          SheetOverlay(
            onClose: () => setState(() => _activePractice = null),
            child: PracticeSheetContent(
              title: _activePractice!.title,
              duration: _activePractice!.duration,
              steps: MockApp.practices[_activePractice!.title] ?? MockApp.practiceSteps,
              onDone: () {
                setState(() => _activePractice = null);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Практика выполнена ✦'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _chat() {
    final state = AppState.instance;
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Row(
                children: [
                  const CompassStar(size: 30),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(MockApp.compassName, style: AppText.display.copyWith(fontSize: 19)),
                      Text(MockApp.compassSub, style: AppText.muted.copyWith(fontSize: 11)),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                children: [
                  for (final m in state.messages)
                    _Bubble(
                      message: m,
                      onGrow: _scrollToBottom,
                      onStartPractice: (rec) => setState(() => _activePractice = rec),
                    ),
                  if (state.compassTyping)
                    const _BubbleShell(
                      isUser: false,
                      child: Text('…', style: TextStyle(color: AppColors.muted)),
                    ),
                ],
              ),
            ),
            if (state.messages.length <= 1)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  children: [
                    for (final p in MockApp.compassPrompts)
                      TopicChip(
                        label: p.label,
                        selected: false,
                        onTap: () => _send(p.label, promptId: p.id),
                      ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF171128),
                  border: Border.all(color: AppColors.line),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _inputController,
                        style: AppText.body.copyWith(fontSize: 13),
                        decoration: InputDecoration(
                          hintText: MockApp.compassInputHint,
                          hintStyle: AppText.muted.copyWith(fontSize: 13),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        onSubmitted: (v) => _send(v),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _send(_inputController.text),
                      child: const MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Padding(
                          padding: EdgeInsets.all(4),
                          child: Text('➤',
                              style: TextStyle(fontSize: 16, color: AppColors.gold)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }
}

class _BubbleShell extends StatelessWidget {
  const _BubbleShell({required this.isUser, required this.child, this.highlight = false});
  final bool isUser;
  final Widget child;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 280),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFF2C2154) : (highlight ? null : AppColors.card),
          gradient: highlight ? AppGradients.glowCard : null,
          border: isUser
              ? null
              : Border.all(color: highlight ? const Color(0xFF4B3A86) : AppColors.line),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 5),
            bottomRight: Radius.circular(isUser ? 5 : 16),
          ),
        ),
        child: child,
      ),
    );
  }
}

class _Bubble extends StatefulWidget {
  const _Bubble({required this.message, required this.onGrow, required this.onStartPractice});
  final ChatMessage message;
  final VoidCallback onGrow;
  final ValueChanged<PracticeRec> onStartPractice;

  @override
  State<_Bubble> createState() => _BubbleState();
}

class _BubbleState extends State<_Bubble> {
  late bool _showRec = !widget.message.animate;

  @override
  Widget build(BuildContext context) {
    final m = widget.message;
    final textStyle = AppText.body.copyWith(fontSize: 13);
    return Column(
      crossAxisAlignment:
          m.role == ChatRole.user ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        _BubbleShell(
          isUser: m.role == ChatRole.user,
          child: m.animate
              ? TypingText(
                  m.text,
                  style: textStyle,
                  onTick: widget.onGrow,
                  onDone: () => setState(() => _showRec = true),
                )
              : Text(m.text, style: textStyle),
        ),
        if (m.rec != null && _showRec)
          _BubbleShell(
            isUser: false,
            highlight: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Eyebrow('Рекомендую сейчас'),
                Text('${m.rec!.title} · ${m.rec!.duration}',
                    style: const TextStyle(fontSize: 13)),
                const SizedBox(height: 8),
                GoldButton(
                  'Начать практику',
                  dense: true,
                  onTap: () => widget.onStartPractice(m.rec!),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
