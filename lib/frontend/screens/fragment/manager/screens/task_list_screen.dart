import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../backend/model/employee_task_model.dart';
import '../../../../provider/task_provider.dart';
import '../../../../theme/app_colors.dart';
import '../../../../widgets/task/assign_task_sheet.dart';
import '../../../../widgets/task/task_card_widget.dart';

class TaskListScreen extends ConsumerStatefulWidget {
  const TaskListScreen({super.key});

  @override
  ConsumerState<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends ConsumerState<TaskListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final allTasks = ref.watch(taskProvider);

    // Search query
    final query = _searchController.text.trim().toLowerCase();

    // Stats
    final totalCount = allTasks.length;
    final pendingCount = allTasks.where((t) => t.status == TaskStatus.pending).length;
    final completedCount = allTasks.where((t) => t.status == TaskStatus.completed).length;
    final urgentCount = allTasks.where((t) => t.priority == TaskPriority.urgent && t.status != TaskStatus.completed).length;

    // Filter tasks
    final filteredTasks = allTasks.where((t) {
      // Filter tab check
      if (_selectedFilter == 'Pending' && t.status != TaskStatus.pending) return false;
      if (_selectedFilter == 'In Progress' && t.status != TaskStatus.inProgress) return false;
      if (_selectedFilter == 'Completed' && t.status != TaskStatus.completed) return false;
      if (_selectedFilter == 'Urgent' && t.priority != TaskPriority.urgent) return false;

      // Search query check
      if (query.isNotEmpty) {
        final matchesTitle = t.title.toLowerCase().contains(query);
        final matchesDesc = t.description.toLowerCase().contains(query);
        final matchesAssignee = t.assignedTo.toLowerCase().contains(query);
        final matchesCategory = t.category.toLowerCase().contains(query);
        return matchesTitle || matchesDesc || matchesAssignee || matchesCategory;
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          'Task Management',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_task_rounded),
            tooltip: 'Assign Task',
            onPressed: () => showAssignTaskBottomSheet(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showAssignTaskBottomSheet(context),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        icon: const Icon(Icons.add_task_rounded),
        label: const Text('Assign Task'),
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Overview Stat Cards
                    Row(
                      children: [
                        _buildStatCard(
                          theme,
                          isDark,
                          label: 'Total',
                          count: '$totalCount',
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        _buildStatCard(
                          theme,
                          isDark,
                          label: 'Pending',
                          count: '$pendingCount',
                          color: isDark ? AppColors.warningDark : AppColors.warning,
                        ),
                        const SizedBox(width: 8),
                        _buildStatCard(
                          theme,
                          isDark,
                          label: 'Completed',
                          count: '$completedCount',
                          color: isDark ? AppColors.successDark : AppColors.success,
                        ),
                        const SizedBox(width: 8),
                        _buildStatCard(
                          theme,
                          isDark,
                          label: 'Urgent',
                          count: '$urgentCount',
                          color: isDark ? AppColors.errorDark : AppColors.error,
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Search Bar
                    TextField(
                      controller: _searchController,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: 'Search tasks, employees, category...',
                        prefixIcon: const Icon(Icons.search_rounded),
                        suffixIcon: query.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {});
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: isDark
                            ? AppColors.darkSurfaceVariant
                            : AppColors.lightSurfaceVariant,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Filter Chips
                    SingleChildScrollView(
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
                  ],
                ),
              ),
            ),

            // Task List or Empty View
            if (filteredTasks.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.task_outlined,
                        size: 64,
                        color: isDark
                            ? AppColors.darkTextTertiary
                            : AppColors.lightTextTertiary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No Tasks Found',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _selectedFilter == 'All' && query.isEmpty
                            ? 'No tasks assigned yet. Click "+ Assign Task" to create one.'
                            : 'No tasks match your filter criteria.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
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

  Widget _buildStatCard(
    ThemeData theme,
    bool isDark, {
    required String label,
    required String count,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        child: Column(
          children: [
            Text(
              count,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
