import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../onboarding/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  final List<String> letters = ['N', 'E', 'R', 'O', 'V', 'A'];
  final List<Color> pastelColors = [
    const Color(0xFFFFB3BA), // Pastel Red
    const Color(0xFFFFDFBA), // Pastel Orange
    const Color(0xFFFFFDBA), // Pastel Yellow
    const Color(0xFFBAFFBA), // Pastel Green
    const Color(0xFFBAE1FF), // Pastel Blue
    const Color(0xFFE1BAFF), // Pastel Purple
  ];

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(
      letters.length,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 400),
        vsync: this,
      ),
    );

    _animations = _controllers
        .map(
          (controller) => Tween<double>(begin: 0, end: 1).animate(
            CurvedAnimation(parent: controller, curve: Curves.elasticOut),
          ),
        )
        .toList();

    // Stagger animations: each letter starts 1 second apart
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 1000), () {
        if (mounted) {
          _controllers[i].forward();
        }
      });
    }

    // Navigate to WelcomeScreen after 7 seconds total
    Future.delayed(const Duration(seconds: 7), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const WelcomeScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive letter size
    final letterSize = (screenWidth * 0.14).clamp(48.0, 80.0);
    final letterSpacing = (screenWidth * 0.06).clamp(12.0, 24.0);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFECE6FF), Color(0xFFF7F5FF)],
          ),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              letters.length,
              (index) => Padding(
                padding: EdgeInsets.symmetric(horizontal: letterSpacing / 2),
                child: ScaleTransition(
                  scale: _animations[index],
                  child: Text(
                    letters[index],
                    style: GoogleFonts.nunito(
                      fontSize: letterSize,
                      fontWeight: FontWeight.w900,
                      color: pastelColors[index],
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
