import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ironbook/features/owner/models/plan_model.dart';

class PlanServices {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> createPlan(SubscriptionPlan plan) async {
    await _firestore.collection('subscriptionPlans').doc().set(plan.toMap());
  }

  static Future<List<SubscriptionPlan>> getPlans(String gymId) async {
    final collectionDocs = await _firestore
        .collection('subscriptionPlans')
        .where('gymId', isEqualTo: gymId)
        .get();
    return collectionDocs.docs
        .map((doc) => SubscriptionPlan.fromMap(doc.data(), doc.id))
        .toList();
  }

  static Future<void> deletePlan(String planId) async {
    await _firestore.collection('subscriptionPlans').doc(planId).delete();
  }

  static Future<SubscriptionPlan> getPlan(String planId) async {
    final plan = await _firestore
        .collection('subscriptionPlans')
        .doc(planId)
        .get();
    return SubscriptionPlan.fromMap(plan.data()!, plan.id);
  }
}
