import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../backend/model/employee_task_model.dart';
import '../../../../../provider/task_provider.dart';
import '../../../../../theme/app_colors.dart';
import '../../screens/task_list_screen.dart';

class NextTaskWidget extends ConsumerWidget {
  const NextTaskWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final tasks = ref.watch(taskProvider);

    final activeTasks = tasks.where((t) => t.status != TaskStatus.completed).toList();
    activeTasks.sort((a, b) => a.priority.index.compareTo(b.priority.index));

    final nextTask = activeTasks.isNotEmpty ? activeTasks.first : null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  'Next task',
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (nextTask != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: nextTask.priority == TaskPriority.urgent
                        ? AppColors.errorDarkContainer.withValues(alpha: isDark ? 1 : 0.7)
                        : (isDark ? AppColors.warningDarkContainer : AppColors.warningLight),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        nextTask.priority == TaskPriority.urgent
                            ? Icons.warning_amber_rounded
                            : Icons.priority_high_rounded,
                        size: 14,
                        color: nextTask.priority == TaskPriority.urgent
                            ? AppColors.errorDark
                            : (isDark ? AppColors.warningDark : AppColors.warning),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        nextTask.priority.label,
                        style: TextStyle(
                          color: nextTask.priority == TaskPriority.urgent
                              ? AppColors.errorDark
                              : (isDark ? AppColors.warningDark : AppColors.warning),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                )
            ],
          ),

          const SizedBox(height: 8),

          Text(
            nextTask?.title ?? 'All tasks completed!',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.w700,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            nextTask != null
                ? '${nextTask.dueDate} · Assigned to ${nextTask.assignedTo}'
                : 'Great job! No pending tasks remaining.',
            style: theme.textTheme.bodyMedium!.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const TaskListScreen()),
              );
            },
            borderRadius: BorderRadius.circular(8),
            child: Text(
              'Open task section →',
              style: theme.textTheme.titleMedium!.copyWith(
                color: AppColors.primaryLight,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
