import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../providers/auth_provider.dart';
import '../../providers/streak_analytics_provider.dart';
import '../../theme/app_theme.dart';

const String _homeHeroAsset = 'assets/images/onboarding/home_header.png';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final horizontalPadding = isSmallScreen ? 16.0 : 20.0;

    // Get current user from auth provider
    final authState = ref.watch(authProvider);
    final userName = authState.user?.name ?? 'User';

    // Watch burnout alert
    final analyticsState = ref.watch(streakAnalyticsProvider);
    final burnoutAlert = analyticsState.burnoutAlert;

    return Scaffold(
      backgroundColor: AppColors.mist,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 16,
          ),
          children: [
            // Profile Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // Avatar
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.electric.withValues(alpha: 0.2),
                        image: const DecorationImage(
                          image: AssetImage(
                            'assets/images/onboarding/home_header.png',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.electric.withValues(alpha: 0.3),
                        ),
                        child: Icon(
                          Icons.person_rounded,
                          color: AppColors.electric,
                          size: 28,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Greeting & Progress
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello, $userName',
                          style: GoogleFonts.nunito(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.ink,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.star_rounded,
                              color: AppColors.amber,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Progress 10%',
                              style: GoogleFonts.nunito(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.navy.withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                // Notification Bell
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.notifications_outlined,
                        color: AppColors.navy,
                        size: 22,
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.rose,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Progress Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7B68EE), Color(0xFF6A5ACD)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Level 1',
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Next step to greatness!',
                            style: GoogleFonts.nunito(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.emoji_events_rounded,
                          color: Color(0xFFFFD700),
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Progress Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: 0.1,
                      minHeight: 8,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      valueColor: const AlwaysStoppedAnimation(
                        Color(0xFFFFD700),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '10% to next level',
                    style: GoogleFonts.nunito(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Burnout Alert (if applicable)
            if (burnoutAlert != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color:
                      (burnoutAlert.isHighSeverity
                              ? AppColors.rose
                              : AppColors.amber)
                          .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color:
                        (burnoutAlert.isHighSeverity
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
                          burnoutAlert.isHighSeverity
                              ? Icons.error_rounded
                              : Icons.warning_rounded,
                          color: burnoutAlert.isHighSeverity
                              ? AppColors.rose
                              : AppColors.amber,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            burnoutAlert.message,
                            style: GoogleFonts.dmSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: burnoutAlert.isHighSeverity
                                  ? AppColors.rose
                                  : AppColors.amber,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...?burnoutAlert.suggestedActions
                        ?.take(2)
                        .map(
                          (action) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
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
            const SizedBox(height: 24),

            // Category Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: const [
                  _CategoryChip(label: 'Lessons', isSelected: true),
                  SizedBox(width: 8),
                  _CategoryChip(label: 'Games'),
                  SizedBox(width: 8),
                  _CategoryChip(label: 'Stories'),
                  SizedBox(width: 8),
                  _CategoryChip(label: 'Activities'),
                  SizedBox(width: 8),
                  _CategoryChip(label: 'Discover'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Lessons Card
            _ContentCard(
              title: 'Lessons',
              subtitle:
                  'Fun learning lessons that help you grow smarter daily.',
              icon: Icons.school_rounded,
              assetImage: _homeHeroAsset,
            ),
            const SizedBox(height: 16),

            // Games Card
            _ContentCard(
              title: 'Games',
              subtitle: 'Interactive games to test your knowledge.',
              icon: Icons.games_rounded,
              hasControls: true,
            ),
            const SizedBox(height: 16),

            // Stories Card
            _ContentCard(
              title: 'Stories',
              subtitle: 'Inspiring stories to motivate you.',
              icon: Icons.menu_book_rounded,
            ),
            const SizedBox(height: 96),
          ],
        ),
      ),
    );
  }
}

class _ContentCard extends StatelessWidget {
  const _ContentCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.assetImage,
    this.hasControls = false,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final String? assetImage;
  final bool hasControls;

  @override
  Widget build(BuildContext context) {
    return Container(
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: 220,
                    child: Text(
                      subtitle,
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.navy.withValues(alpha: 0.6),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.electric.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: AppColors.electric,
                  size: 20,
                ),
              ),
            ],
          ),
          if (assetImage != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                assetImage!,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 120,
                  color: AppColors.electric.withValues(alpha: 0.1),
                  child: Icon(
                    icon,
                    size: 48,
                    color: AppColors.electric.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
          ],
          if (hasControls) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.mist,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ControlButton(icon: Icons.circle_rounded),
                  const SizedBox(width: 4),
                  _ControlButton(icon: Icons.music_note_rounded),
                  const SizedBox(width: 4),
                  _ControlButton(icon: Icons.grid_3x3_rounded),
                  const SizedBox(width: 4),
                  _ControlButton(icon: Icons.visibility_rounded),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  const _ControlButton({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 16, color: AppColors.navy),
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
