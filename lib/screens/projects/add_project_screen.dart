import 'package:flutter/material.dart';
import '../../models/project_model.dart';
import '../../data/data_helpers.dart';
import '../../constants/app_constants.dart';
import '../../data/shared_team_members.dart';

class AddProjectScreen extends StatefulWidget {
  const AddProjectScreen({super.key});

  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  // Controllers following lab pattern
  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  
  // Button enable state
  bool _btnEnable = false;
  
  // Status selection
  String _status = 'Active';
  
  // Team member selection
  List<String> _selectedMembers = [];

  @override
  void initState() {
    super.initState();
    // Add listener to enable/disable button based on text input
    _projectNameController.addListener(() {
      setState(() {
        _btnEnable = _projectNameController.text.isNotEmpty && _descController.text.isNotEmpty;
      });
    });
    
    _descController.addListener(() {
      setState(() {
        _btnEnable = _projectNameController.text.isNotEmpty && _descController.text.isNotEmpty;
      });
    });
  }

  // Create unique ID
  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  // Add project method
  void _onAddProjectBtnPressed() {
    // Create and add project to data
    Project newProject = Project(
      id: _generateId(),
      name: _projectNameController.text,
      description: _descController.text,
      progressPercentage: 0.0,
      taskCount: 0,
      teamMembers: List.from(_selectedMembers),
      status: _status,
    );

    DataHelpers.addNewProject(newProject);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Project Added Successfully!'),
        backgroundColor: AppColors.successGreen,
      ),
    );
    
    Navigator.pop(context);
  }

  // Clear method
  void _onClearBtnPressed() {
    setState(() {
      _projectNameController.clear();
      _descController.clear();
      _status = 'Active';
      _selectedMembers.clear();
    });
  }

  @override
  void dispose() {
    _projectNameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        title: const Text('Add Project'),
        backgroundColor: AppColors.primaryNavy,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.paddingLarge),
        children: [
          // Project Name TextField
          TextField(
            decoration: const InputDecoration(
              filled: true,
              fillColor: AppColors.surfaceWhite,
              hintText: 'Enter a project name',
              labelText: 'Project Name',
              border: OutlineInputBorder(),
            ),
            controller: _projectNameController,
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          
          // Description TextField
          TextField(
            decoration: const InputDecoration(
              filled: true,
              fillColor: AppColors.surfaceWhite,
              hintText: 'Enter a description',
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
            controller: _descController,
            maxLines: 3,
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          
          // Status Dropdown
          DropdownButtonFormField<String>(
            value: _status,
            decoration: const InputDecoration(
              labelText: 'Status',
              filled: true,
              fillColor: AppColors.surfaceWhite,
              border: OutlineInputBorder(),
            ),
            items: ['Active', 'Completed', 'On Hold']
                .map((status) => DropdownMenuItem(
                      value: status,
                      child: Text(status),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _status = value!;
              });
            },
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          
          // Team Members Section
          Text(
            'Assign Team Members',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: AppDimensions.paddingSmall),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceWhite,
              border: Border.all(color: AppColors.textLight),
              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
            ),
            constraints: const BoxConstraints(maxHeight: 200),
            child: sharedTeamMembers.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(AppDimensions.paddingLarge),
                      child: Text('No team members available'),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: sharedTeamMembers.length,
                    itemBuilder: (context, index) {
                      final member = sharedTeamMembers[index];
                      final isSelected = _selectedMembers.contains(member.name);
                      
                      return CheckboxListTile(
                        title: Text(
                          member.name,
                          style: AppTextStyles.bodyLarge,
                        ),
                        subtitle: Text(
                          member.role,
                          style: AppTextStyles.bodyRegular,
                        ),
                        value: isSelected,
                        activeColor: AppColors.primaryNavy,
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              _selectedMembers.add(member.name);
                            } else {
                              _selectedMembers.remove(member.name);
                            }
                          });
                        },
                      );
                    },
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
                  padding: const EdgeInsets.only(right: AppDimensions.paddingSmall),
                  child: ElevatedButton(
                    onPressed: _projectNameController.text.isEmpty ? null : _onClearBtnPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryNavy,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingMedium),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
                      ),
                    ),
                    child: const Text('Clear'),
                  ),
                ),
              ),
              
              // Add Project Button
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: AppDimensions.paddingSmall),
                  child: ElevatedButton(
                    onPressed: _btnEnable ? _onAddProjectBtnPressed : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryNavy,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingMedium),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
                      ),
                    ),
                    child: const Text('Add Project'),
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
