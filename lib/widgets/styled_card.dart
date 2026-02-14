import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';

class StyledCard extends StatelessWidget {
  const StyledCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconBackgroundColor,
    required this.gradientColors,
    this.score,
    this.buttonLabel,
    this.isLocked = false,
    this.onButtonPressed,
    this.onCardTap,
    this.assetImage,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconBackgroundColor;
  final List<Color> gradientColors;
  final String? score;
  final String? buttonLabel;
  final bool isLocked;
  final VoidCallback? onButtonPressed;
  final VoidCallback? onCardTap;
  final String? assetImage;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final iconSize = isSmallScreen ? 48.0 : 54.0;
    final padding = isSmallScreen ? 14.0 : 18.0;

    return GestureDetector(
      onTap: onCardTap,
      child: Container(
        margin: EdgeInsets.only(bottom: isSmallScreen ? 12 : 14),
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(isSmallScreen ? 20 : 26),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: iconSize,
                  height: iconSize,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: iconSize - 8,
                      height: iconSize - 8,
                      decoration: BoxDecoration(
                        color: iconBackgroundColor.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        color: iconBackgroundColor,
                        size: isSmallScreen ? 20 : 24,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                if (score != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: const BoxDecoration(
                      color: Color(0xFF1C1B29),
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 52,
                      minHeight: 52,
                    ),
                    child: Center(
                      child: Text(
                        score!,
                        style: GoogleFonts.nunito(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: isSmallScreen ? 10 : 14),
            Text(
              title,
              style: GoogleFonts.nunito(
                fontSize: isSmallScreen ? 15 : 17,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
                height: 1.2,
              ),
            ),
            SizedBox(height: isSmallScreen ? 4 : 6),
            Text(
              subtitle,
              style: GoogleFonts.nunito(
                fontSize: isSmallScreen ? 12 : 13.5,
                fontWeight: FontWeight.w600,
                color: AppColors.navy.withOpacity(0.7),
                height: 1.4,
              ),
            ),
            if (buttonLabel != null) ...[
              SizedBox(height: isSmallScreen ? 10 : 14),
              if (assetImage != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 16),
                  child: Image.asset(
                    assetImage!,
                    height: isSmallScreen ? 90 : 110,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  ),
                ),
                SizedBox(height: isSmallScreen ? 10 : 14),
              ],
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: isLocked
                      ? const Color(0xFFFFD5B3)
                      : const Color(0xFFFFD5B3),
                  foregroundColor: isLocked
                      ? const Color(0xFF6B3F22)
                      : const Color(0xFF6B3F22),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 11,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                onPressed: isLocked ? null : onButtonPressed,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isLocked) ...[
                      const Icon(Icons.lock_rounded, size: 16),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      buttonLabel!,
                      style: GoogleFonts.nunito(fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
