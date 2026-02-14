import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';
import '../../widgets/modern_back_button.dart';
import '../auth/login_screen.dart';

const String _welcomeHeroAsset = 'assets/images/onboarding/welcome_hero.png';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final horizontalPadding = isSmallScreen ? 18.0 : 22.0;

    return Scaffold(
      body: Stack(
        children: [
          const _WelcomeBackground(),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: isSmallScreen ? 12 : 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  const ModernBackButton(),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Text(
                        'University Study Planner',
                        style: GoogleFonts.nunito(
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy,
                          fontSize: 12.5,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 14 : 18),
                  const _HeroMascot(),
                  SizedBox(height: isSmallScreen ? 18 : 24),
                  Text.rich(
                    TextSpan(
                      style: GoogleFonts.nunito(
                        fontSize: isSmallScreen ? 26 : 30,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                        color: AppColors.ink,
                      ),
                      children: [
                        const TextSpan(text: "Let's Start\nYour "),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isSmallScreen ? 8 : 10,
                              vertical: 4,
                            ),
                            margin: const EdgeInsets.only(right: 4),
                            decoration: BoxDecoration(
                              color: AppColors.electric.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'Learning',
                              style: GoogleFonts.nunito(
                                fontSize: isSmallScreen ? 24 : 28,
                                fontWeight: FontWeight.w900,
                                color: AppColors.electric,
                              ),
                            ),
                          ),
                        ),
                        const TextSpan(text: 'Adventure'),
                      ],
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 10 : 12),
                  Text(
                    'Plan smarter, learn faster, and stay balanced with daily guidance.',
                    style: GoogleFonts.nunito(
                      fontSize: isSmallScreen ? 13 : 14.5,
                      height: 1.5,
                      color: AppColors.navy.withOpacity(0.7),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDE7FF),
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => const LoginScreen(),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.navy.withOpacity(0.7),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                          ),
                          child: Text(
                            'Skip',
                            style: GoogleFonts.nunito(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFFFFD5B3),
                            foregroundColor: const Color(0xFF6B3F22),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999),
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
                            'Start Learning',
                            style: GoogleFonts.nunito(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1C1B29),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroMascot extends StatelessWidget {
  const _HeroMascot();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      child: Stack(
        children: [
          Positioned(left: 6, top: 40, child: _StarBadge(text: 'Hi')),
          Positioned(right: 12, bottom: 22, child: _StarBadge(text: 'Hello')),
          Center(
            child: Container(
              height: 280,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
              decoration: BoxDecoration(
                color: const Color(0xFFF6F2FF),
                borderRadius: BorderRadius.circular(36),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(child: _BookStack()),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _MascotHeroImage(assetPath: _welcomeHeroAsset),
                  ),
                ],
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

class _BookStack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _BookSlice(color: const Color(0xFF9CC9FF)),
        const SizedBox(height: 8),
        _BookSlice(color: const Color(0xFFFFC8B3)),
        const SizedBox(height: 8),
        _BookSlice(color: const Color(0xFFFFE9A6)),
        const SizedBox(height: 8),
        _BookSlice(color: const Color(0xFF8BE0D5)),
      ],
    );
  }
}

class _BookSlice extends StatelessWidget {
  const _BookSlice({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22,
      width: 92,
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
  const _MascotHeroImage({required this.assetPath});

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 138,
          height: 176,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(26),
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
        const SizedBox(height: 10),
        Container(
          height: 18,
          width: 90,
          decoration: BoxDecoration(
            color: const Color(0xFFE3D9FF),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ],
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
