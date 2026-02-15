import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../providers/streak_analytics_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/modern_back_button.dart';

class StressSupportScreen extends ConsumerWidget {
  const StressSupportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsState = ref.watch(streakAnalyticsProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      backgroundColor: AppColors.mist,
      appBar: AppBar(
        leading: const ModernBackButton(),
        title: Text(
          'Stress Support',
          style: GoogleFonts.dmSans(fontWeight: FontWeight.w700),
        ),
        centerTitle: false,
      ),
      body: ListView(
        padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
        children: [
          // Burnout Alert Card
          if (analyticsState.burnoutAlert != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: analyticsState.burnoutAlert!.isHighSeverity
                      ? [AppColors.rose.withValues(alpha: 0.1), Colors.white]
                      : [AppColors.amber.withValues(alpha: 0.1), Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: analyticsState.burnoutAlert!.isHighSeverity
                      ? AppColors.rose.withValues(alpha: 0.3)
                      : AppColors.amber.withValues(alpha: 0.3),
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        analyticsState.burnoutAlert!.isHighSeverity
                            ? Icons.error_rounded
                            : Icons.warning_rounded,
                        color: analyticsState.burnoutAlert!.isHighSeverity
                            ? AppColors.rose
                            : AppColors.amber,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Burnout Alert',
                          style: GoogleFonts.dmSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: analyticsState.burnoutAlert!.isHighSeverity
                                ? AppColors.rose
                                : AppColors.amber,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    analyticsState.burnoutAlert!.message,
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (analyticsState.burnoutAlert!.suggestedActions != null &&
                      analyticsState.burnoutAlert!.suggestedActions!.isNotEmpty)
                    ...analyticsState.burnoutAlert!.suggestedActions!
                        .take(2)
                        .map(
                          (action) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: FilledButton(
                              onPressed: () {
                                // TODO: Implement suggested action
                              },
                              style: FilledButton.styleFrom(
                                backgroundColor:
                                    analyticsState.burnoutAlert!.isHighSeverity
                                    ? AppColors.rose
                                    : AppColors.amber,
                              ),
                              child: Text(
                                action,
                                style: GoogleFonts.nunito(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Quick Actions
          Text(
            'Quick Actions',
            style: GoogleFonts.dmSans(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 16),

          _ActionButton(
            icon: '😰',
            title: 'I Feel Overwhelmed',
            description: 'Get immediate coping strategies',
            onTap: () {
              _showActionDialog(
                context,
                'I Feel Overwhelmed',
                'Try breaking your tasks into smaller, manageable chunks. Start with just 15 minutes of work.',
              );
            },
          ),
          const SizedBox(height: 12),

          _ActionButton(
            icon: '🫁',
            title: 'Quick Breathing Exercise',
            description: '2 minutes of guided breathing',
            onTap: () {
              _showBreathingDialog(context);
            },
          ),
          const SizedBox(height: 12),

          _ActionButton(
            icon: '⏱️',
            title: '5-Minute Reset',
            description: 'Meditation & mindfulness',
            onTap: () {
              _showActionDialog(
                context,
                '5-Minute Reset',
                'Close your eyes. Breathe deeply. Think of a calm place. You\'re doing great.',
              );
            },
          ),
          const SizedBox(height: 12),

          _ActionButton(
            icon: '⚖️',
            title: 'Reduce Today\'s Workload',
            description: 'Auto-redistribute tasks',
            onTap: () {
              _showActionDialog(
                context,
                'Reduce Workload',
                'I\'ve rescheduled 3 tasks for tomorrow. Focus on your top 3 priorities today.',
              );
            },
          ),

          const SizedBox(height: 24),

          // Burnout Detector
          Text(
            'Burnout Risk Analysis',
            style: GoogleFonts.dmSans(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 16),

          _RiskIndicator(
            label: 'Focus Overload',
            score: analyticsState.analytics.dailyStudyHours,
            maxScore: 12,
            color: AppColors.electric,
          ),
          const SizedBox(height: 12),

          _RiskIndicator(
            label: 'Mood Stability',
            score: analyticsState.analytics.moodStability.toInt(),
            maxScore: 100,
            color: AppColors.mint,
          ),
          const SizedBox(height: 12),

          _RiskIndicator(
            label: 'Overall Burnout Risk',
            score: analyticsState.analytics.burnoutRisk,
            maxScore: 100,
            color: analyticsState.analytics.burnoutRisk > 70
                ? AppColors.rose
                : analyticsState.analytics.burnoutRisk > 40
                ? AppColors.amber
                : AppColors.mint,
          ),

          const SizedBox(height: 24),

          // Recommendations
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.mint.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.mint.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.lightbulb_rounded,
                      color: AppColors.mint,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Recommendations',
                      style: GoogleFonts.dmSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.mint,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '• Take a 10-minute break every 45 minutes\n'
                  '• Focus on just 3 priorities today\n'
                  '• Get 8 hours of sleep tonight\n'
                  '• Do a quick 5-minute reset if stressed',
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.navy,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showActionDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  void _showBreathingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Box Breathing'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Follow this pattern:\n\n'
              '1. Breathe IN for 4 seconds\n'
              '2. Hold for 4 seconds\n'
              '3. Breathe OUT for 4 seconds\n'
              '4. Hold for 4 seconds\n\n'
              'Repeat 5 times.',
              style: GoogleFonts.nunito(fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text('Start Exercise'),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 32)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.navy.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_rounded, color: AppColors.electric),
            ],
          ),
        ),
      ),
    );
  }
}

class _RiskIndicator extends StatelessWidget {
  final String label;
  final int score;
  final int maxScore;
  final Color color;

  const _RiskIndicator({
    required this.label,
    required this.score,
    required this.maxScore,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (score / maxScore * 100).clamp(0, 100).toInt();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.nunito(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
              ),
            ),
            Text(
              '$score / $maxScore',
              style: GoogleFonts.nunito(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Stack(
          children: [
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.navy.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            FractionallySizedBox(
              widthFactor: percentage / 100,
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
