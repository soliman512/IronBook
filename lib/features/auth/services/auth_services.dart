import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ironbook/features/auth/models/user_model.dart';

class AuthServices {
  //sign up user to firebase auth
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

  //create user docuent in users collection
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static Future<void> createUserDocument(UserModel user) async {
    await _firestore.collection('users').doc(user.id).set(user.toMap());
  }
static Future<UserModel?> getUserData(String userId) async {
   final doc = await _firestore
        .collection('users')
        .doc(userId)
        .get();
        if(!doc.exists){
          return null;
        }
        return UserModel.fromMap(doc.data()!, doc.id);
}
  //login
  static Future<UserModel?> loginAndGetUserData({
    required String emailAddress,
    required String password,
  }) async {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );
    final doc = await _firestore
        .collection('users')
        .doc(credential.user!.uid)
        .get();
    if (!doc.exists) {
      return null;
    }
    return UserModel.fromMap(doc.data()!, doc.id);
    // return credential.user?.uid;
    // return UserModel.fromMap(await _firestore.collection('users').doc(credential.user?.uid).get(), credential.user!.uid) ;
  }
}
