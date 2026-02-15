import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../data/shared_projects.dart';
import '../../widgets/custom_header.dart';
import '../../widgets/progress_bar_widget.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/card_container.dart';
import '../projects/project_details_screen.dart';
import 'add_project_screen.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button
            CustomHeader(
              title: 'Projects',
              subtitle: '${sharedProjects.length} projects',
              showBackButton: true,
            ),

            const SizedBox(height: AppDimensions.paddingLarge),
            
            // Projects list
            Expanded(
              child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingLarge,
                      ),
                      itemCount: sharedProjects.length,
                      itemBuilder: (context, index) {
                        final project = sharedProjects[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: CardContainer(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProjectDetailsScreen(project: project),
                                ),
                              );
                              setState(() {});
                            },
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Project name and status
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          project.name,
                                          style: AppTextStyles.heading3,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const StatusBadge(status: 'Active'),
                                    ],
                                  ),

                                  const SizedBox(height: 8),

                                  // Description
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

                                  // Tasks and team info
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.task_outlined,
                                        size: 16,
                                        color: AppColors.secondaryTeal,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        '${project.taskCount} tasks',
                                        style: AppTextStyles.caption,
                                      ),
                                      const SizedBox(width: 16),
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
                          );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProjectScreen()),
          );
          // Refresh list
          setState(() {});
        },
        backgroundColor: AppColors.primaryNavy,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
