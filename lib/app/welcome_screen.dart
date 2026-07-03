import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../data/mock_content.dart';
import '../data/models.dart';
import '../theme/app_theme.dart';
import '../widgets/compass_star.dart';
import '../widgets/ui_kit.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      child: Column(
        children: [
          const Spacer(flex: 2),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.6, end: 1),
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeOutBack,
            builder: (context, v, child) => Transform.scale(scale: v, child: child),
            child: const CompassStar(size: 110),
          ),
          const SizedBox(height: 20),
          Text(
            MockApp.appName,
            style: AppText.display.copyWith(fontSize: 34, letterSpacing: 4),
          ),
          const SizedBox(height: 24),
          Text(
            MockApp.welcomeTagline,
            textAlign: TextAlign.center,
            style: AppText.display.copyWith(fontSize: 21, color: AppColors.goldSoft),
          ),
          const SizedBox(height: 14),
          Text(MockApp.welcomeSub, textAlign: TextAlign.center, style: AppText.muted),
          const Spacer(flex: 3),
          GoldButton(
            MockApp.welcomeCta,
            onTap: () => state.frameScreen = FrameScreen.onboarding,
          ),
          const SizedBox(height: 10),
          Text(MockApp.welcomeSecondary,
              style: AppText.muted.copyWith(decoration: TextDecoration.underline)),
        ],
      ),
    );
  }
}
