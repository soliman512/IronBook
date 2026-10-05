import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ironbook/features/auth/models/user_model.dart';

class AuthServices {
  static Future<String?> signup({
    required String emailAddress,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailAddress,
            password: password,
          );
      return credential.user?.uid;
    } on FirebaseAuthException catch (e) {
      return e.code.toString();
    } catch (e) {
      return e.toString();
    }
  }

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static Future<void> createUserDocument(UserModel user) async {
    await _firestore.collection('useres').doc(user.id).set(user.toMap());
  }
}
