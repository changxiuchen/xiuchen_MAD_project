import 'package:flutter/material.dart';
import '../../models/task_model.dart';
import '../../data/data_helpers.dart';
import '../../data/shared_projects.dart';
import '../../data/shared_team_members.dart';
import '../../constants/app_constants.dart';

class AddTaskScreen extends StatefulWidget {
  final Task? taskToEdit;
  final String? initialProjectId;

  const AddTaskScreen({super.key, this.taskToEdit, this.initialProjectId});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  // Controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  
  

  // Button enable state
  bool _btnEnable = false;

  // Selections
  String _priority = 'Medium';
  String _status = 'To-Do';
  String? _selectedProjectId;
  String? _assignedToName;
  DateTime _startdate = DateTime.now();
  DateTime _deadline = DateTime.now().add(const Duration(days: 7));

  @override
  void initState() {
    super.initState();

    // Add listeners to enable/disable button based on text input
    _titleController.addListener(_updateButtonState);
    _descController.addListener(_updateButtonState);

    // If editing, populate
    if (widget.taskToEdit != null) {
      _titleController.text = widget.taskToEdit!.title;
      _descController.text = widget.taskToEdit!.description;
      _priority = widget.taskToEdit!.priority;
      _status = widget.taskToEdit!.status;
      _selectedProjectId = widget.taskToEdit!.projectId;
      _assignedToName = widget.taskToEdit!.assignedTo;
      _deadline = widget.taskToEdit!.deadline;
    } else if (widget.initialProjectId != null) {
      _selectedProjectId = widget.initialProjectId;
    }
  }

  void _updateButtonState() {
    setState(() {
      _btnEnable = _titleController.text.isNotEmpty &&
          _descController.text.isNotEmpty &&
          _selectedProjectId != null &&
          _assignedToName != null;
    });
  }

  // Create unique ID
  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  // Date Picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _deadline,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _deadline) {
      setState(() {
        _deadline = picked;
      });
    }
  }

  
  void _onAddTaskBtnPressed() {
    // 1. Validate required fields
    if (_titleController.text.isEmpty || _descController.text.isEmpty) {
      return;
    }
    if (_selectedProjectId == null || _assignedToName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select project and assignee')),
      );
      return;
    }

    // 2. Handle Logic
    if (widget.taskToEdit != null) {
      // --- EDIT MODE ---
      Task updatedTask = widget.taskToEdit!.copyWith(
        title: _titleController.text,
        description: _descController.text,
        priority: _priority,
        status: _status,
        assignedTo: _assignedToName,
        projectId: _selectedProjectId,
        deadline: _deadline,
      );
      DataHelpers.editTask(updatedTask);

      // Update metrics
      var project = DataHelpers.getProjectById(_selectedProjectId!);
      if (project != null) {
        DataHelpers.updateProjectMetrics(project);
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task Updated Successfully!'),
         backgroundColor: AppColors.successGreen,
         ),
       
      );

    } else {
      // --- ADD MODE ---
      Task newTask = Task(
        id: _generateId(),
        title: _titleController.text,
        description: _descController.text,
        priority: _priority,
        status: _status,
        assignedTo: _assignedToName!,
        projectId: _selectedProjectId!,
        deadline: _deadline,
      );
      
      // Add to global data
      DataHelpers.addNewTask(newTask);

      // Update metrics
      var project = DataHelpers.getProjectById(_selectedProjectId!);
      if (project != null) {
        DataHelpers.updateProjectMetrics(project);
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task Added Successfully!'),
         backgroundColor: AppColors.successGreen,
         ),
      );
    }

    
    Navigator.pop(context);
  }

  // Clear method
  void _onClearBtnPressed() {
    setState(() {
      _titleController.clear();
      _descController.clear();
      _priority = 'Medium';
      _status = 'To-Do';
      _selectedProjectId = widget.initialProjectId;
      _assignedToName = null;
      _deadline = DateTime.now().add(const Duration(days: 7));
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        title: Text(widget.taskToEdit == null ? 'Add Task' : 'Edit Task'),
        backgroundColor: AppColors.primaryNavy,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.paddingLarge),
        children: [
          // TITLE TextField
          TextField(
            decoration: const InputDecoration(
              filled: true,
              fillColor: AppColors.surfaceWhite,
              hintText: 'enter task title',
              labelText: 'Task Title',
              border: OutlineInputBorder(),
            ),
            controller: _titleController,
          ),
          const SizedBox(height: AppDimensions.paddingMedium),

          // DESCRIPTION TextField
          TextField(
            decoration: const InputDecoration(
              filled: true,
              fillColor: AppColors.surfaceWhite,
              hintText: 'enter description',
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
            controller: _descController,
            maxLines: 3,
          ),
          const SizedBox(height: AppDimensions.paddingMedium),

          // PRIORITY DROPDOWN
          DropdownButtonFormField<String>(
            value: _priority,
            decoration: const InputDecoration(
              labelText: 'Priority',
              filled: true,
              fillColor: AppColors.surfaceWhite,
              border: OutlineInputBorder(),
            ),
            items: ['High', 'Medium', 'Low']
                .map((val) => DropdownMenuItem(
                      value: val,
                      child: Text(val),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _priority = value!;
              });
            },
          ),
          const SizedBox(height: AppDimensions.paddingMedium),

          // STATUS DROPDOWN
          DropdownButtonFormField<String>(
            value: _status,
            decoration: const InputDecoration(
              labelText: 'Status',
              filled: true,
              fillColor: AppColors.surfaceWhite,
              border: OutlineInputBorder(),
            ),
            items: ['To-Do', 'In Progress', 'Done']
                .map((val) => DropdownMenuItem(
                      value: val,
                      child: Text(val),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _status = value!;
              });
            },
          ),
          const SizedBox(height: AppDimensions.paddingMedium),

          // ASSIGNED TO DROPDOWN
          DropdownButtonFormField<String>(
            value: _assignedToName,
            decoration: const InputDecoration(
              labelText: 'Assign To',
              filled: true,
              fillColor: AppColors.surfaceWhite,
              border: OutlineInputBorder(),
            ),
            hint: const Text('Select Team Member'),
            items: sharedTeamMembers.map((member) {
              return DropdownMenuItem(
                value: member.name,
                child: Text(member.name),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _assignedToName = value;
                _updateButtonState();
              });
            },
          ),
          const SizedBox(height: AppDimensions.paddingMedium),

          // PROJECT DROPDOWN
          DropdownButtonFormField<String>(
            value: _selectedProjectId,
            decoration: const InputDecoration(
              labelText: 'Project',
              filled: true,
              fillColor: AppColors.surfaceWhite,
              border: OutlineInputBorder(),
            ),
            hint: const Text('Select Project'),
            items: sharedProjects.map((project) {
              return DropdownMenuItem(
                value: project.id,
                child: Text(project.name),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedProjectId = value;
                _updateButtonState();
              });
            },
          ),
          
          const SizedBox(height: AppDimensions.paddingMedium),

          //Start Date
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceWhite,
              border: Border.all(color: AppColors.textLight),
              borderRadius:
                  BorderRadius.circular(AppDimensions.borderRadiusMedium),
            ),
            child: ListTile(
              title: Text(
                'Start Date',
                style: AppTextStyles.bodyLarge,
              ),
              subtitle: Text(
                "${_startdate.toLocal()}".split(' ')[0],
                style: AppTextStyles.bodyRegular,
              ),
              trailing: const Icon(
                Icons.calendar_today,
                color: AppColors.primaryNavy,
              ),
              onTap: () => _selectDate(context),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingMedium),

          // DEADLINE PICKER
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceWhite,
              border: Border.all(color: AppColors.textLight),
              borderRadius:
                  BorderRadius.circular(AppDimensions.borderRadiusMedium),
            ),
            child: ListTile(
              title: Text(
                'Deadline',
                style: AppTextStyles.bodyLarge,
              ),
              subtitle: Text(
                "${_deadline.toLocal()}".split(' ')[0],
                style: AppTextStyles.bodyRegular,
              ),
              trailing: const Icon(
                Icons.calendar_today,
                color: AppColors.primaryNavy,
              ),
              onTap: () => _selectDate(context),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingLarge),

          // Buttons Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Clear Button
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.only(right: AppDimensions.paddingSmall),
                  child: ElevatedButton(
                    onPressed: _titleController.text.isEmpty
                        ? null
                        : _onClearBtnPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryNavy,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: AppDimensions.paddingMedium),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            AppDimensions.borderRadiusMedium),
                      ),
                    ),
                    child: const Text('Clear'),
                  ),
                ),
              ),

              // Add/Update Task Button
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: AppDimensions.paddingSmall),
                  child: ElevatedButton(
                    onPressed: _btnEnable ? _onAddTaskBtnPressed : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryNavy,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: AppDimensions.paddingMedium),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            AppDimensions.borderRadiusMedium),
                      ),
                    ),
                    child: Text(widget.taskToEdit == null
                        ? 'Add Task'
                        : 'Update Task'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}