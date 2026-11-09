import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../backend/model/employee_task_model.dart';

final taskProvider = StateNotifierProvider<TaskNotifier, List<EmployeeTask>>((ref) {
  return TaskNotifier();
});

class TaskNotifier extends StateNotifier<List<EmployeeTask>> {
  TaskNotifier() : super(_initialTasks);

  static final List<EmployeeTask> _initialTasks = [
    EmployeeTask(
      id: 'task_1',
      title: 'Audit Rack Expiry Dates',
      description: 'Check batch expiry dates for syrups and liquid bottles in Rack A & B.',
      assignedTo: 'John Doe',
      assignedBy: 'Manager',
      dueDate: 'Today · End of Shift',
      priority: TaskPriority.urgent,
      status: TaskStatus.pending,
      category: 'Inventory',
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    EmployeeTask(
      id: 'task_2',
      title: 'Review Afternoon Refund Queue',
      description: 'Verify POS return transactions and total cash drawer refunds.',
      assignedTo: 'Manager',
      assignedBy: 'Owner',
      dueDate: 'Today · End of Shift',
      priority: TaskPriority.urgent,
      status: TaskStatus.pending,
      category: 'Billing',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    EmployeeTask(
      id: 'task_3',
      title: 'Restock Front Counter OTC Shelves',
      description: 'Refill fast-moving OTC drugs and strips at front counter displays.',
      assignedTo: 'Sarah Smith',
      assignedBy: 'Manager',
      dueDate: 'Within 2 Hours',
      priority: TaskPriority.high,
      status: TaskStatus.inProgress,
      category: 'Inventory',
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    EmployeeTask(
      id: 'task_4',
      title: 'Clean & Sanitize Dispensing Counter',
      description: 'Sanitize medicine dispensing counter and organize daily stock trays.',
      assignedTo: 'Alex Johnson',
      assignedBy: 'Manager',
      dueDate: 'Tomorrow Morning',
      priority: TaskPriority.medium,
      status: TaskStatus.completed,
      category: 'General',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
  ];

  void addTask(EmployeeTask task) {
    state = [task, ...state];
  }

  void updateTaskStatus(String taskId, TaskStatus status) {
    state = [
      for (final task in state)
        if (task.id == taskId) task.copyWith(status: status) else task,
    ];
  }

  void toggleTaskCompletion(String taskId) {
    state = [
      for (final task in state)
        if (task.id == taskId)
          task.copyWith(
            status: task.status == TaskStatus.completed
                ? TaskStatus.pending
                : TaskStatus.completed,
          )
        else
          task,
    ];
  }

  void deleteTask(String taskId) {
    state = state.where((task) => task.id != taskId).toList();
  }
}
