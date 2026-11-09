import 'package:flutter/material.dart';
import '../../../backend/model/employee_task_model.dart';
import '../../theme/app_colors.dart';

class TaskCardWidget extends StatelessWidget {
  const TaskCardWidget({
    super.key,
    required this.task,
    required this.onToggleComplete,
    required this.onStatusChange,
    required this.onDelete,
  });

  final EmployeeTask task;
  final VoidCallback onToggleComplete;
  final ValueChanged<TaskStatus> onStatusChange;
  final VoidCallback onDelete;

  Color _getPriorityColor(TaskPriority priority, bool isDark) {
    switch (priority) {
      case TaskPriority.urgent:
        return isDark ? AppColors.errorDark : AppColors.error;
      case TaskPriority.high:
        return isDark ? AppColors.warningDark : AppColors.warning;
      case TaskPriority.medium:
        return isDark ? AppColors.cashierBadgeForeground : AppColors.cashierForeground;
      case TaskPriority.low:
        return isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    }
  }

  Color _getPriorityBg(TaskPriority priority, bool isDark) {
    switch (priority) {
      case TaskPriority.urgent:
        return (isDark ? AppColors.errorDarkContainer : AppColors.errorLight)
            .withValues(alpha: isDark ? 0.8 : 0.7);
      case TaskPriority.high:
        return (isDark ? AppColors.warningDarkContainer : AppColors.warningLight)
            .withValues(alpha: isDark ? 0.8 : 0.7);
      case TaskPriority.medium:
        return (isDark ? AppColors.cashierBadgeBackground : AppColors.cashierBackground)
            .withValues(alpha: isDark ? 0.8 : 0.7);
      case TaskPriority.low:
        return isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurfaceVariant;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isCompleted = task.status == TaskStatus.completed;

    final pColor = _getPriorityColor(task.priority, isDark);
    final pBg = _getPriorityBg(task.priority, isDark);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isCompleted
            ? (isDark
                ? AppColors.darkSurface.withValues(alpha: 0.5)
                : AppColors.lightSurfaceVariant.withValues(alpha: 0.5))
            : theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCompleted
              ? Colors.transparent
              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Status Checkbox + Category & Priority Badges + Actions Menu
            Row(
              children: [
                // Checkbox toggle
                InkWell(
                  onTap: onToggleComplete,
                  borderRadius: BorderRadius.circular(8),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? AppColors.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(
                        color: isCompleted
                            ? AppColors.primary
                            : (isDark
                                ? AppColors.darkTextTertiary
                                : AppColors.lightTextTertiary),
                        width: 1.8,
                      ),
                    ),
                    child: isCompleted
                        ? const Icon(
                            Icons.check_rounded,
                            size: 16,
                            color: AppColors.white,
                          )
                        : null,
                  ),
                ),
                const SizedBox(width: 12),

                // Category Tag
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkSurfaceVariant
                        : AppColors.lightSurfaceVariant,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    task.category,
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // Priority Badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: pBg,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (task.priority == TaskPriority.urgent) ...[
                        Icon(
                          Icons.warning_amber_rounded,
                          size: 13,
                          color: pColor,
                        ),
                        const SizedBox(width: 3),
                      ],
                      Text(
                        task.priority.label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: pColor,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Status Dropdown / Action Menu
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert_rounded,
                    size: 20,
                    color: isDark
                        ? AppColors.darkTextTertiary
                        : AppColors.lightTextTertiary,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onSelected: (value) {
                    if (value == 'pending') {
                      onStatusChange(TaskStatus.pending);
                    } else if (value == 'inProgress') {
                      onStatusChange(TaskStatus.inProgress);
                    } else if (value == 'completed') {
                      onStatusChange(TaskStatus.completed);
                    } else if (value == 'delete') {
                      onDelete();
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'pending',
                      child: Row(
                        children: [
                          Icon(Icons.pending_actions, size: 18),
                          SizedBox(width: 8),
                          Text('Mark Pending'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'inProgress',
                      child: Row(
                        children: [
                          Icon(Icons.autorenew_rounded, size: 18),
                          SizedBox(width: 8),
                          Text('Mark In Progress'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'completed',
                      child: Row(
                        children: [
                          Icon(Icons.check_circle_outline, size: 18),
                          SizedBox(width: 8),
                          Text('Mark Completed'),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline_rounded,
                              size: 18, color: Colors.redAccent),
                          SizedBox(width: 8),
                          Text('Delete Task',
                              style: TextStyle(color: Colors.redAccent)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Title
            Text(
              task.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                decoration: isCompleted ? TextDecoration.lineThrough : null,
                color: isCompleted
                    ? (isDark
                        ? AppColors.darkTextTertiary
                        : AppColors.lightTextTertiary)
                    : (isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary),
              ),
            ),

            if (task.description.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                task.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                  height: 1.4,
                ),
              ),
            ],

            const SizedBox(height: 12),

            // Bottom Info: Due Date & Assignee
            Row(
              children: [
                // Due date
                Icon(
                  Icons.schedule_rounded,
                  size: 15,
                  color: isDark
                      ? AppColors.darkTextTertiary
                      : AppColors.lightTextTertiary,
                ),
                const SizedBox(width: 4),
                Text(
                  task.dueDate,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                const Spacer(),

                // Assigned To
                Icon(
                  Icons.person_outline_rounded,
                  size: 15,
                  color: isDark
                      ? AppColors.darkTextTertiary
                      : AppColors.lightTextTertiary,
                ),
                const SizedBox(width: 4),
                Text(
                  task.assignedTo,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
