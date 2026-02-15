// ============================================
// TASK MODEL
// ============================================
class Task {
  final String id;
  final String title;
  final String description;
  final String priority; // "Low", "Medium", "High"
   String status; // "To-Do", "In Progress", "Done"
  final String assignedTo;
  final String projectId;
  final DateTime deadline;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.assignedTo,
    required this.projectId,
    required this.deadline,
  });

  // Create a copy of Task with modified fields
  Task copyWith({
    String? id,
    String? title,
    String? description,
    String? priority,
    String? status,
    String? assignedTo,
    String? projectId,
    DateTime? deadline,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      assignedTo: assignedTo ?? this.assignedTo,
      projectId: projectId ?? this.projectId,
      deadline: deadline ?? this.deadline,
    );
  }
}
