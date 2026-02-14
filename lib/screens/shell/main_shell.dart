import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../home/home_screen.dart';
import '../planner/planner_screen.dart';
import '../ai/ai_screen.dart';
import '../focus/focus_screen.dart';
import '../insights/insights_screen.dart';

final bottomNavIndexProvider = StateProvider<int>((ref) => 0);

class MainShell extends ConsumerWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(bottomNavIndexProvider);
    return Scaffold(
      body: IndexedStack(
        index: index,
        children: const [
          HomeScreen(),
          PlannerScreen(),
          AiScreen(),
          FocusScreen(),
          InsightsScreen(),
        ],
      ),
      bottomNavigationBar: LayoutBuilder(
        builder: (context, constraints) {
          final isSmallScreen = constraints.maxWidth < 600;
          final navHeight = isSmallScreen ? 64.0 : 70.0;
          final horizontalPadding = isSmallScreen ? 16.0 : 24.0;

          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: isSmallScreen ? 12 : 16,
            ),
            color: Colors.transparent,
            child: Center(
              child: Container(
                height: navHeight,
                constraints: BoxConstraints(
                  maxWidth: isSmallScreen ? 360 : 400,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1B29),
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _NavButton(
                      icon: Icons.home_rounded,
                      isActive: index == 0,
                      onTap: () =>
                          ref.read(bottomNavIndexProvider.notifier).state = 0,
                      isSmallScreen: isSmallScreen,
                    ),
                    _NavButton(
                      icon: Icons.auto_stories_rounded,
                      isActive: index == 1,
                      onTap: () =>
                          ref.read(bottomNavIndexProvider.notifier).state = 1,
                      isSmallScreen: isSmallScreen,
                    ),
                    _NavButton(
                      icon: Icons.hourglass_bottom_rounded,
                      isActive: index == 2,
                      onTap: () =>
                          ref.read(bottomNavIndexProvider.notifier).state = 2,
                      isSmallScreen: isSmallScreen,
                    ),
                    _NavButton(
                      icon: Icons.settings_rounded,
                      isActive: index == 3,
                      onTap: () =>
                          ref.read(bottomNavIndexProvider.notifier).state = 3,
                      isSmallScreen: isSmallScreen,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.icon,
    required this.isActive,
    required this.onTap,
    required this.isSmallScreen,
  });

  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;
  final bool isSmallScreen;

  @override
  Widget build(BuildContext context) {
    final buttonSize = isSmallScreen ? 48.0 : 56.0;
    final iconSize = isSmallScreen ? 22.0 : 26.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: buttonSize,
        height: buttonSize,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFFFD5B3) : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isActive ? const Color(0xFF1C1B29) : Colors.white,
          size: iconSize,
        ),
      ),
    );
  }
}
