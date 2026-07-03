import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../data/mock_content.dart';
import '../data/models.dart';
import '../theme/app_theme.dart';
import '../widgets/compass_star.dart';
import '../widgets/ui_kit.dart';

/// Пейволл. [asOverlay] — открыт изнутри приложения (лимит Компаса,
/// глава под замком): закрывается крестиком обратно в приложение.
class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key, this.asOverlay = false});
  final bool asOverlay;

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  int _selected = 0;

  void _close() {
    final state = AppState.instance;
    if (widget.asOverlay) {
      state.closePaywallOverlay();
    } else {
      state.frameScreen = FrameScreen.main;
      state.mainTab = MainTab.today;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: _close,
              child: const MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text('✕', style: TextStyle(fontSize: 18, color: AppColors.muted)),
                ),
              ),
            ),
          ),
          const CompassStar(size: 56),
          const SizedBox(height: 12),
          Text(MockApp.paywallTitle,
              textAlign: TextAlign.center, style: AppText.display.copyWith(fontSize: 23)),
          const SizedBox(height: 6),
          Text(MockApp.paywallSub, textAlign: TextAlign.center, style: AppText.muted),
          const SizedBox(height: 16),
          for (final b in MockApp.paywallBenefits)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('✦ ', style: TextStyle(color: AppColors.gold, fontSize: 13)),
                  Expanded(child: Text(b, style: AppText.body.copyWith(fontSize: 12.5))),
                ],
              ),
            ),
          const Spacer(),
          Row(
            children: [
              for (var i = 0; i < MockApp.paywallPlans.length; i++) ...[
                if (i > 0) const SizedBox(width: 10),
                Expanded(child: _planCard(i)),
              ],
            ],
          ),
          const SizedBox(height: 14),
          GoldButton(
            MockApp.paywallCta,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Демо: оплата появится в рабочей версии'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
              _close();
            },
          ),
          const SizedBox(height: 8),
          Text(MockApp.paywallNote,
              textAlign: TextAlign.center, style: AppText.muted.copyWith(fontSize: 11)),
        ],
      ),
    );
  }

  Widget _planCard(int index) {
    final plan = MockApp.paywallPlans[index];
    final selected = index == _selected;
    return GestureDetector(
      onTap: () => setState(() => _selected = index),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF2C2154) : AppColors.card,
            border: Border.all(
              color: selected ? AppColors.gold : AppColors.line,
              width: selected ? 1.4 : 1,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (plan.badge != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    gradient: AppGradients.goldCta,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    plan.badge!,
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF241A10),
                    ),
                  ),
                ),
                const SizedBox(height: 7),
              ] else
                const SizedBox(height: 22),
              Text(plan.title, style: AppText.muted.copyWith(fontSize: 12)),
              const SizedBox(height: 2),
              Text(plan.price,
                  style: AppText.display.copyWith(fontSize: 19, color: AppColors.goldSoft)),
              const SizedBox(height: 2),
              Text(plan.per, style: AppText.muted.copyWith(fontSize: 10.5)),
            ],
          ),
        ),
      ),
    );
  }
}
