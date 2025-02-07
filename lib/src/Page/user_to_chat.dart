import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire/src/component/UserTile.dart';
import 'package:flutterfire/src/service/chat_service.dart';

import 'chat_page.dart';

class UserPage extends StatelessWidget {
  final chat_service _chat = chat_service();

  UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Page'),
        centerTitle: true,
      ),
      body: StreamBuilder(
          stream: _chat.getUser(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: Text('Something went wrong ${snapshot.error}'),
                      ));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (snapshot.data == null) {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: Text('No Data'),
                      ));
            }
            return ListView(
              children: snapshot.data!
                  .map<Widget>(
                      (userData) => _builderlistItem(userData, context))
                  .toList(),
            );
          }),
    );
  }

  Widget _builderlistItem(Map<String, dynamic> userData, BuildContext context) {
    return UserTile(text: userData['email'], onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) =>ChatPage(receiverEmail: userData['email'], receiverID: userData['uid'])));
    });
  }
}
