import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class fireStoreDatabase {
  User? user = FirebaseAuth.instance.currentUser;

  final CollectionReference posts =
      FirebaseFirestore.instance.collection('Post');
  
  Future<void> addPost(String message) {
    return posts.add({
      "email": user!.email,
      "postMessage": message,
      "Timestamp": Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> getPostStream() {
    final postStream = FirebaseFirestore.instance
        .collection('Post')
        .orderBy('Timestamp', descending: true)
        .snapshots();
    return postStream;
  }
}
