import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ironbook/features/auth/models/generate_auto_gym_id.dart';
import 'package:ironbook/features/auth/models/gym_model.dart';

class GymServices {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static Future<GymModel> createGymDocument(GymModel gym) async {
    while (true) {
      final doc = await _firestore.collection('gyms').doc(gym.id).get();

      if (!doc.exists) {
        await _firestore.collection('gyms').doc(gym.id).set(gym.toMap());

        return gym;
      }

      gym = GymModel(
        id: generateGymId(),
        ownerId: gym.ownerId,
        name: gym.name,
        workStartAt: gym.workStartAt,
        workEndAt: gym.workEndAt,
      );
    }
  }

  static Future<GymModel?> getGym(String ownerId) async {
    final snapshot = await _firestore
        .collection('gyms')
        .where('ownerId', isEqualTo: ownerId)
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) {
      return null;
    }
    final gym = snapshot.docs.first.data();
    final String id = snapshot.docs.first.id;
    return GymModel.fromMap(gym, id);
  }

  static Future<GymModel?> getGymById(String gymId) async {
    final gymData = await _firestore
        .collection('gyms')
        .doc(gymId)
        .get();
    if (!gymData.exists) {
      return null;
    }
    final String id = gymData.id;
    return GymModel.fromMap(gymData.data()!, id);
  }
}
