import 'package:cloud_firestore/cloud_firestore.dart';

class userFireStore {
  Stream<QuerySnapshot> getByEmailPostStream(String email) {
    return FirebaseFirestore.instance
        .collection('Post')
        .where('email', isEqualTo: email)
        .snapshots();
  }
}