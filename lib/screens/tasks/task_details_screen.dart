import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../models/task_model.dart';
import '../../data/data_helpers.dart';
import 'add_task_screen.dart';

class TaskDetailsScreen extends StatefulWidget {
  final Task task;

  const TaskDetailsScreen({
    super.key,
    required this.task,
  });

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  late String currentStatus;

  @override
  void initState() {
    super.initState();
    currentStatus = widget.task.status;
  }

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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Done':
        return AppColors.successGreen;
      case 'In Progress':
        return AppColors.warningAmber;
      case 'To-Do':
        return AppColors.textLight;
      default:
        return AppColors.textGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        backgroundColor: AppColors.primaryNavy,
        title: const Text('Task Details'),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Task header
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.primaryNavy,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(AppDimensions.borderRadiusLarge),
                    bottomRight: Radius.circular(AppDimensions.borderRadiusLarge),
                  ),
                ),
                padding: const EdgeInsets.all(AppDimensions.paddingLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.task.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.task.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppDimensions.paddingLarge),

              // Task details card
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingLarge,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceWhite,
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusMedium,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(AppDimensions.paddingLarge),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Task Information',
                        style: AppTextStyles.heading2,
                      ),
                      const SizedBox(height: 16),

                      // Priority
                      _buildDetailField(
                        icon: Icons.flag_outlined,
                        label: 'Priority',
                        value: widget.task.priority,
                        valueColor: _getPriorityColor(widget.task.priority),
                      ),

                      const SizedBox(height: 16),

                      // Status
                      _buildDetailField(
                        icon: Icons.check_circle_outline,
                        label: 'Status',
                        value: currentStatus,
                        valueColor: _getStatusColor(currentStatus),
                      ),

                      const SizedBox(height: 16),

                      // Assigned to
                      _buildDetailField(
                        icon: Icons.person_outline,
                        label: 'Assigned To',
                        value: widget.task.assignedTo,
                      ),

                      const SizedBox(height: 16),

                      // Deadline
                      _buildDetailField(
                        icon: Icons.calendar_today_outlined,
                        label: 'Deadline',
                        value:
                            '${widget.task.deadline.day}/${widget.task.deadline.month}/${widget.task.deadline.year}',
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppDimensions.paddingLarge),

              // Update status section
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingLarge,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Update Status',
                      style: AppTextStyles.heading2,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.surfaceWhite,
                        borderRadius: BorderRadius.circular(
                          AppDimensions.borderRadiusMedium,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                      child: DropdownButton<String>(
                        value: currentStatus,
                        isExpanded: true,
                        underline: const SizedBox(),
                        items: ['To-Do', 'In Progress', 'Done']
                            .map((status) => DropdownMenuItem(
                                  value: status,
                                  child: Text(status),
                                ))
                            .toList(),
                        onChanged: (newStatus) {
                          if (newStatus != null) {
                            setState(() {
                              currentStatus = newStatus;
                              widget.task.status = newStatus; // Update the actual task object
                              // Update project metrics to reflect task status change
                              DataHelpers.updateAllProjectMetrics();
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Task status updated to $newStatus',
                                ),
                                backgroundColor: AppColors.successGreen,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppDimensions.paddingLarge),

              // Action buttons
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingLarge,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: OutlinedButton(
                          onPressed: () async {
                              await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddTaskScreen(
                                  taskToEdit: widget.task,
                                ),
                              ),
                            );
                            setState(() {
                              currentStatus = widget.task.status; // Update status if changed in edit screen
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: AppColors.secondaryTeal,
                              width: 2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppDimensions.borderRadiusLarge,
                              ),
                            ),
                          ),
                          child: const Text(
                            'Edit',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.secondaryTeal,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Delete Task'),
                                content: const Text(
                                  'Are you sure you want to delete this task?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      DataHelpers.deleteTask(widget.task.id);
                                      // Update project metrics after deleting a task
                                      DataHelpers.updateAllProjectMetrics();

                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Task deleted successfully',
                                          ),
                                          backgroundColor:
                                              AppColors.successGreen,
                                        ),
                                      );
                                    },
                                    child: const Text('Delete', style: TextStyle(color: AppColors.errorRed)),
                                  ),
                                ],
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.errorRed,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppDimensions.borderRadiusLarge,
                              ),
                            ),
                          ),
                          child: const Text(
                            'Delete',
                            style: AppTextStyles.buttonText,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppDimensions.paddingLarge),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailField({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.secondaryTeal,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textGrey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? AppColors.primaryNavy,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
