import 'package:flutter/material.dart';

import '../data/mock_content.dart';
import '../theme/app_theme.dart';
import '../widgets/compass_star.dart';
import '../widgets/ui_kit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      children: [
        Center(
          child: Container(
            width: 86,
            height: 86,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: AppGradients.glowCard,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF4B3A86)),
            ),
            child: Text('М',
                style: AppText.display.copyWith(fontSize: 30, color: AppColors.goldSoft)),
          ),
        ),
        const SizedBox(height: 12),
        Center(child: Text(MockApp.userName, style: AppText.display.copyWith(fontSize: 22))),
        const SizedBox(height: 4),
        Center(
          child: Text('✦ ${MockApp.profileStreakLabel}',
              style: AppText.muted.copyWith(color: AppColors.goldSoft)),
        ),
        const SizedBox(height: 18),
        for (final row in MockApp.profileRows)
          AppCard(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            child: Row(
              children: [
                Expanded(child: Text(row, style: AppText.body.copyWith(fontSize: 13.5))),
                const Text('›', style: TextStyle(fontSize: 17, height: 1, color: AppColors.muted)),
              ],
            ),
          ),
        const SizedBox(height: 8),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CompassStar(size: 16, dimmed: true),
              const SizedBox(width: 6),
              Text('экран-заглушка для демо', style: AppText.muted.copyWith(fontSize: 11)),
            ],
          ),
        ),
      ],
    );
  }
}
