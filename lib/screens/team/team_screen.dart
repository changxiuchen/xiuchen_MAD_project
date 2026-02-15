import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../data/shared_team_members.dart';
import '../../data/shared_tasks.dart';
import '../../widgets/custom_header.dart';
import '../../widgets/card_container.dart';
import 'add_member_screen.dart';

class TeamScreen extends StatefulWidget {
  const TeamScreen({super.key});

  @override
  State<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            CustomHeader(
              title: 'Team Members',
              subtitle: '${sharedTeamMembers.length} members',
            ),

            const SizedBox(height: AppDimensions.paddingLarge),



            const SizedBox(height: AppDimensions.paddingMedium),

            // Team members list
            Expanded(

              child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingLarge,
                      ),
                      itemCount: sharedTeamMembers.length,
                      itemBuilder: (context, index) {
                        final member = sharedTeamMembers[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: CardContainer(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Member header with avatar
                                Row(
                                  children: [
                                    // Avatar
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: AppColors.secondaryTeal
                                            .withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Center(
                                        child: Text(
                                          member.name[0],
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.secondaryTeal,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    // Member info
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            member.name,
                                            style: AppTextStyles.heading3,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            member.jobTitle,
                                            style: AppTextStyles.bodyRegular,
                                          ),
                                        ],
                                      ),
                                    ),

                                  ],
                                ),

                                const SizedBox(height: 12),

                                // Task progress
                                Builder(
                                  builder: (context) {
                                    // Calculate task statistics

                                    int totalTasks = 0;
                                    int completedTasks = 0;
                                    
                                    for (int i = 0; i < sharedTasks.length; i++) {
                                      final task = sharedTasks[i];
                                      if (task.assignedTo == member.name) {
                                        totalTasks++;
                                        if (task.status == 'Done') {
                                          completedTasks++;
                                        }
                                      }
                                    }
                                    
                                    return Row(
                                      children: [
                                        const Icon(
                                          Icons.check_circle_outline,
                                          size: 16,
                                          color: AppColors.secondaryTeal,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          '$completedTasks/$totalTasks tasks completed',
                                          style: AppTextStyles.caption,
                                        ),
                                      ],
                                    );
                                  }
                                ),

                                const SizedBox(height: 8),

                                // Projects assigned
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.folder_outlined,
                                      size: 16,
                                      color: AppColors.secondaryTeal,
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        member.projectsAssigned.join(', '),
                                        style: AppTextStyles.caption,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                      
                    );}
            ),
        )],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddMemberScreen()),
          );
          setState(() {});
        },
        backgroundColor: AppColors.primaryNavy,
        child: const Icon(Icons.person_add, color: Colors.white),
      ),
    );
  }
}
