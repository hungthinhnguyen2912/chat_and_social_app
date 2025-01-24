
import 'package:flutter/material.dart';

class chat_bubble extends StatelessWidget {
  final String messsage;
  final bool isCurrentUser;

  chat_bubble({super.key, required this.messsage, required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isCurrentUser ? Colors.lightGreenAccent : Colors.black12,
      ),
      child: Text(
        messsage,
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
