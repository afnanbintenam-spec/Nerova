import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';
import 'welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late List<AnimationController> _letterControllers;
  late List<Animation<Offset>> _slideAnimations;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<double>> _scaleAnimations;

  final String _appName = 'NERO VA';
  final List<Duration> _delays = [
    const Duration(milliseconds: 100),
    const Duration(milliseconds: 300),
    const Duration(milliseconds: 500),
    const Duration(milliseconds: 700),
    const Duration(milliseconds: 900),
    const Duration(milliseconds: 1100),
    const Duration(milliseconds: 1300),
  ];

  final List<Offset> _startOffsets = [
    const Offset(0, -2), // N - drop from top
    const Offset(2, 0), // E - come from right
    const Offset(0, 2), // R - come from bottom
    const Offset(-2, 0), // O - come from left
    const Offset(0, -1.5), // space - drop
    const Offset(2, 1), // V - diagonal from top-right
    const Offset(-1, 1.5), // A - diagonal from bottom-left
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _navigateToNextScreen();
  }

  void _initializeAnimations() {
    _letterControllers = List.generate(
      _appName.length,
      (_) => AnimationController(
        duration: const Duration(milliseconds: 800),
        vsync: this,
      ),
    );

    _slideAnimations = List.generate(
      _appName.length,
      (index) =>
          Tween<Offset>(begin: _startOffsets[index], end: Offset.zero).animate(
            CurvedAnimation(
              parent: _letterControllers[index],
              curve: Curves.elasticOut,
            ),
          ),
    );

    _fadeAnimations = List.generate(
      _appName.length,
      (index) => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _letterControllers[index],
          curve: const Interval(0.0, 0.7, curve: Curves.easeIn),
        ),
      ),
    );

    _scaleAnimations = List.generate(
      _appName.length,
      (index) => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _letterControllers[index],
          curve: Curves.elasticOut,
        ),
      ),
    );

    // Start animations with stagger
    for (int i = 0; i < _appName.length; i++) {
      Future.delayed(_delays[i], () {
        if (mounted) {
          _letterControllers[i].forward();
        }
      });
    }
  }

  void _navigateToNextScreen() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const WelcomeScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    for (var controller in _letterControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mist,
      body: Stack(
        children: [
          // Background Decorations (Low Opacity)
          Positioned(
            top: -80,
            left: -60,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    AppColors.electric.withValues(alpha: 0.08),
                    AppColors.electric.withValues(alpha: 0.02),
                  ],
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 200,
            right: -100,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    AppColors.mint.withValues(alpha: 0.07),
                    AppColors.mint.withValues(alpha: 0.01),
                  ],
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: 50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    AppColors.rose.withValues(alpha: 0.06),
                    AppColors.rose.withValues(alpha: 0.01),
                  ],
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            right: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    AppColors.amber.withValues(alpha: 0.07),
                    AppColors.amber.withValues(alpha: 0.01),
                  ],
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Main Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated App Name
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_appName.length, (index) {
                    final letter = _appName[index];

                    return SlideTransition(
                      position: _slideAnimations[index],
                      child: FadeTransition(
                        opacity: _fadeAnimations[index],
                        child: ScaleTransition(
                          scale: _scaleAnimations[index],
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: Text(
                              letter,
                              style: GoogleFonts.nunito(
                                fontSize: 72,
                                fontWeight: FontWeight.w900,
                                color: letter == ' '
                                    ? Colors.transparent
                                    : AppColors.electric,
                                letterSpacing: 2,
                                shadows: letter == ' '
                                    ? []
                                    : [
                                        BoxShadow(
                                          color: AppColors.electric.withValues(alpha: 
                                            0.3,
                                          ),
                                          blurRadius: 20,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 40),

                // Subtitle with fade animation
                FadeTransition(
                  opacity: _letterControllers.isNotEmpty
                      ? Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                            parent: _letterControllers.last,
                            curve: const Interval(0.5, 1.0),
                          ),
                        )
                      : AlwaysStoppedAnimation(1.0),
                  child: Text(
                    'Your Learning Companion',
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.navy.withValues(alpha: 0.6),
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Loading indicator at bottom
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _letterControllers.isNotEmpty
                  ? Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                        parent: _letterControllers.last,
                        curve: const Interval(0.6, 1.0),
                      ),
                    )
                  : AlwaysStoppedAnimation(1.0),
              child: Center(
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation(
                      AppColors.electric.withValues(alpha: 0.6),
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
