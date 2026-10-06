import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:ironbook/features/member/models/member_ship_model.dart';
import 'package:ironbook/features/owner/models/plan_model.dart';

class MembershipServices {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> createMembership(MembershipModel membership) async {
    await _firestore.collection('memberships').doc().set(membership.toMap());
  }

  static Future<MembershipModel?> getMembership(String userId) async {
    final snapshot = await _firestore
        .collection('memberships')
        .where('memberId', isEqualTo: userId)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    return MembershipModel.fromMap(
      snapshot.docs.first.data(),
      snapshot.docs.first.id,
    );
  }

  static Future<void> cancelMembership(String membershipId) async {
    await _firestore.collection('memberships').doc(membershipId).update({
      'status': MembershipStatus.cancelled.name,
    });
  }

  //   static Stream<MembershipModel?> watchMembership(String userId) {
  //   return FirebaseFirestore.instance
  //       .collection('memberships')
  //       .where('userId', isEqualTo: userId)
  //       .limit(1)
  //       .snapshots()
  //       .map((snapshot) {
  //         if (snapshot.docs.isEmpty) {
  //           return null;
  //         }

  //         return MembershipModel.fromMap(
  //           snapshot.docs.first.data(),snapshot.docs.first.id
  //         );
  //       });
  // }

  static Future<void> approveMembership(String membershipId) async {
    final membershipRef = _firestore
        .collection('memberships')
        .doc(membershipId);

    final membershipSnapshot = await membershipRef.get();

    if (!membershipSnapshot.exists) {
      debugPrint('Membership not found.');
    }

    final membership = MembershipModel.fromMap(
      membershipSnapshot.data()!,
      membershipSnapshot.id,
    );

    if (membership.status != MembershipStatus.pending) {
      debugPrint('Membership is not pending.');
    }

    final planSnapshot = await _firestore
        .collection('subscriptionPlans')
        .doc(membership.planId)
        .get();

    if (!planSnapshot.exists) {
      debugPrint('Plan not found.');
    }

    final plan = SubscriptionPlan.fromMap(
      planSnapshot.data()!,
      planSnapshot.id,
    );

    final startDate = DateTime.now();

    final endDate = startDate.add(
      Duration(
        days: plan.type == SubscriptionPlanType.timeBased
            ? plan.durationInDays!
            : plan.validityInDays!,
      ),
    );

    await membershipRef.update({
      'status': MembershipStatus.active.name,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'sessionsUsed': 0,
    });
  }

  static Future<void> rejectMembership(String membershipId) async {
    await _firestore.collection('memberships').doc(membershipId).update({
      'status': MembershipStatus.rejected.name,
    });
  }

  static Future<void> checkInSession(
    MembershipModel membership,
    SubscriptionPlan plan,
  ) async {
    if (membership.id == null) {
      debugPrint('Membership ID is missing.');
    }

    if (membership.status != MembershipStatus.active) {
      debugPrint('Membership is not active.');
    }

    if (plan.type != SubscriptionPlanType.sessionBased) {
      debugPrint('This plan does not use sessions.');
    }

    if (plan.sessionCount == null) {
      debugPrint('Session count is missing.');
    }

    final membershipRef = _firestore
        .collection('memberships')
        .doc(membership.id);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(membershipRef);

      if (!snapshot.exists) {
        debugPrint('Membership not found.');
      }

      final data = snapshot.data()!;

      final status = MembershipStatus.values.byName(data['status']);

      final sessionsUsed = data['sessionsUsed'] ?? 0;

      if (status != MembershipStatus.active) {
        debugPrint('Membership is not active.');
      }

      if (sessionsUsed >= plan.sessionCount!) {
        debugPrint('No sessions remaining.');
      }

      transaction.update(membershipRef, {'sessionsUsed': sessionsUsed + 1});
    });
  }

  static Future<List<MembershipModel>> getMembershipRequests(
    String gymId,
  ) async {
    final memberships = await _firestore
        .collection('memberships')
        .where('gymId', isEqualTo: gymId)
        .where('status', isEqualTo: MembershipStatus.pending.name)
        .get();
    return List.generate(memberships.docs.length, (index) {
      final doc = memberships.docs[index];

      return MembershipModel.fromMap(doc.data(), doc.id);
    });
  }

  static Future<List<MembershipModel>> getMembers(String gymId) async {
    final memberships = await _firestore
        .collection('memberships')
        .where('gymId', isEqualTo: gymId)
        .where(
          'status',
          whereIn: [
            MembershipStatus.active.name,
            MembershipStatus.cancelled.name,
            MembershipStatus.rejected.name,
          ],
        )
        .get();
    return List.generate(memberships.docs.length, (index) {
      final doc = memberships.docs[index];

      return MembershipModel.fromMap(doc.data(), doc.id);
    });
  }
}
