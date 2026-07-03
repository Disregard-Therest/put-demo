import 'package:flutter/material.dart';

import '../app/app_tabs.dart';
import '../app/auth_screen.dart';
import '../app/onboarding_screen.dart';
import '../app/paywall_screen.dart';
import '../app/welcome_screen.dart';
import '../data/app_state.dart';
import '../data/models.dart';
import '../theme/app_theme.dart';

/// Дизайн-размер «телефона»; снаружи масштабируется FittedBox'ом.
const phoneSize = Size(390, 812);

class PhoneFrame extends StatelessWidget {
  const PhoneFrame({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return Container(
      width: phoneSize.width,
      height: phoneSize.height,
      decoration: BoxDecoration(
        color: const Color(0xFF120E24),
        borderRadius: BorderRadius.circular(44),
        border: Border.all(color: const Color(0xFF2A2248), width: 2),
        boxShadow: const [
          BoxShadow(color: Color(0x8807060F), blurRadius: 60, offset: Offset(0, 24)),
        ],
      ),
      padding: const EdgeInsets.all(10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(34),
        child: ColoredBox(
          color: AppColors.bg,
          child: ListenableBuilder(
            listenable: state,
            builder: (context, _) {
              final content = switch (state.frameScreen) {
                FrameScreen.welcome => const WelcomeScreen(),
                FrameScreen.onboarding => const OnboardingScreen(),
                FrameScreen.auth => const AuthScreen(),
                FrameScreen.paywall => const PaywallScreen(),
                FrameScreen.main => const AppTabs(),
              };
              return ScaffoldMessenger(
                child: Scaffold(
                  backgroundColor: AppColors.bg,
                  resizeToAvoidBottomInset: false,
                  body: Column(
                    children: [
                      const _StatusBar(),
                      Expanded(
                        child: Stack(
                          children: [
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 260),
                              child: KeyedSubtree(
                                key: ValueKey(state.frameScreen),
                                child: content,
                              ),
                            ),
                            if (state.paywallOverlay)
                              const Positioned.fill(
                                child: PaywallScreen(asOverlay: true),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _StatusBar extends StatelessWidget {
  const _StatusBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 4),
      child: Row(
        children: [
          const Text('9:41',
              style: TextStyle(fontSize: 12, color: AppColors.muted, fontWeight: FontWeight.w600)),
          const Spacer(),
          Container(
            width: 96,
            height: 22,
            decoration: BoxDecoration(
              color: const Color(0xFF07060F),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const Spacer(),
          const Text('●●●',
              style: TextStyle(fontSize: 7, color: AppColors.muted, letterSpacing: 2)),
        ],
      ),
    );
  }
}
