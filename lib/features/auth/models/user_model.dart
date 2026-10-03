
enum UserGymMode { owner, member }

class UserModel {
  const UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    required this.phone,
    required this.role,
    this.gymId,
  });

  final String id;
  final String email;
  final String fullName;
  final String phone;
  final UserGymMode role;
  final String? gymId;
}
