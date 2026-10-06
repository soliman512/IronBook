enum UserRole { owner, member }

class UserModel {
  const UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    required this.phone,
    required this.role,
  });

  final String id;
  final String email;
  final String fullName;
  final String phone;
  final UserRole role;

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'fullName': fullName,
      'phone': phone,
      'role': role.name,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      email: map['email'],
      fullName: map['fullName'],
      phone: map['phone'],
      role: UserRole.values.byName(map['role']),
    );
  }
}
