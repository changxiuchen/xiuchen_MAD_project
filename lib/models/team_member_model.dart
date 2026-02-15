// ============================================
// TEAM MEMBER MODEL
// ============================================
class TeamMember {
  final String id;
  final String name;
  final String email;
  final String role;
  final String jobTitle;
  final int taskCount;
  final int completedTasks;
  final List<String> projectsAssigned;

  TeamMember({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.jobTitle,
    required this.taskCount,
    required this.completedTasks,
    required this.projectsAssigned,
  });

  // Create a copy of TeamMember with modified fields
  TeamMember copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? jobTitle,
    int? taskCount,
    int? completedTasks,
    List<String>? projectsAssigned,
  }) {
    return TeamMember(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      jobTitle: jobTitle ?? this.jobTitle,
      taskCount: taskCount ?? this.taskCount,
      completedTasks: completedTasks ?? this.completedTasks,
      projectsAssigned: projectsAssigned ?? this.projectsAssigned,
    );
  }
}
