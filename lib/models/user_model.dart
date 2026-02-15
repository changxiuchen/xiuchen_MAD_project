// ============================================
// USER MODEL
// ============================================
class User {
  final String id;
  final String email;
  final String password;
  final String name;
  final String phone;
  final String jobTitle;

  User({
    required this.id,
    required this.email,
    required this.password,
    required this.name,
    required this.phone,
    required this.jobTitle,
  });

  // Create a copy of User with modified fields
  User copyWith({
    String? id,
    String? email,
    String? password,
    String? name,
    String? phone,
    String? jobTitle,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      jobTitle: jobTitle ?? this.jobTitle,
    );
  }
}
