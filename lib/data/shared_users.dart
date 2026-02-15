// ============================================
// SHARED USERS - Global list for authentication
// ============================================
import '../models/user_model.dart';

// List of registered users
// Users can also REGISTER to add more users to this list
List<User> sharedUsers = [
  // Hardcoded test user for quick login 
  User(
    id: 'test',
    email: 'xc@gmail.com',
    password: '2003chang',
    name: 'Test User',
    phone: '67676767',
    jobTitle: 'Developer',
  ),
];

// Currently logged-in user (null when not logged in)
// After login, set this to the logged-in user
User? currentUser;
