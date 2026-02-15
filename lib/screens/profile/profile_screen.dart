import 'package:flutter/material.dart';
import '/constants/app_constants.dart';
import '/data/shared_users.dart';
import 'edit_profile_screen.dart';
import '../about/about_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = 'Guest User';
  String userEmail = 'guest@example.com';
  String userPhone = 'N/A';
  String userJobTitle = 'N/A';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  // Load profile data from currentUser
  void _loadProfileData() {
    setState(() {
      if (currentUser != null) {
        userName = currentUser!.name;
        userEmail = currentUser!.email;
        userPhone = currentUser!.phone;
        userJobTitle = currentUser!.jobTitle;
      }
      isLoading = false;
    });
  }

  // Handle logout
  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Clear the current user
              currentUser = null;
              
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: AppColors.errorRed),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: AppColors.backgroundGrey,
        body: const Center(
          child: CircularProgressIndicator(
            color: AppColors.secondaryTeal,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header with profile avatar
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
                  children: [
                    // Large avatar
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.secondaryTeal.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: AppColors.secondaryTeal,
                          width: 3,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          userName[0].toUpperCase(),
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondaryTeal,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // User name
                    Text(
                      userName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Job title
                    Text(
                      userJobTitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppDimensions.paddingLarge),

              // Profile information card
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
                        'Profile Information',
                        style: AppTextStyles.heading2,
                      ),
                      const SizedBox(height: 16),
                      // Email field
                      _buildProfileField(
                        icon: Icons.email_outlined,
                        label: 'Email',
                        value: userEmail,
                      ),
                      const SizedBox(height: 16),
                      // Phone field
                      _buildProfileField(
                        icon: Icons.phone_outlined,
                        label: 'Phone',
                        value: userPhone,
                      ),
                      const SizedBox(height: 16),
                      // Job title field
                      _buildProfileField(
                        icon: Icons.work_outline,
                        label: 'Job Title',
                        value: userJobTitle,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppDimensions.paddingLarge),

              // Action buttons
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingLarge,
                ),
                child: Column(
                  children: [
                    // Edit Profile Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfileScreen(
                                initialName: userName,
                                initialEmail: userEmail,
                                initialPhone: userPhone,
                                initialJobTitle: userJobTitle,
                              ),
                            ),
                          );

                          if (result != null) {
                            setState(() {
                              userName = result['name'];
                              userEmail = result['email'];
                              userPhone = result['phone'];
                              userJobTitle = result['jobTitle'];
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondaryTeal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppDimensions.borderRadiusLarge,
                            ),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.edit, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'Edit Profile',
                              style: AppTextStyles.buttonText,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // About Us Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AboutUsScreen(),
                            ),
                          );
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
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: AppColors.secondaryTeal,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'About Us',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.secondaryTeal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Logout Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _handleLogout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.errorRed,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppDimensions.borderRadiusLarge,
                            ),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.logout, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'Logout',
                              style: AppTextStyles.buttonText,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppDimensions.paddingLarge),

              // App version
              Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                child: Text(
                  'WorkHub v1.6.7',
                  style: AppTextStyles.caption,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for profile fields
  Widget _buildProfileField({
    required IconData icon,
    required String label,
    required String value,
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
                style: AppTextStyles.bodyLarge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
