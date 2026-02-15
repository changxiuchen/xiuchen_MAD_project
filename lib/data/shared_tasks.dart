// ============================================
// SHARED TASKS - Global list that ALL screens use
// ============================================
import '../models/task_model.dart';

// list of tasks that everyone shares
List<Task> sharedTasks = [
  Task(
    id: '1',
    title: 'Design homepage mockup',
    description: 'Create mockup for homepage',
    priority: 'High',
    status: 'In Progress',
    assignedTo: 'Jeremy',  // UI/UX Designer
    projectId: '1',
    deadline: DateTime.now().add(const Duration(days: 3)),
  ),
  Task(
    id: '2',
    title: 'Setup database',
    description: 'Configure new database server',
    priority: 'High',
    status: 'To-Do',
    assignedTo: 'Javier',  // Database Admin
    projectId: '3',
    deadline: DateTime.now().add(const Duration(days: 5)),
  ),
  Task(
    id: '3',
    title: 'API integration',
    description: 'Integrate payment API',
    priority: 'Medium',
    status: 'To-Do',
    assignedTo: 'Garian',  // Backend Developer
    projectId: '2',
    deadline: DateTime.now().add(const Duration(days: 7)),
  ),
  Task(
    id: '4',
    title: 'Write unit tests',
    description: 'Write unit tests for authentication module',
    priority: 'Medium',
    status: 'Done',
    assignedTo: 'Matt',  // QA Engineer
    projectId: '2',
    deadline: DateTime.now().subtract(const Duration(days: 2)),
  ),
  Task(
    id: '5',
    title: 'Update documentation',
    description: 'Update API documentation',
    priority: 'Low',
    status: 'To-Do',
    assignedTo: 'Jason',  // Technical Writer
    projectId: '2',
    deadline: DateTime.now().add(const Duration(days: 10)),
  ),
  Task(
    id: '6',
    title: 'Fix login bug',
    description: 'Fix bug in login screen',
    priority: 'High',
    status: 'Done',
    assignedTo: 'Xiu Chen',  // Senior Developer
    projectId: '1',
    deadline: DateTime.now().add(const Duration(days: 1)),
  ),
];
