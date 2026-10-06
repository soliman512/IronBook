import 'package:cloud_firestore/cloud_firestore.dart';

class MembershipModel {
  const MembershipModel({
    this.id,
    required this.userId,
    required this.gymId,
    required this.planId,
    required this.status,
    this.startDate,
    this.endDate,
    this.sessionsUsed = 0,
  });

  final String? id;
  final String userId;
  final String gymId;
  final String planId;
  final MembershipStatus status;
  final DateTime? startDate;
  final DateTime? endDate;
  final int sessionsUsed;

  Map<String, dynamic> toMap() {
    return {
      'memberId': userId,
      'gymId': gymId,
      'planId': planId,
      'status': status.name,
      'sessionsUsed': sessionsUsed,
      'startDate': startDate != null
          ? Timestamp.fromDate(startDate!)
          : null,
      'endDate': endDate != null
          ? Timestamp.fromDate(endDate!)
          : null,
    };
  }

  factory MembershipModel.fromMap(
    Map<String, dynamic> map,
    String id,
  ) {
    return MembershipModel(
      id: id,
      userId: map['memberId'],
      gymId: map['gymId'],
      planId: map['planId'],
      sessionsUsed: map['sessionsUsed'] ?? 0,
      status: MembershipStatus.values.byName(map['status']),
      startDate: map['startDate'] != null
          ? (map['startDate'] as Timestamp).toDate()
          : null,
      endDate: map['endDate'] != null
          ? (map['endDate'] as Timestamp).toDate()
          : null,
    );
  }
}

enum MembershipStatus {
  active,
  pending,
  rejected,
  cancelled,
}