import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../data/mock_content.dart';
import '../data/models.dart';
import '../theme/app_theme.dart';
import '../widgets/ui_kit.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      child: Column(
        children: [
          const Spacer(flex: 2),
          Container(
            width: 92,
            height: 92,
            decoration: BoxDecoration(
              gradient: AppGradients.glowCard,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF4B3A86)),
            ),
            alignment: Alignment.center,
            child: const Text('✧', style: TextStyle(fontSize: 38, color: AppColors.goldSoft)),
          ),
          const SizedBox(height: 22),
          Text(MockApp.authTitle,
              textAlign: TextAlign.center, style: AppText.display.copyWith(fontSize: 24)),
          const SizedBox(height: 12),
          Text(MockApp.authText, textAlign: TextAlign.center, style: AppText.muted),
          const Spacer(flex: 3),
          GestureDetector(
            onTap: () => state.frameScreen = FrameScreen.paywall,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 13),
                decoration: BoxDecoration(
                  color: const Color(0xFF2AABEE),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('➤', style: TextStyle(fontSize: 15, color: Colors.white)),
                    SizedBox(width: 8),
                    Text(
                      MockApp.authCta,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          GhostButton(
            MockApp.authSecondary,
            onTap: () => state.frameScreen = FrameScreen.paywall,
          ),
        ],
      ),
    );
  }
}
