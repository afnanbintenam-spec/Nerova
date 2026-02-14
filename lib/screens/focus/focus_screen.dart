import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';
import '../../widgets/modern_back_button.dart';
import '../../widgets/styled_card.dart';

class FocusScreen extends StatefulWidget {
  const FocusScreen({super.key});

  @override
  State<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen> {
  // Timer configuration
  static const int workDuration = 25 * 60; // 25 minutes in seconds
  static const int breakDuration = 5 * 60; // 5 minutes in seconds

  // Timer state
  Timer? _timer;
  int _remainingSeconds = workDuration;
  bool _isRunning = false;
  bool _isWorkSession = true;
  int _completedSessions = 0;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (_isRunning) return;

    setState(() {
      _isRunning = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _completeSession();
        }
      });
    });
  }

  void _pauseTimer() {
    setState(() {
      _isRunning = false;
    });
    _timer?.cancel();
  }

  void _resetTimer() {
    setState(() {
      _isRunning = false;
      _remainingSeconds = _isWorkSession ? workDuration : breakDuration;
    });
    _timer?.cancel();
  }

  void _completeSession() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      if (_isWorkSession) {
        _completedSessions++;
        _isWorkSession = false;
        _remainingSeconds = breakDuration;
      } else {
        _isWorkSession = true;
        _remainingSeconds = workDuration;
      }
    });

    // Show completion message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isWorkSession
                ? '🎉 Break completed! Ready for work?'
                : '🎉 Work session completed! Take a break!',
            style: GoogleFonts.nunito(fontWeight: FontWeight.w600),
          ),
          backgroundColor: AppColors.mint,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  void _skipSession() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _isWorkSession = !_isWorkSession;
      _remainingSeconds = _isWorkSession ? workDuration : breakDuration;
    });
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  double get _progress {
    final totalDuration = _isWorkSession ? workDuration : breakDuration;
    return 1 - (_remainingSeconds / totalDuration);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      appBar: AppBar(
        leading: const ModernBackButton(),
        title: Text(
          'Focus',
          style: GoogleFonts.dmSans(fontWeight: FontWeight.w700),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
        child: Column(
          children: [
            StyledCard(
              title: _isWorkSession ? 'Deep Work Mode' : 'Break Time',
              subtitle: _isWorkSession
                  ? 'Set a clear goal and block distractions'
                  : 'Relax and recharge your energy',
              icon: _isWorkSession ? Icons.timer_rounded : Icons.coffee_rounded,
              iconBackgroundColor: _isWorkSession
                  ? AppColors.mint
                  : AppColors.amber,
              gradientColors: _isWorkSession
                  ? const [Color(0xFFE8FFF9), Color(0xFFF2FFF9)]
                  : const [Color(0xFFFFF8E1), Color(0xFFFFFBF0)],
            ),
            SizedBox(height: isSmallScreen ? 20 : 24),

            // Timer display
            Container(
              padding: EdgeInsets.all(isSmallScreen ? 20 : 28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Circular progress timer
                  SizedBox(
                    width: isSmallScreen ? 200 : 220,
                    height: isSmallScreen ? 200 : 220,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Background circle
                        Container(
                          width: isSmallScreen ? 200 : 220,
                          height: isSmallScreen ? 200 : 220,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.mist,
                          ),
                        ),
                        // Progress indicator
                        SizedBox(
                          width: isSmallScreen ? 200 : 220,
                          height: isSmallScreen ? 200 : 220,
                          child: CircularProgressIndicator(
                            value: _progress,
                            strokeWidth: 12,
                            backgroundColor: Colors.transparent,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _isWorkSession
                                  ? AppColors.electric
                                  : AppColors.amber,
                            ),
                          ),
                        ),
                        // Time display
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _formatTime(_remainingSeconds),
                              style: GoogleFonts.dmSans(
                                fontSize: isSmallScreen ? 42 : 48,
                                fontWeight: FontWeight.w800,
                                color: AppColors.ink,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _isWorkSession
                                    ? AppColors.electric.withOpacity(0.1)
                                    : AppColors.amber.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _isWorkSession ? 'WORK' : 'BREAK',
                                style: GoogleFonts.dmSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: _isWorkSession
                                      ? AppColors.electric
                                      : AppColors.amber,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 20 : 24),

                  // Session info
                  Text(
                    'Attached Task: Calculus Revision',
                    style: GoogleFonts.dmSans(
                      fontSize: isSmallScreen ? 14 : 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.navy.withOpacity(0.8),
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 16 : 20),

                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!_isRunning) ...[
                        _ActionButton(
                          label: 'Start',
                          icon: Icons.play_arrow_rounded,
                          filled: true,
                          color: AppColors.electric,
                          onPressed: _startTimer,
                        ),
                        if (_remainingSeconds !=
                            (_isWorkSession
                                ? workDuration
                                : breakDuration)) ...[
                          const SizedBox(width: 12),
                          _ActionButton(
                            label: 'Reset',
                            icon: Icons.refresh_rounded,
                            onPressed: _resetTimer,
                          ),
                        ],
                      ] else ...[
                        _ActionButton(
                          label: 'Pause',
                          icon: Icons.pause_rounded,
                          filled: true,
                          color: AppColors.rose,
                          onPressed: _pauseTimer,
                        ),
                      ],
                      const SizedBox(width: 12),
                      _ActionButton(
                        label: 'Skip',
                        icon: Icons.skip_next_rounded,
                        onPressed: _skipSession,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: isSmallScreen ? 16 : 20),

            // Stats
            _StatRow(
              label: 'Completed Sessions',
              value: '$_completedSessions',
              icon: Icons.check_circle_rounded,
              color: AppColors.mint,
            ),
            const SizedBox(height: 12),
            _StatRow(
              label: 'Focus Streak',
              value: '4 days',
              icon: Icons.local_fire_department_rounded,
              color: AppColors.amber,
            ),
            const SizedBox(height: 12),
            _StatRow(
              label: 'Deep Work %',
              value: '72%',
              icon: Icons.trending_up_rounded,
              color: AppColors.electric,
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.filled = false,
    this.color,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool filled;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: filled
            ? (color ?? AppColors.electric)
            : AppColors.mist,
        foregroundColor: filled ? Colors.white : AppColors.navy,
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 16 : 20,
          vertical: isSmallScreen ? 12 : 14,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: filled ? 2 : 0,
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: isSmallScreen ? 18 : 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: isSmallScreen ? 14 : 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 16 : 18,
        vertical: isSmallScreen ? 14 : 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.dmSans(
                fontSize: isSmallScreen ? 14 : 15,
                fontWeight: FontWeight.w600,
                color: AppColors.navy.withOpacity(0.8),
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.dmSans(
              fontSize: isSmallScreen ? 16 : 18,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}
