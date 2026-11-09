enum TaskPriority {
  urgent,
  high,
  medium,
  low;

  String get label {
    switch (this) {
      case TaskPriority.urgent:
        return 'Urgent';
      case TaskPriority.high:
        return 'High';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.low:
        return 'Low';
    }
  }
}

enum TaskStatus {
  pending,
  inProgress,
  completed;

  String get label {
    switch (this) {
      case TaskStatus.pending:
        return 'Pending';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.completed:
        return 'Completed';
    }
  }
}

class EmployeeTask {
  final String id;
  final String title;
  final String description;
  final String assignedTo;
  final String? assignedToId;
  final String assignedBy;
  final String dueDate;
  final TaskPriority priority;
  final TaskStatus status;
  final String category;
  final DateTime createdAt;

  const EmployeeTask({
    required this.id,
    required this.title,
    required this.description,
    required this.assignedTo,
    this.assignedToId,
    required this.assignedBy,
    required this.dueDate,
    required this.priority,
    this.status = TaskStatus.pending,
    this.category = 'General',
    required this.createdAt,
  });

  bool get isCompleted => status == TaskStatus.completed;

  EmployeeTask copyWith({
    String? id,
    String? title,
    String? description,
    String? assignedTo,
    String? assignedToId,
    String? assignedBy,
    String? dueDate,
    TaskPriority? priority,
    TaskStatus? status,
    String? category,
    DateTime? createdAt,
  }) {
    return EmployeeTask(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      assignedTo: assignedTo ?? this.assignedTo,
      assignedToId: assignedToId ?? this.assignedToId,
      assignedBy: assignedBy ?? this.assignedBy,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
