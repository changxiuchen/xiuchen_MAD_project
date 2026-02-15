import 'package:flutter/material.dart';
import '../../models/team_member_model.dart';
import '../../data/data_helpers.dart';
import '../../constants/app_constants.dart';

class AddMemberScreen extends StatefulWidget {
  const AddMemberScreen({super.key});

  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _jobTitleController = TextEditingController();
  
  // Create unique ID
  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  void _submitData() {
    if (_formKey.currentState!.validate()) {
      // Create new Member object
      TeamMember newMember = TeamMember(
        id: _generateId(),
        name: _nameController.text,
        email: "no-email@example.com", // Placeholder
        role: "Member", // Placeholder
        jobTitle: _jobTitleController.text,
        taskCount: 0,
        completedTasks: 0,
        projectsAssigned: [],
      );

      // Add to global data
      DataHelpers.addNewMember(newMember);
      
      // Show success and go back
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Team Member Added Successfully!'),
         backgroundColor: AppColors.successGreen,
         ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Team Member'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // NAME
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              

              
              // JOB TITLE (Longer description)
              TextFormField(
                controller: _jobTitleController,
                decoration: const InputDecoration(labelText: 'Job Title (e.g. Senior Backend Dev)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a job title';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 32),
              
              // SUBMIT BUTTON
              ElevatedButton(
                onPressed: _submitData,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Add Member'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
