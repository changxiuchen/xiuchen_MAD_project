// ============================================
// SHARED PROJECTS - Global list that ALL screens use
// ============================================
import '../models/project_model.dart';

// List of projects that everyone shares
List<Project> sharedProjects = [
  Project(
    id: '1',
    name: 'Website Redesign',
    description: 'Redesign company website with modern UI',
    progressPercentage: 60.0,
    taskCount: 2,
    teamMembers: ['Xiu Chen', 'Jeremy'],
    status: 'Active',
  ),
  Project(
    id: '2',
    name: 'Mobile App',
    description: 'Build new mobile application for iOS and Android',
    progressPercentage: 40.0,
    taskCount: 3,  // Has 3 tasks: API integration, Write unit tests, Update documentation
    teamMembers: ['Xiu Chen', 'Garian', 'Matt'],
    status: 'Active',
  ),
  Project(
    id: '3',
    name: 'Database Migration',
    description: 'Migrate to new database system',
    progressPercentage: 80.0,
    taskCount: 1,  // Has 1 task: Setup database
    teamMembers: ['Javier'],
    status: 'Active',
  ),
  Project(
    id: '4',
    name: 'API Development',
    description: 'Develop REST API for backend services',
    progressPercentage: 0.0,
    taskCount: 0,  // Has 0 tasks currently
    teamMembers: ['Xiu Chen', 'Jason'],
    status: 'Active',
  ),
];
