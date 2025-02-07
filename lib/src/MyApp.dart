import 'package:flutter/material.dart';
import 'package:flutterfire/src/Page/ProfilePage.dart';
import 'package:flutterfire/src/Page/user_to_chat.dart';
import 'auth/AuthPage.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: const AuthPage(),
      routes: {
        '/UserPage' : (context) => UserPage(),
        '/ProfilePage' : (context) => ProfilePage(),
      },
    );
  }
}
