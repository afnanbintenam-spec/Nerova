import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';
import '../auth/login_screen.dart';

const String _welcomeHeroAsset = 'assets/images/onboarding/welcome_hero.png';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Responsive design tokens (8dp grid + clamping)
    final padX = (screenWidth * 0.06).clamp(20.0, 28.0);
    final padTopBottom = (screenHeight * 0.04).clamp(16.0, 24.0);
    final spaceLogoBelow = (screenHeight * 0.04).clamp(24.0, 48.0);
    final spaceIllustration = (screenHeight * 0.06).clamp(32.0, 56.0);
    final spaceHeadline = (screenHeight * 0.03).clamp(16.0, 24.0);
    final spaceToCTA = (screenHeight * 0.06).clamp(32.0, 64.0);
    final btnHeight = (screenHeight * 0.065).clamp(48.0, 56.0);
    final btnRadius = (screenWidth * 0.04).clamp(14.0, 18.0);

    // Typography sizes
    final logoFontSize = (screenWidth * 0.07).clamp(26.0, 34.0);
    final h1FontSize = (screenWidth * 0.062).clamp(24.0, 32.0);
    final h2FontSize = (screenWidth * 0.048).clamp(18.0, 24.0);
    final bodyFontSize = (screenWidth * 0.038).clamp(14.0, 16.0);
    final btnFontSize = (screenWidth * 0.04).clamp(15.0, 17.0);

    // Illustration sizing
    final illustrationWidth = screenWidth * 0.82;
    final illustrationHeight = (screenHeight * 0.38).clamp(220.0, 320.0);
    final illustrationRadius = (screenWidth * 0.06).clamp(20.0, 32.0);

    return Scaffold(
      body: Stack(
        children: [
          const _WelcomeBackground(),
          SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      screenHeight -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: padX,
                      vertical: padTopBottom,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // A) Logo block
                        Text(
                          'NEROVA',
                          style: GoogleFonts.nunito(
                            fontSize: logoFontSize,
                            fontWeight: FontWeight.w900,
                            color: AppColors.ink,
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(height: spaceLogoBelow),

                        // B) Illustration block (bounded)
                        Center(
                          child: SizedBox(
                            width: illustrationWidth,
                            height: illustrationHeight,
                            child: _MascotHeroImage(
                              assetPath: _welcomeHeroAsset,
                              borderRadius: illustrationRadius,
                            ),
                          ),
                        ),
                        SizedBox(height: spaceIllustration),

                        // C) Headline block (two lines)
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Your ',
                                style: GoogleFonts.nunito(
                                  fontSize: h1FontSize,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.ink,
                                  height: 1.2,
                                ),
                              ),
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: h1FontSize * 0.4,
                                    vertical: 4,
                                  ),
                                  margin: const EdgeInsets.only(right: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.electric.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(
                                      h1FontSize * 0.5,
                                    ),
                                  ),
                                  child: Text(
                                    'study buddy',
                                    style: GoogleFonts.nunito(
                                      fontSize: h1FontSize,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.electric,
                                      height: 1.2,
                                    ),
                                  ),
                                ),
                              ),
                              TextSpan(
                                text: '\nfor calmer, smarter days.',
                                style: GoogleFonts.nunito(
                                  fontSize: h2FontSize,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.ink,
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: spaceHeadline),

                        // D) Subtext block
                        Text(
                          'Plan your tasks. Learn with clarity. Stay focused. Take care of your mind—all in one place.',
                          style: GoogleFonts.nunito(
                            fontSize: bodyFontSize,
                            height: 1.55,
                            color: AppColors.navy.withOpacity(0.75),
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 6,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: spaceToCTA),

                        // E) CTA Buttons block (clean, two-button stack)
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Primary button (Sign Up)
                            SizedBox(
                              width: double.infinity,
                              height: btnHeight,
                              child: FilledButton(
                                style: FilledButton.styleFrom(
                                  backgroundColor: const Color(0xFFFFD5B3),
                                  foregroundColor: const Color(0xFF6B3F22),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      btnRadius,
                                    ),
                                  ),
                                  elevation: 0,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (_) => const LoginScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Sign Up',
                                  style: GoogleFonts.nunito(
                                    fontSize: btnFontSize,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Secondary button (Log In)
                            SizedBox(
                              width: double.infinity,
                              height: btnHeight,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.navy.withOpacity(
                                    0.8,
                                  ),
                                  side: BorderSide(
                                    color: AppColors.navy.withOpacity(0.2),
                                    width: 1,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      btnRadius,
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (_) => const LoginScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Log In',
                                  style: GoogleFonts.nunito(
                                    fontSize: btnFontSize,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: padTopBottom),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WelcomeBackground extends StatelessWidget {
  const _WelcomeBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFECE6FF), Color(0xFFF7F5FF)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -40,
            top: 90,
            child: _SoftBlob(color: const Color(0xFFD8D2FF), size: 180),
          ),
          Positioned(
            left: -60,
            bottom: 120,
            child: _SoftBlob(color: const Color(0xFFE0DCFF), size: 200),
          ),
          Positioned(
            left: 18,
            top: 210,
            child: Transform.rotate(
              angle: -0.06,
              child: _AsymmetricPill(
                width: 220,
                height: 62,
                color: const Color(0xFFD7CCFF),
                opacity: 0.55,
              ),
            ),
          ),
          Positioned(
            right: 24,
            bottom: 140,
            child: Transform.rotate(
              angle: 0.08,
              child: _AsymmetricPill(
                width: 140,
                height: 46,
                color: const Color(0xFFE7DFFF),
                opacity: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SoftBlob extends StatelessWidget {
  const _SoftBlob({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(size * 0.45),
      ),
    );
  }
}

class _AsymmetricPill extends StatelessWidget {
  const _AsymmetricPill({
    required this.width,
    required this.height,
    required this.color,
    this.opacity = 1,
  });

  final double width;
  final double height;
  final Color color;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color.withOpacity(opacity),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(36),
          bottomLeft: Radius.circular(36),
          topRight: Radius.circular(14),
          bottomRight: Radius.circular(14),
        ),
      ),
    );
  }
}

class _BookSlice extends StatelessWidget {
  const _BookSlice({required this.color, this.width = 92});

  final Color color;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
    );
  }
}

class _MascotHeroImage extends StatelessWidget {
  const _MascotHeroImage({required this.assetPath, this.borderRadius = 26});

  final String assetPath;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateX(0.05)
        ..rotateZ(-0.02),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 24,
              offset: const Offset(0, 12),
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Image.asset(
            assetPath,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: const Color(0xFFFFF4F1),
              child: const Center(
                child: Icon(
                  Icons.face_retouching_natural,
                  color: Color(0xFFE4A8A8),
                  size: 56,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StarBadge extends StatelessWidget {
  const _StarBadge({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFB9A7FF),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Center(
        child: Text(
          text,
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
