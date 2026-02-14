import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/styled_card.dart';

const String _homeHeroAsset = 'assets/images/onboarding/home_header.png';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final horizontalPadding = isSmallScreen ? 16.0 : 20.0;

    return Scaffold(
      body: Stack(
        children: [
          // Decorative floating badges
          Positioned(
            top: 60,
            right: 20,
            child: _FloatingBadge(
              text: 'Hi',
              color: const Color(0xFFFFB3BA),
              size: isSmallScreen ? 50 : 60,
            ),
          ),
          Positioned(
            top: 180,
            left: 15,
            child: _FloatingBadge(
              text: 'Hello',
              color: const Color(0xFFBAB3FF),
              size: isSmallScreen ? 55 : 65,
            ),
          ),
          Positioned(
            bottom: 250,
            right: 25,
            child: _FloatingBadge(
              text: '📚',
              color: const Color(0xFFFFE5B3),
              size: isSmallScreen ? 45 : 55,
            ),
          ),
          // Main content
          SafeArea(
            child: ListView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: isSmallScreen ? 12 : 16,
              ),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good Evening, Ehesan',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Ready for a focused session?',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: AppColors.navy.withOpacity(0.7),
                              ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.local_fire_department_rounded,
                        color: AppColors.amber,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isSmallScreen ? 16 : 20),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 14 : 16,
                          vertical: isSmallScreen ? 12 : 14,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8E6FF),
                          borderRadius: BorderRadius.circular(
                            isSmallScreen ? 14 : 16,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.search_rounded,
                              color: AppColors.navy.withOpacity(0.5),
                              size: isSmallScreen ? 20 : 22,
                            ),
                            SizedBox(width: isSmallScreen ? 8 : 10),
                            Expanded(
                              child: Text(
                                'Search...',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: AppColors.navy.withOpacity(0.5),
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: isSmallScreen ? 10 : 12),
                    Container(
                      padding: EdgeInsets.all(isSmallScreen ? 12 : 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8E6FF),
                        borderRadius: BorderRadius.circular(
                          isSmallScreen ? 14 : 16,
                        ),
                      ),
                      child: Icon(
                        Icons.tune_rounded,
                        color: AppColors.navy.withOpacity(0.6),
                        size: isSmallScreen ? 20 : 22,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: const [
                      _CategoryChip(label: 'All', isSelected: true),
                      SizedBox(width: 8),
                      _CategoryChip(label: 'Beginners'),
                      SizedBox(width: 8),
                      _CategoryChip(label: 'Intermediate'),
                      SizedBox(width: 8),
                      _CategoryChip(label: 'Advanced'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                StyledCard(
                  title: 'Daily plan ready',
                  subtitle: 'Start your focused session',
                  icon: Icons.auto_awesome_rounded,
                  iconBackgroundColor: AppColors.electric,
                  gradientColors: const [Color(0xFFE8F4FF), Color(0xFFF5F9FF)],
                  score: '10%',
                  buttonLabel: 'Start Focus',
                  onButtonPressed: () {},
                  assetImage: _homeHeroAsset,
                ),
                const SizedBox(height: 16),
                _SoftCard(
                  title: 'Today Timeline',
                  child: Column(
                    children: const [
                      _TimelineItem(
                        time: '08:00 - 10:00',
                        title: 'Deep Work: Calculus',
                      ),
                      _TimelineItem(
                        time: '11:00 - 12:00',
                        title: 'Lab Report Draft',
                      ),
                      _TimelineItem(
                        time: '14:00 - 15:30',
                        title: 'Physics Problem Set',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _SoftCard(
                  title: 'Priority Tasks',
                  child: Column(
                    children: const [
                      _TaskRow(title: 'Chemistry Quiz Prep', progress: 0.6),
                      _TaskRow(title: 'Algorithm Notes Review', progress: 0.3),
                      _TaskRow(title: 'English Essay Outline', progress: 0.8),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _SoftCard(
                  title: 'Upcoming Exams',
                  child: Row(
                    children: [
                      Expanded(
                        child: _MiniExamCard(
                          title: 'Calculus Midterm',
                          days: '6 days',
                          risk: 'Medium',
                          color: AppColors.amber,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _MiniExamCard(
                          title: 'Physics Lab',
                          days: '12 days',
                          risk: 'Low',
                          color: AppColors.mint,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _SoftCard(
                  title: 'Productivity Score',
                  child: Row(
                    children: [
                      _ScoreCircle(score: '82'),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Today is on track',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Focus consistency +6% · Mood stable',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: AppColors.navy.withOpacity(0.7),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _AlertCard(
                  title: 'Burnout alert',
                  message:
                      'You studied 6 days straight. Consider a 30 min reset.',
                  actionLabel: 'Start Reset',
                ),
                const SizedBox(height: 96),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SoftCard extends StatelessWidget {
  const _SoftCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
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
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({required this.time, required this.title});

  final String time;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.electric,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            time,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.navy.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskRow extends StatelessWidget {
  const _TaskRow({required this.title, required this.progress});

  final String title;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              Text('${(progress * 100).round()}%'),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: AppColors.line,
              valueColor: const AlwaysStoppedAnimation(AppColors.electric),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniExamCard extends StatelessWidget {
  const _MiniExamCard({
    required this.title,
    required this.days,
    required this.risk,
    required this.color,
  });

  final String title;
  final String days;
  final String risk;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(days, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              risk,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreCircle extends StatelessWidget {
  const _ScoreCircle({required this.score});

  final String score;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 78,
      height: 78,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.electric, width: 6),
      ),
      child: Center(
        child: Text(
          score,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  const _AlertCard({
    required this.title,
    required this.message,
    required this.actionLabel,
  });

  final String title;
  final String message;
  final String actionLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.rose.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.rose.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: AppColors.rose),
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
                Text(message, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          const SizedBox(width: 12),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.rose,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {},
            child: Text(actionLabel),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.label, this.isSelected = false});

  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 20 : 24,
        vertical: isSmallScreen ? 10 : 12,
      ),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF1C1B29) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isSelected ? const Color(0xFF1C1B29) : const Color(0xFFE0E0E0),
          width: 1.5,
        ),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: isSmallScreen ? 13 : 14,
          color: isSelected ? Colors.white : const Color(0xFF4A4A4A),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _FloatingBadge extends StatelessWidget {
  const _FloatingBadge({
    required this.text,
    required this.color,
    required this.size,
  });

  final String text;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withOpacity(0.85),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(size * 0.6),
          topRight: Radius.circular(size * 0.3),
          bottomLeft: Radius.circular(size * 0.3),
          bottomRight: Radius.circular(size * 0.6),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: size * 0.35,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF1C1B29),
          ),
        ),
      ),
    );
  }
}
