import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/styled_card.dart';

const String _insightsHeroAsset =
    'assets/images/onboarding/insights_checklist.png';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Insights')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          StyledCard(
            title: 'Insights at a glance',
            subtitle: 'Track your progress and patterns',
            icon: Icons.bar_chart_rounded,
            iconBackgroundColor: AppColors.amber,
            gradientColors: const [Color(0xFFFFF5EE), Color(0xFFFFFAF5)],
            score: '78%',
            assetImage: _insightsHeroAsset,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Productivity Score',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _ScorePill(label: 'Task Completion', value: '40%'),
                    const SizedBox(width: 10),
                    _ScorePill(label: 'Focus Consistency', value: '30%'),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _ScorePill(label: 'Study Hours', value: '20%'),
                    const SizedBox(width: 10),
                    _ScorePill(label: 'Mood Stability', value: '10%'),
                  ],
                ),
                const SizedBox(height: 18),
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.sky.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text('Interactive chart placeholder'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _InsightTile(
            title: 'Weekly Focus Heatmap',
            subtitle: '4 deep work days this week',
          ),
          const SizedBox(height: 12),
          _InsightTile(
            title: 'Mood vs Productivity',
            subtitle: 'Stable mood correlates to +12%',
          ),
          const SizedBox(height: 12),
          _InsightTile(
            title: 'Weak Subject Detection',
            subtitle: 'Physics topics need review',
          ),
          const SizedBox(height: 12),
          _InsightTile(
            title: 'Burnout Risk Trend',
            subtitle: 'Moderate risk over last 7 days',
          ),
        ],
      ),
    );
  }
}

class _InsightTile extends StatelessWidget {
  const _InsightTile({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.electric.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.insights_rounded,
              color: AppColors.electric,
            ),
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

class _ScorePill extends StatelessWidget {
  const _ScorePill({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.mist,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 6),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
