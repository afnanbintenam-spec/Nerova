import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/task.dart';
import '../../providers/task_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/modern_back_button.dart';
import '../../widgets/styled_card.dart';
import '../../widgets/task_form_dialog.dart';
import '../../widgets/loading_skeleton.dart';
import '../../widgets/state_widgets.dart';

class PlannerScreen extends ConsumerWidget {
  const PlannerScreen({super.key});

  void _showTaskDialog(BuildContext context, {Task? task}) {
    showDialog(
      context: context,
      builder: (_) => TaskFormDialog(task: task),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskState = ref.watch(taskListProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      appBar: AppBar(
        leading: const ModernBackButton(),
        title: Text(
          'Planner',
          style: GoogleFonts.dmSans(fontWeight: FontWeight.w700),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.read(taskListProvider.notifier).loadTasks(),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(taskListProvider.notifier).loadTasks(),
        child: Padding(
          padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
          child: Column(
            children: [
              StyledCard(
                title: 'Plan your week',
                subtitle:
                    '${taskState.todayCount} tasks due · ${taskState.overdueCount} overdue',
                icon: Icons.calendar_today_rounded,
                iconBackgroundColor: AppColors.mint,
                gradientColors: const [Color(0xFFE8FFF9), Color(0xFFF2FFF9)],
                score: taskState.tasks.length.toString(),
                buttonLabel: 'Add Task',
                onButtonPressed: () => _showTaskDialog(context),
              ),
              const SizedBox(height: 16),
              _FilterRow(
                currentFilter: taskState.filter,
                onFilterChanged: (filter) {
                  ref.read(taskListProvider.notifier).setFilter(filter);
                },
                todayCount: taskState.todayCount,
                overdueCount: taskState.overdueCount,
                upcomingCount: taskState.upcomingCount,
              ),
              const SizedBox(height: 16),

              // Task list
              if (taskState.isLoading)
                const Expanded(child: TaskListSkeleton())
              else if (taskState.error != null)
                Expanded(
                  child: ErrorState(
                    title: 'Failed to load tasks',
                    message: taskState.error,
                    onRetry: () =>
                        ref.read(taskListProvider.notifier).loadTasks(),
                  ),
                )
              else if (taskState.filteredTasks.isEmpty)
                Expanded(
                  child: EmptyState(
                    title: taskState.filter == 'all'
                        ? 'No tasks yet'
                        : 'No ${taskState.filter} tasks',
                    message: taskState.filter == 'all'
                        ? 'Create your first task to get started.'
                        : 'Try changing your filter to see other tasks.',
                    onAction: taskState.filter == 'all'
                        ? () => _showTaskDialog(context)
                        : null,
                    actionLabel: 'Add Task',
                    icon: Icons.task_alt_rounded,
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: taskState.filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = taskState.filteredTasks[index];
                      return _TaskCard(
                        task: task,
                        onTap: () => _showTaskDialog(context, task: task),
                        onToggle: () => ref
                            .read(taskListProvider.notifier)
                            .toggleTask(task.id),
                        onDelete: () => ref
                            .read(taskListProvider.notifier)
                            .deleteTask(task.id),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showTaskDialog(context),
        backgroundColor: AppColors.electric,
        icon: const Icon(Icons.add_rounded),
        label: Text(
          'Add Task',
          style: GoogleFonts.dmSans(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  final String currentFilter;
  final Function(String) onFilterChanged;
  final int todayCount;
  final int overdueCount;
  final int upcomingCount;

  const _FilterRow({
    required this.currentFilter,
    required this.onFilterChanged,
    required this.todayCount,
    required this.overdueCount,
    required this.upcomingCount,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _FilterChip(
            label: 'All',
            selected: currentFilter == 'all',
            onTap: () => onFilterChanged('all'),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Today',
            count: todayCount,
            selected: currentFilter == 'today',
            onTap: () => onFilterChanged('today'),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Overdue',
            count: overdueCount,
            selected: currentFilter == 'overdue',
            onTap: () => onFilterChanged('overdue'),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Upcoming',
            count: upcomingCount,
            selected: currentFilter == 'upcoming',
            onTap: () => onFilterChanged('upcoming'),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Completed',
            selected: currentFilter == 'completed',
            onTap: () => onFilterChanged('completed'),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.count,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final int? count;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.electric : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? AppColors.electric : AppColors.line,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.dmSans(
                fontSize: 13,
                color: selected ? Colors.white : AppColors.navy,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (count != null && count! > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: selected
                      ? Colors.white.withValues(alpha: 0.3)
                      : AppColors.electric.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  count.toString(),
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    color: selected ? Colors.white : AppColors.electric,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({
    required this.task,
    required this.onTap,
    required this.onToggle,
    required this.onDelete,
  });

  final Task task;
  final VoidCallback onTap;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.rose,
          borderRadius: BorderRadius.circular(18),
        ),
        alignment: Alignment.centerRight,
        child: const Icon(Icons.delete_rounded, color: Colors.white, size: 28),
      ),
      onDismissed: (_) => onDelete(),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: task.isOverdue
                ? Border.all(color: AppColors.rose, width: 2)
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Checkbox
              InkWell(
                onTap: onToggle,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: task.isCompleted
                        ? AppColors.mint
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: task.isCompleted
                          ? AppColors.mint
                          : AppColors.navy.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: task.isCompleted
                      ? const Icon(
                          Icons.check_rounded,
                          size: 16,
                          color: Colors.white,
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 12),

              // Task details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            task.title,
                            style: GoogleFonts.dmSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: task.isCompleted
                                  ? AppColors.navy.withValues(alpha: 0.4)
                                  : AppColors.ink,
                              decoration: task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                        ),
                        _PriorityBadge(priority: task.priority),
                      ],
                    ),
                    if (task.course != null) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.school_rounded,
                            size: 14,
                            color: AppColors.navy.withValues(alpha: 0.5),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            task.course!,
                            style: GoogleFonts.dmSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.navy.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (task.dueDate != null) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            task.isOverdue
                                ? Icons.warning_rounded
                                : Icons.access_time_rounded,
                            size: 14,
                            color: task.isOverdue
                                ? AppColors.rose
                                : AppColors.navy.withValues(alpha: 0.5),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            task.formattedDueDate,
                            style: GoogleFonts.dmSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: task.isOverdue
                                  ? AppColors.rose
                                  : AppColors.navy.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (task.description != null &&
                        task.description!.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        task.description!,
                        style: GoogleFonts.dmSans(
                          fontSize: 12,
                          color: AppColors.navy.withValues(alpha: 0.5),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PriorityBadge extends StatelessWidget {
  const _PriorityBadge({required this.priority});

  final String priority;

  @override
  Widget build(BuildContext context) {
    final color = switch (priority) {
      'High' => AppColors.rose,
      'Medium' => AppColors.amber,
      _ => AppColors.mint,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        priority,
        style: GoogleFonts.dmSans(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
