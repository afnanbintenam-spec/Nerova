import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../providers/exam_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/modern_back_button.dart';
import '../../widgets/styled_card.dart';

class ExamHubScreen extends ConsumerWidget {
  const ExamHubScreen({super.key});

  String _getRiskIndicatorColor(bool isHighRisk, bool isMediumRisk) {
    if (isHighRisk) return '🔴';
    if (isMediumRisk) return '🟡';
    return '🟢';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final examState = ref.watch(examListProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      backgroundColor: AppColors.mist,
      appBar: AppBar(
        leading: const ModernBackButton(),
        title: Text(
          'Exam Hub',
          style: GoogleFonts.dmSans(fontWeight: FontWeight.w700),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.read(examListProvider.notifier).loadExams(),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: examState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
              children: [
                StyledCard(
                  title: 'Your Exams',
                  subtitle: '${examState.exams.length} exams scheduled',
                  icon: Icons.calendar_month_rounded,
                  iconBackgroundColor: AppColors.electric,
                  gradientColors: const [Color(0xFFFFE8F0), Color(0xFFFFF5F8)],
                  score: examState.exams.length.toString(),
                  buttonLabel: 'Add Exam',
                  onButtonPressed: () {
                    // TODO: Implement add exam dialog
                  },
                ),
                const SizedBox(height: 20),
                if (examState.exams.isEmpty)
                  Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        Icon(
                          Icons.event_note_rounded,
                          size: 64,
                          color: AppColors.navy.withValues(alpha: 0.2),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No exams scheduled',
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.navy.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  ...examState.exams.map((exam) {
                    final daysLeft = exam.daysUntilExam.inDays;
                    final readiness = exam.readinessScore ?? 0;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      exam.title,
                                      style: GoogleFonts.dmSans(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.ink,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      exam.subject,
                                      style: GoogleFonts.nunito(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.navy.withValues(
                                          alpha: 0.6,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                _getRiskIndicatorColor(
                                  exam.isHighRisk,
                                  exam.isMediumRisk,
                                ),
                                style: const TextStyle(fontSize: 24),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Countdown',
                                      style: GoogleFonts.nunito(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.navy.withValues(
                                          alpha: 0.6,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      daysLeft > 0
                                          ? '$daysLeft days left'
                                          : 'Today',
                                      style: GoogleFonts.dmSans(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: daysLeft <= 3
                                            ? AppColors.rose
                                            : AppColors.electric,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Readiness',
                                      style: GoogleFonts.nunito(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.navy.withValues(
                                          alpha: 0.6,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Stack(
                                      children: [
                                        Container(
                                          height: 6,
                                          decoration: BoxDecoration(
                                            color: AppColors.navy.withValues(
                                              alpha: 0.1,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              3,
                                            ),
                                          ),
                                        ),
                                        FractionallySizedBox(
                                          widthFactor: readiness / 100,
                                          child: Container(
                                            height: 6,
                                            decoration: BoxDecoration(
                                              color: readiness >= 70
                                                  ? AppColors.mint
                                                  : readiness >= 40
                                                  ? AppColors.amber
                                                  : AppColors.rose,
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${readiness.toStringAsFixed(0)}%',
                                      style: GoogleFonts.nunito(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.electric,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          FilledButton(
                            onPressed: () {
                              // TODO: Navigate to study plan
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.electric,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'View Study Plan',
                              style: GoogleFonts.nunito(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              ],
            ),
    );
  }
}
