import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../home/home_screen.dart';
import '../planner/planner_screen.dart';
import '../ai/ai_screen.dart';
import '../focus/focus_screen.dart';
import '../insights/insights_screen.dart';
import '../../services/connectivity_service.dart';
import '../../services/sync_service.dart';
import '../../widgets/state_widgets.dart';

final bottomNavIndexProvider = StateProvider<int>((ref) => 0);

class MainShell extends ConsumerStatefulWidget {
  final int initialIndex;

  const MainShell({super.key, this.initialIndex = 0});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  @override
  void initState() {
    super.initState();
    // Set initial index when widget is created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(bottomNavIndexProvider.notifier).state = widget.initialIndex;
    });
  }

  Widget _getScreenTitle(int index) {
    const titles = ['Dashboard', 'Planner', 'Nero AI', 'Focus', 'Insights'];
    return Text(titles[index]);
  }

  @override
  Widget build(BuildContext context) {
    final index = ref.watch(bottomNavIndexProvider);
    final connectivityStatus = ref.watch(connectivityStatusProvider);
    final pendingSyncCount = ref.watch(pendingSyncCountProvider);

    return Scaffold(
      drawer: _buildFeatureDrawer(context),
      appBar: AppBar(
        title: _getScreenTitle(index),
        backgroundColor: const Color(0xFF1C1B29),
        elevation: 0,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                'Nero VA',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Show offline banner when not connected
          connectivityStatus.when(
            data: (isOnline) {
              if (!isOnline) {
                return const OfflineBanner();
              }
              // Show sync indicator if there are pending operations
              if (pendingSyncCount > 0) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  color: Colors.amber.shade50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [SyncIndicator(pendingCount: pendingSyncCount)],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
            loading: () => const SizedBox.shrink(),
            error: (error, stackTrace) => const SizedBox.shrink(),
          ),
          Expanded(
            child: IndexedStack(
              index: index,
              children: const [
                HomeScreen(),
                PlannerScreen(),
                AiScreen(),
                FocusScreen(),
                InsightsScreen(),
              ],
            ),
          ),
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
                  maxWidth: isSmallScreen ? 420 : 480,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1B29),
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
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
                      icon: Icons.psychology_rounded,
                      isActive: index == 3,
                      onTap: () =>
                          ref.read(bottomNavIndexProvider.notifier).state = 3,
                      isSmallScreen: isSmallScreen,
                    ),
                    _NavButton(
                      icon: Icons.insights_rounded,
                      isActive: index == 4,
                      onTap: () =>
                          ref.read(bottomNavIndexProvider.notifier).state = 4,
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

  Widget _buildFeatureDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF1C1B29)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Study Features',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Access additional tools & features',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          _DrawerMenuItem(
            icon: Icons.assignment_rounded,
            title: 'Exams',
            subtitle: 'Track exam dates & readiness',
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed('/exams');
            },
          ),
          _DrawerMenuItem(
            icon: Icons.school_rounded,
            title: 'Courses',
            subtitle: 'View courses & weak topics',
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed('/courses');
            },
          ),
          _DrawerMenuItem(
            icon: Icons.library_books_rounded,
            title: 'Knowledge Vault',
            subtitle: 'Access study notes & summaries',
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed('/vault');
            },
          ),
          _DrawerMenuItem(
            icon: Icons.favorite_rounded,
            title: 'Wellness Hub',
            subtitle: 'Monitor burnout & stress levels',
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed('/stress-support');
            },
          ),
          _DrawerMenuItem(
            icon: Icons.analytics_rounded,
            title: 'Analytics & Trending',
            subtitle: 'View trends & burnout metrics',
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed('/analytics');
            },
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'MAIN FEATURES',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          _DrawerMenuItem(
            icon: Icons.home_rounded,
            title: 'Home',
            subtitle: 'Dashboard & quick access',
            onTap: () {
              Navigator.pop(context);
              ref.read(bottomNavIndexProvider.notifier).state = 0;
            },
          ),
          _DrawerMenuItem(
            icon: Icons.auto_stories_rounded,
            title: 'Planner',
            subtitle: 'Manage tasks & schedule',
            onTap: () {
              Navigator.pop(context);
              ref.read(bottomNavIndexProvider.notifier).state = 1;
            },
          ),
          _DrawerMenuItem(
            icon: Icons.hourglass_bottom_rounded,
            title: 'Nero AI',
            subtitle: 'AI-powered study assistant',
            onTap: () {
              Navigator.pop(context);
              ref.read(bottomNavIndexProvider.notifier).state = 2;
            },
          ),
          _DrawerMenuItem(
            icon: Icons.psychology_rounded,
            title: 'Focus',
            subtitle: 'Deep work sessions',
            onTap: () {
              Navigator.pop(context);
              ref.read(bottomNavIndexProvider.notifier).state = 3;
            },
          ),
          _DrawerMenuItem(
            icon: Icons.insights_rounded,
            title: 'Insights',
            subtitle: 'Analytics & progress',
            onTap: () {
              Navigator.pop(context);
              ref.read(bottomNavIndexProvider.notifier).state = 4;
            },
          ),
        ],
      ),
    );
  }
}

class _DrawerMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _DrawerMenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFFFD5B3)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      onTap: onTap,
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
