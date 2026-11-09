import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../backend/model/employee_task_model.dart';
import '../../../provider/task_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/task/task_card_widget.dart';


class PhmTasksScreen extends ConsumerStatefulWidget {
  const PhmTasksScreen({super.key});

  @override
  ConsumerState<PhmTasksScreen> createState() => _PhmTasksScreenState();
}

class _PhmTasksScreenState extends ConsumerState<PhmTasksScreen> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final allTasks = ref.watch(taskProvider);

    final filteredTasks = allTasks.where((t) {
      if (_selectedFilter == 'Pending' && t.status != TaskStatus.pending) return false;
      if (_selectedFilter == 'In Progress' && t.status != TaskStatus.inProgress) return false;
      if (_selectedFilter == 'Completed' && t.status != TaskStatus.completed) return false;
      if (_selectedFilter == 'Urgent' && t.priority != TaskPriority.urgent) return false;
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          'Pharmacist Tasks',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['All', 'Urgent', 'Pending', 'In Progress', 'Completed']
                        .map((filter) {
                      final isSelected = _selectedFilter == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(filter),
                          selected: isSelected,
                          selectedColor: AppColors.primary.withValues(alpha: 0.18),
                          side: BorderSide(
                            color: isSelected
                                ? AppColors.primary
                                : Colors.transparent,
                          ),
                          labelStyle: TextStyle(
                            color: isSelected
                                ? AppColors.primary
                                : theme.colorScheme.onSurface,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedFilter = filter;
                              });
                            }
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            if (filteredTasks.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.task_alt_rounded,
                        size: 56,
                        color: isDark
                            ? AppColors.darkTextTertiary
                            : AppColors.lightTextTertiary,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No Tasks Assigned',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final task = filteredTasks[index];
                      return TaskCardWidget(
                        task: task,
                        onToggleComplete: () {
                          ref
                              .read(taskProvider.notifier)
                              .toggleTaskCompletion(task.id);
                        },
                        onStatusChange: (status) {
                          ref
                              .read(taskProvider.notifier)
                              .updateTaskStatus(task.id, status);
                        },
                        onDelete: () {
                          ref.read(taskProvider.notifier).deleteTask(task.id);
                        },
                      );
                    },
                    childCount: filteredTasks.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
