class UserProfile {
  final String name;
  final String email;
  final String phone;
  final String role;

  const UserProfile({
    this.name = 'Tushar Sahu',
    this.email = 'demomail.tushar@gmail.com',
    this.phone = '+91 98765 43210',
    this.role = 'User',
  });

  UserProfile copyWith({
    String? name,
    String? email,
    String? phone,
    String? role,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
    );
  }
}
