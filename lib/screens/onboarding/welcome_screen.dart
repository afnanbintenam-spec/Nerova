import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import '../../animations/page_transitions.dart';
import '../../theme/app_theme.dart';
import '../auth/login_screen.dart';
import '../auth/register_screen.dart';

const String _welcomeHeroAsset = 'assets/images/onboarding/welcome_hero.png';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Responsive design tokens (8dp grid + clamping)
    final padX = (screenWidth * 0.04).clamp(16.0, 24.0);
    final padTopBottom = (screenHeight * 0.02).clamp(12.0, 16.0);
    final spaceIllustration = (screenHeight * 0.03).clamp(16.0, 32.0);
    final spaceHeadline = (screenHeight * 0.02).clamp(12.0, 20.0);
    final btnHeight = (screenHeight * 0.055).clamp(42.0, 50.0);
    final btnRadius = (screenWidth * 0.035).clamp(12.0, 16.0);

    // Typography sizes
    final h1FontSize = (screenWidth * 0.065).clamp(26.0, 36.0);
    final bodyFontSize = (screenWidth * 0.038).clamp(13.0, 15.0);
    final btnFontSize = (screenWidth * 0.038).clamp(14.0, 16.0);

    // Illustration sizing - larger, more prominent
    final illustrationWidth = screenWidth * 0.95;
    final illustrationHeight = (screenHeight * 0.42).clamp(260.0, 380.0);
    final illustrationRadius = (screenWidth * 0.08).clamp(24.0, 36.0);

    return Scaffold(
      body: Stack(
        children: [
          const _WelcomeBackground(),
          // Decorative curve elements
          Positioned(
            right: -30,
            top: 120,
            child: CustomPaint(
              size: const Size(120, 120),
              painter: _CurvePainter(
                color: const Color(0xFFFFD5B3),
                rotation: 0,
              ),
            ),
          ),
          Positioned(
            left: -20,
            top: 280,
            child: CustomPaint(
              size: const Size(100, 100),
              painter: _CurvePainter(
                color: const Color(0xFF88D0E6),
                rotation: 0.3,
              ),
            ),
          ),
          Positioned(
            right: -40,
            bottom: 220,
            child: CustomPaint(
              size: const Size(130, 100),
              painter: _CurvePainter(
                color: const Color(0xFFF5A8A8),
                rotation: -0.2,
              ),
            ),
          ),
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
                        // A) Logo (skip for now, asset path issue)
                        // SizedBox(height: spaceLogoBelow),

                        // B) Illustration block (full-width, prominent)
                        SizedBox(
                          width: illustrationWidth,
                          height: illustrationHeight,
                          child: _MascotHeroImage(
                            assetPath: _welcomeHeroAsset,
                            borderRadius: illustrationRadius,
                          ),
                        ),
                        SizedBox(height: spaceIllustration),

                        // C) Headline block (prominent, larger with highlighted Learning)
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "Let's Start\nYour ",
                                style: GoogleFonts.nunito(
                                  fontSize: h1FontSize,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.ink,
                                  height: 1.15,
                                ),
                              ),
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                baseline: TextBaseline.alphabetic,
                                child: ClipPath(
                                  clipper: _TrapeziumClipper(
                                    rightInset: h1FontSize * 0.4,
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: h1FontSize * 0.35,
                                      vertical: h1FontSize * 0.15,
                                    ),
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 2,
                                    ),
                                    color: const Color(0xFF7C6FD5),
                                    child: Text(
                                      'Learning',
                                      style: GoogleFonts.nunito(
                                        fontSize: h1FontSize,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                        height: 1.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              TextSpan(
                                text: "\nAdventure",
                                style: GoogleFonts.nunito(
                                  fontSize: h1FontSize,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.ink,
                                  height: 1.15,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: spaceHeadline),

                        // D) Subtext block
                        Text(
                          'Your study buddy for calmer, smarter days.',
                          style: GoogleFonts.nunito(
                            fontSize: bodyFontSize,
                            height: 1.5,
                            color: AppColors.navy.withValues(alpha: 0.7),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),

                        // E) CTA Buttons block (horizontal with Sign up, Log in, and arrow)
                        Row(
                          children: [
                            // Sign up button
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  AppPageTransitions.fadeScaleTransition(
                                    builder: (_) => const RegisterScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                'Sign up',
                                style: GoogleFonts.nunito(
                                  fontSize: btnFontSize - 1,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.navy.withValues(alpha: 0.7),
                                ),
                              ),
                            ),
                            const Spacer(),
                            // Log in button
                            SizedBox(
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
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  elevation: 0,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                    AppPageTransitions.fadeScaleTransition(
                                      builder: (_) => const LoginScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Log in',
                                  style: GoogleFonts.nunito(
                                    fontSize: btnFontSize,
                                    fontWeight: FontWeight.w700,
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
        color: color.withValues(alpha: opacity),
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
              color: Colors.black.withValues(alpha: 0.12),
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
            errorBuilder: (context, error, stackTrace) => Container(
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

class _TrapeziumClipper extends CustomClipper<Path> {
  _TrapeziumClipper({required this.rightInset});

  final double rightInset;

  @override
  Path getClip(Size size) {
    final inset = rightInset.clamp(0, size.width * 0.6);
    return Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width - inset, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(covariant _TrapeziumClipper oldClipper) {
    return oldClipper.rightInset != rightInset;
  }
}

class _CurvePainter extends CustomPainter {
  final Color color;
  final double rotation;

  _CurvePainter({required this.color, this.rotation = 0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(rotation);
    canvas.translate(-size.width / 2, -size.height / 2);
    final path = Path();
    path.moveTo(0, size.height * 0.3);
    path.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.1,
      size.width * 0.6,
      size.height * 0.4,
    );
    path.quadraticBezierTo(
      size.width * 0.8,
      size.height * 0.6,
      size.width,
      size.height * 0.5,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
