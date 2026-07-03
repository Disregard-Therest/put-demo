import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../data/mock_content.dart';
import '../data/models.dart';
import '../theme/app_theme.dart';
import '../widgets/ui_kit.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_page < MockApp.onboardingSlides.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
    } else {
      AppState.instance.frameScreen = FrameScreen.auth;
    }
  }

  void _back() {
    if (_page > 0) {
      _controller.previousPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
    } else {
      AppState.instance.frameScreen = FrameScreen.welcome;
    }
  }

  @override
  Widget build(BuildContext context) {
    final slides = MockApp.onboardingSlides;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 4, 24, 24),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              key: const Key('onboarding-back'),
              onTap: _back,
              behavior: HitTestBehavior.opaque,
              child: const MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(4, 8, 20, 10),
                  child: Text('←',
                      style: TextStyle(fontSize: 20, height: 1, color: AppColors.muted)),
                ),
              ),
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: slides.length,
              onPageChanged: (i) => setState(() => _page = i),
              itemBuilder: (context, i) => _Slide(slide: slides[i]),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < slides.length; i++)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: i == _page ? 22 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: i == _page ? AppColors.gold : AppColors.line,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          // На слайде запроса кнопка неактивна, пока не выбрана хотя бы одна тема.
          ListenableBuilder(
            listenable: AppState.instance,
            builder: (context, _) {
              final needsTopic = slides[_page].isTopicPicker &&
                  AppState.instance.selectedTopics.isEmpty;
              return GoldButton(MockApp.onboardingCta, onTap: needsTopic ? null : _next);
            },
          ),
        ],
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  const _Slide({required this.slide});
  final OnboardingSlide slide;

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 84,
          height: 84,
          decoration: BoxDecoration(
            gradient: AppGradients.glowCard,
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF4B3A86)),
          ),
          alignment: Alignment.center,
          child: Text(slide.glyph,
              style: const TextStyle(fontSize: 34, color: AppColors.goldSoft)),
        ),
        const SizedBox(height: 22),
        Text(slide.title,
            textAlign: TextAlign.center,
            style: AppText.display.copyWith(fontSize: 22)),
        const SizedBox(height: 12),
        Text(slide.text, textAlign: TextAlign.center, style: AppText.muted.copyWith(fontSize: 13.5)),
        if (slide.badges.isNotEmpty) ...[
          const SizedBox(height: 18),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [for (final b in slide.badges) Pill(b)],
          ),
        ],
        if (slide.isTopicPicker) ...[
          const SizedBox(height: 20),
          ListenableBuilder(
            listenable: state,
            builder: (context, _) => Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                for (final topic in MockApp.topics)
                  TopicChip(
                    label: topic,
                    selected: state.selectedTopics.contains(topic),
                    onTap: () => state.toggleTopic(topic),
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
