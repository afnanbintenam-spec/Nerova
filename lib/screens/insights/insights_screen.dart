import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../providers/analytics_provider.dart';
import '../../providers/mood_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/modern_back_button.dart';
import '../../widgets/styled_card.dart';
import '../../widgets/mood_entry_dialog.dart';

const String _insightsHeroAsset =
    'assets/images/onboarding/insights_checklist.png';

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  void _showMoodDialog(BuildContext context) {
    showDialog(context: context, builder: (_) => const MoodEntryDialog());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsState = ref.watch(analyticsProvider);
    final moodState = ref.watch(moodProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      appBar: AppBar(
        leading: const ModernBackButton(),
        title: Text(
          'Insights',
          style: GoogleFonts.dmSans(fontWeight: FontWeight.w700),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              ref.read(analyticsProvider.notifier).refresh();
              ref.read(moodProvider.notifier).loadMoods();
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(analyticsProvider.notifier).refresh();
          await ref.read(moodProvider.notifier).loadMoods();
        },
        child: ListView(
          padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
          children: [
            StyledCard(
              title: 'Insights at a glance',
              subtitle: 'Track your progress and patterns',
              icon: Icons.bar_chart_rounded,
              iconBackgroundColor: AppColors.amber,
              gradientColors: const [Color(0xFFFFF5EE), Color(0xFFFFFAF5)],
              score: '${analyticsState.completionRate.toStringAsFixed(0)}%',
              assetImage: _insightsHeroAsset,
              buttonLabel: 'Log Mood',
              onButtonPressed: () => _showMoodDialog(context),
            ),
            const SizedBox(height: 16),

            // Productivity Score Card
            Container(
              padding: EdgeInsets.all(isSmallScreen ? 18 : 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
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
                    style: GoogleFonts.dmSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _ScorePill(
                        label: 'Task Completion',
                        value:
                            '${analyticsState.completionRate.toStringAsFixed(0)}%',
                        color: AppColors.mint,
                      ),
                      const SizedBox(width: 10),
                      _ScorePill(
                        label: 'Focus Time',
                        value: '${analyticsState.focusMinutesToday}m',
                        color: AppColors.electric,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _ScorePill(
                        label: 'Study Streak',
                        value: '${analyticsState.studyStreak} days',
                        color: AppColors.amber,
                      ),
                      const SizedBox(width: 10),
                      _ScorePill(
                        label: 'Energy Avg',
                        value: analyticsState.averageEnergy.toStringAsFixed(1),
                        color: AppColors.rose,
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Weekly productivity chart
                  if (analyticsState.weeklyProductivity.isNotEmpty) ...[
                    Text(
                      'Weekly Overview',
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _WeeklyChart(data: analyticsState.weeklyProductivity),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Tasks by Priority
            if (analyticsState.tasksByPriority.isNotEmpty)
              _InsightCard(
                title: 'Tasks by Priority',
                icon: Icons.flag_rounded,
                color: AppColors.rose,
                child: Column(
                  children: analyticsState.tasksByPriority.entries.map((entry) {
                    final color = entry.key == 'High'
                        ? AppColors.rose
                        : entry.key == 'Medium'
                        ? AppColors.amber
                        : AppColors.mint;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              entry.key,
                              style: GoogleFonts.dmSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            '${entry.value}',
                            style: GoogleFonts.dmSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.ink,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            const SizedBox(height: 12),

            // Recent Moods
            if (moodState.moods.isNotEmpty)
              _InsightCard(
                title: 'Recent Moods',
                icon: Icons.mood_rounded,
                color: AppColors.mint,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: moodState.moods.take(7).map((mood) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Tooltip(
                            message: mood.mood,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: _getMoodColor(
                                  mood.mood,
                                ).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                mood.emoji,
                                style: const TextStyle(fontSize: 24),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _MoodStat(
                          label: 'Avg Energy',
                          value: moodState.averageEnergy.toStringAsFixed(1),
                          icon: Icons.bolt_rounded,
                          color: AppColors.amber,
                        ),
                        _MoodStat(
                          label: 'Avg Stress',
                          value: moodState.averageStress.toStringAsFixed(1),
                          icon: Icons.trending_up_rounded,
                          color: AppColors.rose,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 12),

            // Task Statistics
            _InsightTile(
              title: 'Task Statistics',
              subtitle:
                  '${analyticsState.completedTasks}/${analyticsState.totalTasks} completed · ${analyticsState.overdueCount} overdue',
              icon: Icons.task_alt_rounded,
              color: AppColors.electric,
            ),
            const SizedBox(height: 12),

            _InsightTile(
              title: 'Focus Consistency',
              subtitle:
                  '${analyticsState.studyStreak} day streak · ${analyticsState.focusMinutesToday} minutes today',
              icon: Icons.timer_rounded,
              color: AppColors.mint,
            ),
            const SizedBox(height: 12),

            if (analyticsState.dominantMood != null)
              _InsightTile(
                title: 'Mood Pattern',
                subtitle: 'Mostly ${analyticsState.dominantMood} this week',
                icon: Icons.mood_rounded,
                color: AppColors.amber,
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showMoodDialog(context),
        backgroundColor: AppColors.mint,
        child: const Icon(Icons.add_reaction_rounded),
      ),
    );
  }

  Color _getMoodColor(String mood) {
    switch (mood) {
      case 'happy':
        return AppColors.mint;
      case 'sad':
        return AppColors.electric;
      case 'stressed':
        return AppColors.rose;
      case 'energetic':
        return AppColors.amber;
      case 'tired':
        return const Color(0xFF708090);
      default:
        return AppColors.navy;
    }
  }
}

class _InsightTile extends StatelessWidget {
  const _InsightTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

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
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.dmSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    color: AppColors.navy.withValues(alpha: 0.6),
                  ),
                ),
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
  const _ScorePill({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.dmSans(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.navy.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: GoogleFonts.dmSans(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: color),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _WeeklyChart extends StatelessWidget {
  const _WeeklyChart({required this.data});

  final List<DailyProductivity> data;

  @override
  Widget build(BuildContext context) {
    final maxTasks = data
        .map((d) => d.completedTasks)
        .reduce((a, b) => a > b ? a : b)
        .toDouble();
    final maxValue = maxTasks > 0 ? maxTasks : 1;

    return Container(
      height: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.mist.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: data.map((day) {
          final height = (day.completedTasks / maxValue) * 80;
          final dayName = _getDayName(day.date.weekday);

          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 32,
                height: height + 20,
                decoration: BoxDecoration(
                  color: AppColors.electric.withValues(alpha: 0.2 + (height / 100)),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(
                  day.completedTasks.toString(),
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.electric,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                dayName,
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.navy.withValues(alpha: 0.5),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'M';
      case 2:
        return 'T';
      case 3:
        return 'W';
      case 4:
        return 'T';
      case 5:
        return 'F';
      case 6:
        return 'S';
      case 7:
        return 'S';
      default:
        return '';
    }
  }
}

class _MoodStat extends StatelessWidget {
  const _MoodStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.dmSans(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.navy.withValues(alpha: 0.6),
              ),
            ),
            Text(
              value,
              style: GoogleFonts.dmSans(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
