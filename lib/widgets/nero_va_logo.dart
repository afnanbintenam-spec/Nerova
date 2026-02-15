import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class NeroVaLogo extends StatelessWidget {
  final double size;

  const NeroVaLogo({super.key, this.size = 120});

  @override
  Widget build(BuildContext context) {
    final pillWidth = size * 0.7;
    final pillHeight = size * 0.15;
    final spacing = size * 0.08;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Blue pill
        _LogoPill(
          width: pillWidth,
          height: pillHeight,
          color: AppColors.electric,
        ),
        SizedBox(height: spacing),

        // Orange/Peach pill
        _LogoPill(
          width: pillWidth,
          height: pillHeight,
          color: const Color(0xFFFFB997), // Peachy orange
        ),
        SizedBox(height: spacing),

        // Yellow pill
        _LogoPill(width: pillWidth, height: pillHeight, color: AppColors.amber),
        SizedBox(height: spacing),

        // Teal/Mint pill
        _LogoPill(width: pillWidth, height: pillHeight, color: AppColors.mint),
      ],
    );
  }
}

class _LogoPill extends StatelessWidget {
  final double width;
  final double height;
  final Color color;

  const _LogoPill({
    required this.width,
    required this.height,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(height / 2),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
    );
  }
}
