import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ModernBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;
  final bool useShadow;

  const ModernBackButton({
    super.key,
    this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.size = 44,
    this.useShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: useShadow
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
          border: Border.all(color: AppColors.line.withOpacity(0.15), width: 1),
        ),
        child: InkWell(
          onTap: onPressed ?? () => Navigator.of(context).pop(),
          borderRadius: BorderRadius.circular(12),
          splashColor: AppColors.electric.withOpacity(0.1),
          child: Center(
            child: Icon(
              Icons.arrow_back_ios_new,
              size: 18,
              color: iconColor ?? AppColors.electric,
            ),
          ),
        ),
      ),
    );
  }
}
