import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../data/mock_content.dart';
import '../theme/app_theme.dart';
import '../widgets/compass_star.dart';
import 'explain_panel.dart';
import 'phone_frame.dart';

class PresentationShell extends StatelessWidget {
  const PresentationShell({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return Scaffold(
      backgroundColor: AppColors.deep,
      body: ListenableBuilder(
        listenable: state,
        builder: (context, _) => LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 980;
            return wide ? _wide(context) : _narrow(context);
          },
        ),
      ),
    );
  }

  // ── Широкий экран: телефон слева, панель справа ──────────────────────────
  Widget _wide(BuildContext context) {
    return Column(
      children: [
        _header(),
        _stepChips(),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(32, 8, 16, 24),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: SizedBox.fromSize(size: phoneSize, child: const PhoneFrame()),
                  ),
                ),
              ),
              Container(
                width: 520,
                padding: const EdgeInsets.fromLTRB(8, 8, 32, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: ExplainPanel(
                          step: AppState.instance.step,
                          stepIndex: AppState.instance.stepIndex,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _navButtons(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Узкий экран (телефон/планшет): всё в колонку ─────────────────────────
  Widget _narrow(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _header(wide: false),
          _stepChips(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 660),
              child: FittedBox(
                fit: BoxFit.contain,
                child: SizedBox.fromSize(size: phoneSize, child: const PhoneFrame()),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
            child: ExplainPanel(
              step: AppState.instance.step,
              stepIndex: AppState.instance.stepIndex,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 4, 24, 32),
            child: _navButtons(),
          ),
        ],
      ),
    );
  }

  Widget _header({bool wide = true}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(wide ? 32 : 20, 20, wide ? 32 : 20, 6),
      child: Row(
        children: [
          const CompassStar(size: 30),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('«Путь» — прототип приложения',
                    style: AppText.display.copyWith(fontSize: 17)),
                Text(
                  wide
                      ? 'концепция продукта для AmeliSoul · интерактивное демо'
                      : 'для AmeliSoul · интерактивное демо',
                  style: AppText.muted.copyWith(fontSize: 11.5),
                ),
              ],
            ),
          ),
          if (wide) ...[
            const SizedBox(width: 12),
            Text('рабочие названия и цены — для обсуждения',
                style: AppText.muted.copyWith(fontSize: 11)),
          ],
        ],
      ),
    );
  }

  Widget _stepChips() {
    final state = AppState.instance;
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 10, 28, 10),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (var i = 0; i < demoSteps.length; i++)
            GestureDetector(
              onTap: () => state.goToStep(i),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                  decoration: BoxDecoration(
                    color: i == state.stepIndex ? const Color(0xFF2C2154) : const Color(0xFF14102A),
                    border: Border.all(
                      color: i == state.stepIndex ? AppColors.gold : AppColors.line,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${i + 1} · ${demoSteps[i].navLabel}',
                    style: TextStyle(
                      fontSize: 12,
                      color: i == state.stepIndex ? AppColors.goldSoft : AppColors.muted,
                      fontWeight: i == state.stepIndex ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _navButtons() {
    final state = AppState.instance;
    final isLast = state.stepIndex == demoSteps.length - 1;
    return Row(
      children: [
        if (state.stepIndex > 0)
          GestureDetector(
            onTap: state.prevStep,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.line),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Text('←',
                    style: TextStyle(fontSize: 17, height: 1.1, color: AppColors.muted)),
              ),
            ),
          ),
        if (state.stepIndex > 0) const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: isLast ? () => state.goToStep(0) : state.nextStep,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: AppGradients.goldCta,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  isLast ? '↺  Смотреть сначала' : 'Дальше  →',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF241A10),
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
