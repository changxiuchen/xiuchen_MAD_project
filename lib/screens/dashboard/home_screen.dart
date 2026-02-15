import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../models/project_model.dart';
import '../../models/task_model.dart';
import '../../data/shared_tasks.dart';
import '../../data/shared_projects.dart';
import '../../data/shared_users.dart';
import '../../data/data_helpers.dart';
import '../../widgets/custom_header.dart';
import '../../widgets/progress_bar_widget.dart';
import '../../widgets/priority_badge.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/card_container.dart';
import '../projects/projects_screen.dart';
import '../tasks/tasks_screen.dart';
import '../projects/project_details_screen.dart';
import '../tasks/task_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String get userName => currentUser?.name ?? 'Guest';

  @override
  void initState() {
    super.initState();
    // Update all project metrics when screen loads
    DataHelpers.updateAllProjectMetrics();
  }

  // Get projects from shared data
  List<Project> get projects {
    return sharedProjects;
  }

  // Use first 3 tasks from shared list
  List<Task> get recentTasks => sharedTasks.take(3).toList();



  // Helper function to get priority color
  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return AppColors.highPriority;
      case 'Medium':
        return AppColors.mediumPriority;
      case 'Low':
        return AppColors.lowPriority;
      default:
        return AppColors.textGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Header
            CustomHeader(
              title: userName.isEmpty ? 'Welcome!' : 'Hello, $userName!',
              subtitle: 'Here\'s your project overview',
              trailing: CircleAvatar(
                backgroundColor: AppColors.secondaryTeal.withOpacity(0.2),
                radius: 25,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'assets/logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

              const SizedBox(height: AppDimensions.paddingLarge),

              // Quick Stats
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingLarge,
                ),
                child: Container(
                  padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceWhite,
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusMedium,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatCard('${sharedProjects.length}', 'Projects'),
                      Container(
                        width: 1,
                        height: 40,
                        color: AppColors.backgroundGrey,
                      ),
                      _buildStatCard('${sharedTasks.length}', 'Tasks'),

                    ],
                  ),
                ),
              ),


              const SizedBox(height: AppDimensions.paddingLarge),

              // Active Projects Section
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingLarge,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Active Projects',
                          style: AppTextStyles.heading2,
                        ),
                        GestureDetector(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProjectsScreen(),
                              ),
                            );
                            // Refresh when coming back
                            setState(() {
                              DataHelpers.updateAllProjectMetrics();
                            });
                          },
                          child: const Text(
                            'View All',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.secondaryTeal,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Horizontal scrolling projects
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: projects.length,
                        itemBuilder: (context, index) {
                          final project = projects[index];
                          return SizedBox(
                            width: 280,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 12),
                                child: CardContainer(
                                  onTap: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProjectDetailsScreen(project: project),
                                      ),
                                    );
                                    // Refresh when coming back
                                    setState(() {
                                      DataHelpers.updateAllProjectMetrics();
                                    });
                                  },
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        project.name,
                                        style: AppTextStyles.heading3,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        project.description,
                                        style: AppTextStyles.bodyRegular,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 12),
                                      // Progress bar
                                      ProgressBarWidget(
                                        percentage: project.progressPercentage,
                                      ),
                                      const SizedBox(height: 12),
                                      // Team members
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.people_outline,
                                            size: 16,
                                            color: AppColors.secondaryTeal,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            '${project.teamMembers.length} members',
                                            style: AppTextStyles.caption,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppDimensions.paddingLarge),

              // Recent Tasks Section
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingLarge,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Recent Tasks',
                          style: AppTextStyles.heading2,
                        ),
                        GestureDetector(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const TasksScreen(),
                              ),
                            );
                            // Refresh when coming back  
                            setState(() {
                              DataHelpers.updateAllProjectMetrics();
                            });
                          },
                          child: const Text(
                            'View All',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.secondaryTeal,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Tasks list
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: recentTasks.length,
                      itemBuilder: (context, index) {
                        final task = recentTasks[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: CardContainer(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TaskDetailsScreen(task: task),
                                ),
                              );
                              // Refresh screen when coming back
                              setState(() {});
                            },
                            child: Row(
                                children: [
                                  Container(
                                    width: 4,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: _getPriorityColor(task.priority),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          task.title,
                                          style: AppTextStyles.bodyLarge,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          PriorityBadge(priority: task.priority),
                                          const SizedBox(width: 8),
                                          Text(
                                            task.assignedTo,
                                            style: AppTextStyles.caption,
                                          ),
                                        ],
                                      ),
                                      ],
                                    ),
                                  ),
                                 // Status badge
                                StatusBadge(status: task.status),
                                ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppDimensions.paddingLarge),
            ],
          ),
        ),
      ),
      floatingActionButton: null,
    );
  }

  // Helper widget for stat cards
  Widget _buildStatCard(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryNavy,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textGrey,
          ),
        ),
      ],
    );
  }
}
