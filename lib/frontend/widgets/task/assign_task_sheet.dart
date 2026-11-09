import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../backend/api_service.dart';
import '../../../backend/model/emp_return_model.dart';
import '../../../backend/model/employee_task_model.dart';
import '../../provider/shop_provider.dart';
import '../../provider/task_provider.dart';
import '../../theme/app_colors.dart';

void showAssignTaskBottomSheet(
  BuildContext context, {
  String? preselectedEmpName,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).cardColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => AssignTaskSheet(preselectedEmpName: preselectedEmpName),
  );
}

class AssignTaskSheet extends ConsumerStatefulWidget {
  const AssignTaskSheet({super.key, this.preselectedEmpName});

  final String? preselectedEmpName;

  @override
  ConsumerState<AssignTaskSheet> createState() => _AssignTaskSheetState();
}

class _AssignTaskSheetState extends ConsumerState<AssignTaskSheet> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  TaskPriority _selectedPriority = TaskPriority.medium;
  String _selectedCategory = 'Inventory';
  String _selectedDue = 'Today · End of Shift';
  String _selectedAssignee = 'All Staff';
  List<EmpBody> _employees = [];
  bool _isLoadingEmployees = false;

  final List<Map<String, String>> _templates = [
    {
      'title': 'Audit Rack Expiry Dates',
      'desc': 'Check batch expiry dates for syrups and liquids in Rack A & B',
      'category': 'Inventory',
    },
    {
      'title': 'Restock Front Counter Shelves',
      'desc': 'Refill fast-moving OTC drugs and strips at front counter',
      'category': 'Inventory',
    },
    {
      'title': 'POS Cash Drawer Reconciliation',
      'desc': 'Verify register transactions and total cash in register drawer',
      'category': 'Billing',
    },
    {
      'title': 'Clean Dispensary Counter',
      'desc': 'Sanitize medicine dispensing counter and arrange stock trays',
      'category': 'General',
    },
  ];

  @override
  void initState() {
    super.initState();
    if (widget.preselectedEmpName != null &&
        widget.preselectedEmpName!.isNotEmpty) {
      _selectedAssignee = widget.preselectedEmpName!;
    }
    _fetchEmployees();
  }

  Future<void> _fetchEmployees() async {
    final shop = ref.read(shopProvider).value;
    if (shop?.id == null) return;

    setState(() {
      _isLoadingEmployees = true;
    });

    try {
      final response = await ApiService().getAllEmployee(shopId: shop!.id!);
      if (response.data != null && response.data!.isNotEmpty) {
        if (!mounted) return;
        setState(() {
          _employees = response.data!;
        });
      }
    } catch (_) {} finally {
      if (mounted) {
        setState(() {
          _isLoadingEmployees = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _submitTask() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a task title')),
      );
      return;
    }

    final newTask = EmployeeTask(
      id: 'task_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      description: _descController.text.trim(),
      assignedTo: _selectedAssignee,
      assignedBy: 'Manager',
      dueDate: _selectedDue,
      priority: _selectedPriority,
      category: _selectedCategory,
      createdAt: DateTime.now(),
    );

    ref.read(taskProvider.notifier).addTask(newTask);

    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Task assigned to $_selectedAssignee'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final assigneeList = [
      'All Staff',
      if (widget.preselectedEmpName != null &&
          !['All Staff', ..._employees.map((e) => e.name)].contains(widget.preselectedEmpName))
        widget.preselectedEmpName!,
      ..._employees.map((e) => e.name),
    ];

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle Bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Header Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.add_task_rounded,
                        size: 20,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Create New Task',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Assign tasks to staff and monitor progress',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Templates
            Text('Quick Templates', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _templates.map((t) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ActionChip(
                      label: Text(t['title']!),
                      onPressed: () {
                        setState(() {
                          _titleController.text = t['title']!;
                          _descController.text = t['desc']!;
                          _selectedCategory = t['category']!;
                        });
                      },
                      backgroundColor: isDark
                          ? AppColors.darkSurfaceVariant
                          : AppColors.lightSurfaceVariant,
                      labelStyle: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // Assignee Dropdown
            Text('Assign To', style: theme.textTheme.titleSmall),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: assigneeList.contains(_selectedAssignee)
                      ? _selectedAssignee
                      : assigneeList.first,
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down_rounded),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedAssignee = val;
                      });
                    }
                  },
                  items: assigneeList.map((emp) {
                    return DropdownMenuItem<String>(
                      value: emp,
                      child: Text(emp),
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Task Title Input
            Text('Task Title', style: theme.textTheme.titleSmall),
            const SizedBox(height: 6),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'e.g. Audit rack expiry dates',
                prefixIcon: const Icon(Icons.edit_note_rounded),
                filled: true,
                fillColor: isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurfaceVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Instructions Input
            Text('Instructions / Details', style: theme.textTheme.titleSmall),
            const SizedBox(height: 6),
            TextField(
              controller: _descController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'Optional instructions for employee...',
                prefixIcon: const Icon(Icons.description_outlined),
                filled: true,
                fillColor: isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurfaceVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Category Selection
            Text('Category', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ['Inventory', 'Billing', 'Prescriptions', 'General'].map((cat) {
                final isSelected = _selectedCategory == cat;
                return ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  selectedColor: AppColors.primary.withValues(alpha: 0.18),
                  side: BorderSide(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                  ),
                  labelStyle: TextStyle(
                    color: isSelected ? AppColors.primary : theme.colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedCategory = cat;
                      });
                    }
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 14),

            // Priority Chips
            Text('Priority', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: TaskPriority.values.map((priority) {
                final isSelected = _selectedPriority == priority;
                final pColor = _getPriorityColor(priority, isDark);
                return ChoiceChip(
                  label: Text(priority.label),
                  selected: isSelected,
                  selectedColor: pColor.withValues(alpha: 0.18),
                  side: BorderSide(
                    color: isSelected ? pColor : Colors.transparent,
                  ),
                  labelStyle: TextStyle(
                    color: isSelected ? pColor : theme.colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedPriority = priority;
                      });
                    }
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 14),

            // Due Date
            Text('Due Time', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                'Today · End of Shift',
                'Within 2 Hours',
                'Tomorrow Morning',
              ].map((due) {
                final isSelected = _selectedDue == due;
                return ChoiceChip(
                  label: Text(due),
                  selected: isSelected,
                  selectedColor: AppColors.primary.withValues(alpha: 0.18),
                  side: BorderSide(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                  ),
                  labelStyle: TextStyle(
                    color: isSelected ? AppColors.primary : theme.colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedDue = due;
                      });
                    }
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _submitTask,
                icon: const Icon(Icons.add_task_rounded),
                label: const Text('Assign Task'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
