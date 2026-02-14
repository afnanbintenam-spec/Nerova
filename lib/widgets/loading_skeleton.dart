import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class LoadingSkeleton extends StatefulWidget {
  final double width;
  final double height;
  final double? borderRadius;

  const LoadingSkeleton({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  State<LoadingSkeleton> createState() => _LoadingSkeletonState();
}

class _LoadingSkeletonState extends State<LoadingSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 8),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [
                _animation.value - 0.3,
                _animation.value,
                _animation.value + 0.3,
              ].map((e) => e.clamp(0.0, 1.0)).toList(),
              colors: [
                AppColors.mist,
                AppColors.mist.withOpacity(0.5),
                AppColors.mist,
              ],
            ),
          ),
        );
      },
    );
  }
}

class TaskListSkeleton extends StatelessWidget {
  final int itemCount;

  const TaskListSkeleton({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  LoadingSkeleton(width: 20, height: 20, borderRadius: 4),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: LoadingSkeleton(width: double.infinity, height: 16),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const LoadingSkeleton(width: 200, height: 12),
              const SizedBox(height: 8),
              Row(
                children: [
                  LoadingSkeleton(width: 80, height: 24, borderRadius: 12),
                  const SizedBox(width: 8),
                  LoadingSkeleton(width: 60, height: 24, borderRadius: 12),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class CardSkeleton extends StatelessWidget {
  const CardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LoadingSkeleton(width: 120, height: 20),
          SizedBox(height: 12),
          LoadingSkeleton(width: double.infinity, height: 14),
          SizedBox(height: 8),
          LoadingSkeleton(width: 200, height: 14),
          SizedBox(height: 16),
          Row(
            children: [
              LoadingSkeleton(width: 100, height: 32, borderRadius: 16),
              SizedBox(width: 8),
              LoadingSkeleton(width: 80, height: 32, borderRadius: 16),
            ],
          ),
        ],
      ),
    );
  }
}

class GridSkeleton extends StatelessWidget {
  final int itemCount;

  const GridSkeleton({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return const CardSkeleton();
      },
    );
  }
}
