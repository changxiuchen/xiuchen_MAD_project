// ============================================
// PROJECT MODEL
// ============================================
class Project {
  final String id;
  final String name;
  final String description;
  final double progressPercentage;
  final int taskCount;
  final List<String> teamMembers;
  final String status; // "Active", "Completed", "On Hold"

  Project({
    required this.id,
    required this.name,
    required this.description,
    required this.progressPercentage,
    required this.taskCount,
    required this.teamMembers,
    required this.status,
  });

  // Create a copy of Project with modified fields
  Project copyWith({
    String? id,
    String? name,
    String? description,
    double? progressPercentage,
    int? taskCount,
    List<String>? teamMembers,
    String? status,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      progressPercentage: progressPercentage ?? this.progressPercentage,
      taskCount: taskCount ?? this.taskCount,
      teamMembers: teamMembers ?? this.teamMembers,
      status: status ?? this.status,
    );
  }
}
