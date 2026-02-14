import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/styled_card.dart';

const String _aiHeroAsset = 'assets/images/onboarding/ai_assistant.png';

class AiScreen extends StatelessWidget {
  const AiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Study Assistant')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            StyledCard(
              title: 'Nero AI is ready',
              subtitle: 'Summarize, quiz, or build a study plan',
              icon: Icons.psychology_rounded,
              iconBackgroundColor: AppColors.electric,
              gradientColors: const [Color(0xFFECE6FF), Color(0xFFF7F5FF)],
              buttonLabel: 'Start Chat',
              onButtonPressed: () {},
              assetImage: _aiHeroAsset,
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.electric.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.auto_awesome_rounded,
                      color: AppColors.electric,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Ask anything about your courses, tasks, or weak topics.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: const [
                  _ToolTile(
                    title: 'Summarizer',
                    subtitle: 'Condense lecture notes or PDFs',
                    icon: Icons.short_text_rounded,
                  ),
                  _ToolTile(
                    title: 'Quiz Generator',
                    subtitle: 'Create practice questions fast',
                    icon: Icons.quiz_rounded,
                  ),
                  _ToolTile(
                    title: 'Flashcards',
                    subtitle: 'Spaced repetition ready cards',
                    icon: Icons.style_rounded,
                  ),
                  _ToolTile(
                    title: 'Study Plan',
                    subtitle: 'Build a weekly revision plan',
                    icon: Icons.event_available_rounded,
                  ),
                  _ToolTile(
                    title: 'Weak Topic Review',
                    subtitle: 'Target your lowest scores',
                    icon: Icons.track_changes_rounded,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.line),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Ask Nero AI to explain today\'s tasks...',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.navy.withOpacity(0.6),
                      ),
                    ),
                  ),
                  const Icon(Icons.send_rounded, color: AppColors.electric),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ToolTile extends StatelessWidget {
  const _ToolTile({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.mint.withOpacity(0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AppColors.mint),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.navy),
        ],
      ),
    );
  }
}
