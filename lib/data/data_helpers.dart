// ============================================
// DATA HELPERS - Simple utility functions for beginners
// ============================================
import '../models/task_model.dart';
import '../models/project_model.dart';
import '../models/user_model.dart';
import '../models/team_member_model.dart';
import 'shared_tasks.dart';
import 'shared_projects.dart';
import 'shared_team_members.dart';

import 'shared_users.dart';

class DataHelpers {
  // ============================================
  // TASK HELPERS
  // ============================================
  
  /// Get tasks for a specific project
  static List<Task> getTasksForProject(String projectId) {
    List<Task> result = [];
    
    // Loop through all tasks
    for (var task in sharedTasks) {
      // If task belongs to this project, add it
      if (task.projectId == projectId) {
        result.add(task);
      }
    }
    
    return result;
  }

  /// Get tasks assigned to a specific person
  static List<Task> getTasksForPerson(String assignedTo) {
    List<Task> result = [];
    
    // Loop through all tasks
    for (var task in sharedTasks) {
      // If task is assigned to this person, add it
      if (task.assignedTo == assignedTo) {
        result.add(task);
      }
    }
    
    return result;
  }

  /// Get tasks by status (e.g., "To-Do", "In Progress", "Done")
  static List<Task> getTasksByStatus(String status) {
    List<Task> result = [];
    
    // Loop through all tasks
    for (var task in sharedTasks) {
      // If task has this status, add it
      if (task.status == status) {
        result.add(task);
      }
    }
    
    return result;
  }

  /// Get tasks by priority (e.g., "High", "Medium", "Low")
  static List<Task> getTasksByPriority(String priority) {
    List<Task> result = [];
    
    // Loop through all tasks
    for (var task in sharedTasks) {
      // If task has this priority, add it
      if (task.priority == priority) {
        result.add(task);
      }
    }
    
    return result;
  }

  /// Count how many tasks a project has
  static int countTasksForProject(String projectId) {
    int count = 0;
    
    // Loop through all tasks
    for (var task in sharedTasks) {
      // If task belongs to this project, count it
      if (task.projectId == projectId) {
        count++;
      }
    }
    
    return count;
  }

  // ============================================
  // PROJECT HELPERS
  // ============================================
  
  /// Find a project by its ID
  static Project? getProjectById(String projectId) {
    // Loop through all projects
    for (var project in sharedProjects) {
      // If we find the project, return it
      if (project.id == projectId) {
        return project;
      }
    }
    
    // If not found, return null
    return null;
  }

  /// Get all projects that a team member is part of
  static List<Project> getProjectsForTeamMember(String memberName) {
    List<Project> result = [];
    
    // Loop through all projects
    for (var project in sharedProjects) {
      // Check if this member is in the team
      if (project.teamMembers.contains(memberName)) {
        result.add(project);
      }
    }
    
    return result;
  }

  /// Calculate what percentage of a project is complete
  static double calculateProjectProgress(String projectId) {
    // Get all tasks for this project
    List<Task> projectTasks = getTasksForProject(projectId);
    
    // If no tasks, progress is 0%
    if (projectTasks.isEmpty) return 0.0;
    
    // Count how many tasks are done
    int completedCount = 0;
    for (var task in projectTasks) {
      if (task.status == 'Done') {
        completedCount++;
      }
    }
    
    // Calculate percentage
    return (completedCount / projectTasks.length) * 100;
  }


  // ============================================
  // USER HELPERS (for login/register)
  // ============================================
  
  /// Check if email and password are correct (for login)
  static User? authenticateUser(String email, String password) {
    // Loop through all users
    for (var user in sharedUsers) {
      // Check if email AND password match
      if (user.email == email && user.password == password) {
        return user; // Login successful!
      }
    }
    
    // If get here, login failed
    return null;
  }

  /// Check if an email is already registered
  static bool isEmailRegistered(String email) {
    // Loop through all users
    for (var user in sharedUsers) {
      // If find this email, it's registered
      if (user.email == email) {
        return true;
      }
    }
    
    // Email not found, it's available
    return false;
  }

  // ============================================
  // STATISTICS HELPERS (for dashboard)
  // ============================================
  
  /// Get total number of tasks
  static int getTotalTasksCount() {
    return sharedTasks.length;
  }

  /// Count how many tasks are completed
  static int getCompletedTasksCount() {
    int count = 0;
    
    // Loop through all tasks
    for (var task in sharedTasks) {
      // If task is done, count it
      if (task.status == 'Done') {
        count++;
      }
    }
    
    return count;
  }

  /// Count how many tasks are in progress
  static int getInProgressTasksCount() {
    int count = 0;
    
    // Loop through all tasks
    for (var task in sharedTasks) {
      // If task is in progress, count it
      if (task.status == 'In Progress') {
        count++;
      }
    }
    
    return count;
  }

  /// Count how many tasks are pending (To-Do)
  static int getPendingTasksCount() {
    int count = 0;
    
    // Loop through all tasks
    for (var task in sharedTasks) {
      // If task is to-do, count it
      if (task.status == 'To-Do') {
        count++;
      }
    }
    
    return count;
  }

  /// Count how many projects are active
  static int getActiveProjectsCount() {
    int count = 0;
    
    // Loop through all projects
    for (var project in sharedProjects) {
      // If project is active, count it
      if (project.status == 'Active') {
        count++;
      }
    }
    
    return count;
  }

  // ============================================
  // PROJECT UPDATE HELPERS
  // ============================================
  
  /// Update a project's metrics (task count and progress) based on actual tasks
  /// This ensures the project data stays in sync with the task data
  static void updateProjectMetrics(Project project) {
    // Count actual tasks for this project
    int actualTaskCount = countTasksForProject(project.id);
    
    // Calculate actual progress
    double actualProgress = calculateProjectProgress(project.id);
    
    // Find the project in sharedProjects and update it
    for (int i = 0; i < sharedProjects.length; i++) {
      if (sharedProjects[i].id == project.id) {
        sharedProjects[i] = Project(
          id: project.id,
          name: project.name,
          description: project.description,
          progressPercentage: actualProgress,
          taskCount: actualTaskCount,
          teamMembers: project.teamMembers,
          status: project.status,
        );
        break;
      }
    }
  }
  
  /// Update all projects' metrics at once
  ///  to refresh all project data
  // ============================================
  // ADD DATA HELPERS
  // ============================================

  /// Add a new project
  static void addNewProject(Project project) {
    sharedProjects.add(project);
  }

  /// Add a new task
  static void addNewTask(Task task) {
    sharedTasks.add(task);
  }

  /// Add a new team member
  static void addNewMember(TeamMember member) {
    sharedTeamMembers.add(member);
  }

  // ============================================
  // EDIT & DELETE DATA HELPERS
  // ============================================


  /// Delete a project
  static void deleteProject(String id) {
    // Find project to delete
    Project? projectToDelete;
    for (var project in sharedProjects) {
      if (project.id == id) {
        projectToDelete = project;
        break;
      }
    }
    
    // Remove it if found
    if (projectToDelete != null) {
      sharedProjects.remove(projectToDelete);
    }
    
    // Also delete tasks for this project
    // have to collect them first to avoid issues while modifying the list
    List<Task> tasksToDelete = [];
    for (var task in sharedTasks) {
      if (task.projectId == id) {
        tasksToDelete.add(task);
      }
    }
    
    // Remove them one by one
    for (var task in tasksToDelete) {
      sharedTasks.remove(task);
    }
  }

  /// Edit an existing task
  static void editTask(Task task) {
    for (int i = 0; i < sharedTasks.length; i++) {
      if (sharedTasks[i].id == task.id) {
        sharedTasks[i] = task;
        break;
      }
    }
  }

  /// Delete a task
  static void deleteTask(String id) {
    // Find task to delete
    Task? taskToDelete;
    for (var task in sharedTasks) {
      if (task.id == id) {
        taskToDelete = task;
        break;
      }
    }
    
    // Remove it if found
    if (taskToDelete != null) {
      sharedTasks.remove(taskToDelete);
    }
  }

  static void updateAllProjectMetrics() {
    // Create a copy of the project IDs to avoid concurrent modification
    List<String> projectIds = [];
    for (var project in sharedProjects) {
      projectIds.add(project.id);
    }
    
    // update each project by ID
    for (String projectId in projectIds) {
      // Find the project
      for (var project in sharedProjects) {
        if (project.id == projectId) {
          updateProjectMetrics(project);
          break;
        }
      }
    }
  }

}
