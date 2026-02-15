import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../providers/streak_analytics_provider.dart';
import '../../theme/app_theme.dart';
import '../../../widgets/styled_card.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsState = ref.watch(streakAnalyticsProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      backgroundColor: AppColors.mist,
      appBar: AppBar(
        title: Text(
          'Analytics & Trending',
          style: GoogleFonts.dmSans(fontWeight: FontWeight.w700),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () =>
                ref.read(streakAnalyticsProvider.notifier).calculateAnalytics(),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
        children: [
          // Burnout Risk Summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.warning_rounded,
                      color: AppColors.rose,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Burnout Risk Score',
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Stack(
                  children: [
                    Container(
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.navy.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor:
                          (analyticsState.analytics.burnoutRisk ?? 0) / 100,
                      child: Container(
                        height: 12,
                        decoration: BoxDecoration(
                          color:
                              (analyticsState.analytics.burnoutRisk ?? 0) >= 80
                              ? AppColors.rose
                              : (analyticsState.analytics.burnoutRisk ?? 0) >=
                                    60
                              ? AppColors.amber
                              : AppColors.mint,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${analyticsState.analytics.burnoutRisk?.toStringAsFixed(0) ?? '0'}% Risk',
                  style: GoogleFonts.dmSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: (analyticsState.analytics.burnoutRisk ?? 0) >= 80
                        ? AppColors.rose
                        : (analyticsState.analytics.burnoutRisk ?? 0) >= 60
                        ? AppColors.amber
                        : AppColors.mint,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Focus Trends (7-day)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.timeline_rounded,
                      color: AppColors.electric,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Focus Hours (7-Day Trend)',
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.mist,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(7, (index) {
                        final hour =
                            (analyticsState.analytics.focusHours != null &&
                                analyticsState.analytics.focusHours!.isNotEmpty
                            ? analyticsState.analytics.focusHours![index %
                                  analyticsState.analytics.focusHours!.length]
                            : (5 + index % 3).toDouble());
                        final maxHeight = 80.0;
                        final barHeight = (hour / 10) * maxHeight;

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '${hour.toStringAsFixed(1)}h',
                              style: GoogleFonts.nunito(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                color: AppColors.navy.withValues(alpha: 0.6),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              width: isSmallScreen ? 18 : 24,
                              height: barHeight,
                              decoration: BoxDecoration(
                                color: hour >= 8
                                    ? AppColors.rose
                                    : hour >= 5
                                    ? AppColors.electric
                                    : AppColors.mint,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              [
                                'Mon',
                                'Tue',
                                'Wed',
                                'Thu',
                                'Fri',
                                'Sat',
                                'Sun',
                              ][index],
                              style: GoogleFonts.nunito(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                color: AppColors.navy.withValues(alpha: 0.5),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Mood Trends (7-day)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.mood_rounded,
                      color: AppColors.electric,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Mood Levels (7-Day Trend)',
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.mist,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CustomPaint(
                    painter: _LineChartPainter(
                      (analyticsState.analytics.moodScores != null &&
                              analyticsState.analytics.moodScores!.isNotEmpty
                          ? analyticsState.analytics.moodScores!
                          : [70, 75, 68, 72, 80, 78, 73]),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _MiniStat(
                            value: '75',
                            label: 'Avg',
                            color: AppColors.mint,
                          ),
                          _MiniStat(
                            value: '80',
                            label: 'Peak',
                            color: AppColors.electric,
                          ),
                          _MiniStat(
                            value: '68',
                            label: 'Low',
                            color: AppColors.rose,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Key Metrics
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.assessment_rounded,
                      color: AppColors.mint,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'This Week\'s Metrics',
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.2,
                  children: [
                    _MetricCard(
                      label: 'Focus Streak',
                      value: '${analyticsState.analytics.focusStreak ?? 0}',
                      unit: 'days',
                      icon: Icons.local_fire_department_rounded,
                      color: AppColors.rose,
                    ),
                    _MetricCard(
                      label: 'Deep Work %',
                      value:
                          '${(analyticsState.analytics.deepWorkPercentage ?? 0).toStringAsFixed(0)}',
                      unit: '%',
                      icon: Icons.trending_up_rounded,
                      color: AppColors.electric,
                    ),
                    _MetricCard(
                      label: 'Mood Stability',
                      value:
                          '${(analyticsState.analytics.moodStability ?? 0).toStringAsFixed(0)}',
                      unit: '%',
                      icon: Icons.balance_rounded,
                      color: AppColors.mint,
                    ),
                    _MetricCard(
                      label: 'Tasks Done',
                      value: '${analyticsState.analytics.completedTasks ?? 0}',
                      unit: 'tasks',
                      icon: Icons.done_all_rounded,
                      color: AppColors.amber,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Recommendations
          if (analyticsState.burnoutAlert != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:
                    (analyticsState.burnoutAlert!.isHighSeverity
                            ? AppColors.rose
                            : AppColors.amber)
                        .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color:
                      (analyticsState.burnoutAlert!.isHighSeverity
                              ? AppColors.rose
                              : AppColors.amber)
                          .withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        analyticsState.burnoutAlert!.isHighSeverity
                            ? Icons.error_rounded
                            : Icons.info_rounded,
                        color: analyticsState.burnoutAlert!.isHighSeverity
                            ? AppColors.rose
                            : AppColors.amber,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          analyticsState.burnoutAlert!.message,
                          style: GoogleFonts.dmSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
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
                    'Recommended Actions:',
                    style: GoogleFonts.nunito(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.navy.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...?analyticsState.burnoutAlert?.suggestedActions?.map(
                    (action) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        '• $action',
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          color: AppColors.navy.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final IconData icon;
  final Color color;

  const _MetricCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.nunito(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.navy.withValues(alpha: 0.6),
                  ),
                ),
              ),
              Icon(icon, color: color, size: 16),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: GoogleFonts.dmSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: GoogleFonts.nunito(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: color.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _MiniStat({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: GoogleFonts.dmSans(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.nunito(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppColors.navy.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> data;

  _LineChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.electric
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    if (data.length < 2) return;

    final maxValue = data.reduce((a, b) => a > b ? a : b);
    final minValue = data.reduce((a, b) => a < b ? a : b);
    final range = maxValue - minValue;

    final points = <Offset>[];
    for (int i = 0; i < data.length; i++) {
      final x = (size.width / (data.length - 1)) * i;
      final normalized = range == 0 ? 0.5 : (data[i] - minValue) / range;
      final y =
          size.height - (normalized * size.height * 0.8) - (size.height * 0.1);
      points.add(Offset(x, y));
    }

    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], paint);
    }
  }

  @override
  bool shouldRepaint(_LineChartPainter oldDelegate) {
    return oldDelegate.data != data;
  }
}
