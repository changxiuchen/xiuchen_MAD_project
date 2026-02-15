// ============================================
// SHARED TEAM MEMBERS - Global list for team screen
// ============================================
import '../models/team_member_model.dart';

List<TeamMember> sharedTeamMembers = [
  TeamMember(
    id: '1',
    name: 'Xiu Chen',
    email: 'xc@gmail.com',
    role: 'Developer',
    jobTitle: 'Senior Developer',
    taskCount: 5,
    completedTasks: 3,
    projectsAssigned: ['Website Redesign', 'Mobile App'],
  ),
  TeamMember(
    id: '2',
    name: 'Jeremy',
    email: 'jeremy@gmail.com',
    role: 'Designer',
    jobTitle: 'UI/UX Designer',
    taskCount: 3,
    completedTasks: 2,
    projectsAssigned: ['Website Redesign'],
  ),
  TeamMember(
    id: '3',
    name: 'Garian',
    email: 'garian@outlook.com',
    role: 'Developer',
    jobTitle: 'Backend Developer',
    taskCount: 8,
    completedTasks: 4,
    projectsAssigned: ['Mobile App', 'API Development'],
  ),
  TeamMember(
    id: '4',
    name: 'Matt',
    email: 'matt@yahoo.com',
    role: 'QA',
    jobTitle: 'QA Engineer',
    taskCount: 4,
    completedTasks: 3,
    projectsAssigned: ['Mobile App'],
  ),
  TeamMember(
    id: '5',
    name: 'Javier',
    email: 'javier@hotmail.com',
    role: 'Admin',
    jobTitle: 'Database Admin',
    taskCount: 3,
    completedTasks: 2,
    projectsAssigned: ['Database Migration'],
  ),
  TeamMember(
    id: '6',
    name: 'Jason',
    email: 'Jason@gmail.com',
    role: 'Writer',
    jobTitle: 'Technical Writer',
    taskCount: 2,
    completedTasks: 1,
    projectsAssigned: ['API Development'],
  ),
];
