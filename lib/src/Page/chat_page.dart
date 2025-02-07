import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../component/MyTextField.dart';
import '../component/chat_bubble.dart';
import '../service/auth_service.dart';
import '../service/chat_service.dart';


class ChatPage extends StatelessWidget {
  final String receiverEmail;
  final String receiverID;

  ChatPage({super.key, required this.receiverEmail, required this.receiverID});

  final TextEditingController _messageController = TextEditingController();
  final chat_service _chat = chat_service();
  final auth_service _auth = auth_service();

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chat.sendMessage(receiverID, _messageController.text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(receiverEmail),
      ),
      body: Column(
        children: [Expanded(child: _buildMessageList()), _buildUserInput()],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderId = _auth.getCurrentUser()!.uid;
    return StreamBuilder(
        stream: _chat.getMessage(senderId, receiverID),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Error');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            children: snapshot.data!.docs
                .map((doc) => _buildMessageItem(doc))
                .toList(),
          );
        });
  }

  Widget _buildMessageItem(DocumentSnapshot e) {
    Map<String, dynamic> data = e.data() as Map<String, dynamic>;

    bool isCurrentUser = data['senderId'] == _auth.getCurrentUser()!.uid;

    var alignment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
        alignment: alignment,
        child: Column(
          crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            chat_bubble(messsage: data['message'], isCurrentUser: isCurrentUser,)
          ],
        ));
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Row(
        children: [
          Expanded(
              child: MyTextField(
                  hintText: 'Message',
                  obscureText: false,
                  controller: _messageController)),
          IconButton(onPressed: sendMessage, icon: Icon(Icons.arrow_forward_outlined))
        ],
      ),
    );
  }
}