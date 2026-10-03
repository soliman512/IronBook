class MembershipModel {
  const MembershipModel({
    required this.id,
    required this.userId,
    required this.gymId,
    required this.planId,
    required this.status,
  });

  final String id;
  final String userId;
  final String gymId;
  final String planId;
  final MembershipStatus status;
}

enum MembershipStatus {
  active,
  pending,
  expired,
  cancelled,
}