import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire/src/service/auth_service.dart';

import '../Model/message.dart';

class chat_service {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Stream <List<Map<String,dynamic>>> getUser ()  {
    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }
  Future<void> sendMessage(String receiverid, String message) async {
    final String currentUserId = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();
    Message newMessage = Message(
        senderId: currentUserId,
        senderEmail: currentUserEmail,
        receiverId: receiverid,
        message: message,
        timestamp: timestamp);
    List<String> Ids = [currentUserId, receiverid];
    Ids.sort();
    String chatRoomId = Ids.join('_');

    await _firestore
        .collection('chat_room')
        .doc(chatRoomId)
        .collection('message')
        .add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessage(String userID, otherUserID) {
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');
    return _firestore
        .collection('chat_room')
        .doc(chatRoomID)
        .collection('message')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}