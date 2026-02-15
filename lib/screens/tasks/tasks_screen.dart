import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../models/task_model.dart';
import '../../data/shared_tasks.dart';
import '../../widgets/custom_header.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/priority_badge.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/card_container.dart';
import 'task_details_screen.dart'; 
import 'add_task_screen.dart'; 

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {

  String selectedStatus = 'All';
  
  // Get filtered tasks
  List<Task> getFilteredTasks() {
    List<Task> filtered = [];
    for (int i = 0; i < sharedTasks.length; i++) {
       final task = sharedTasks[i];
       bool matchesStatus = selectedStatus == 'All' || task.status == selectedStatus;
       if (matchesStatus) {
         filtered.add(task);
       }
    }
    return filtered;
  }

  // Helper function to get priority color (needed for priority indicator bar)
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
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks = getFilteredTasks();

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button
            CustomHeader(
              title: 'Tasks',
              subtitle: '${sharedTasks.length} total tasks',
              showBackButton: true,
            ),

            const SizedBox(height: AppDimensions.paddingLarge),
            const SizedBox(height: AppDimensions.paddingMedium),

            // Filter chips
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingLarge,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    // Status filter
                    Wrap(
                      spacing: 8,
                      children: ['All', 'To-Do', 'In Progress', 'Done']
                          .map((status) {
                        return FilterChip(
                          label: Text(status),
                          selected: selectedStatus == status,
                          onSelected: (selected) {
                            setState(() {
                              selectedStatus = status;
                            });
                          },
                          backgroundColor: AppColors.backgroundGrey,
                          selectedColor: AppColors.secondaryTeal,
                          labelStyle: TextStyle(
                            color: selectedStatus == status
                                ? Colors.white
                                : AppColors.textGrey,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(width: 16),

                  ],
                ),
              ),
            ),

            const SizedBox(height: AppDimensions.paddingMedium),

            // Tasks list
            Expanded(
              child: filteredTasks.isEmpty
                  ? const EmptyStateWidget(
                      icon: Icons.task_outlined,
                      title: 'No tasks found',
                      subtitle: 'Try adjusting your filters',
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingLarge,
                      ),
                      itemCount: filteredTasks.length,
                      itemBuilder: (context, index) {
                        final task = filteredTasks[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Hero(
                            tag: 'task_${task.id}',
                            child: Material(
                              color: Colors.transparent,
                              child: GestureDetector(
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          TaskDetailsScreen(task: task),
                                    ),
                                  );
                                  
                                  setState(() {});
                                },

                                child: CardContainer(
                                  child: Row(
                                    children: [
                                      // Priority indicator
                                      Container(
                                        width: 4,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          color: _getPriorityColor(task.priority),
                                          borderRadius: BorderRadius.circular(2),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      // Task info
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
                                            Text(
                                              task.description,
                                              style: AppTextStyles.caption,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 8),
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
                                      StatusBadge(
                                        status: task.status,
                                        onTap: () {
                                          setState(() {
                                            // Cycle through statuses
                                            if (task.status == 'To-Do') {
                                              task.status = 'In Progress';
                                            } else if (task.status == 'In Progress') {
                                              task.status = 'Done';
                                            } else {
                                              task.status = 'To-Do';
                                            }
                                          });
                                          // Show feedback
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Status updated to ${task.status}'),
                                              backgroundColor: AppColors.secondaryTeal,
                                              duration: const Duration(seconds: 1),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskScreen()),
          );
          setState(() {});
        },
        backgroundColor: AppColors.primaryNavy,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
