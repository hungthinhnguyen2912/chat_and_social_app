import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class auth_service {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? getCurrentUser () {
    return _auth.currentUser;
  }
  Future<UserCredential> LogIn(String email, String pass) async {
    try {
      UserCredential user = await _auth
          .signInWithEmailAndPassword(email: email, password: pass);
      return user;

    } on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<UserCredential> register(String email, String pass, String username) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: pass);

      if (userCredential.user != null) {
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'email': email,
          'username' : username
        });
      }
      return userCredential;
    } catch (e) {
      print('Error during registration: $e');
      throw Exception(e);
    }
  }

  Future<void> logOut() async {
    return await _auth.signOut();
  }
}
