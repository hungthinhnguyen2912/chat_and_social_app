import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire/src/Page/HomePage.dart';
import 'package:flutterfire/src/auth/AuthPage.dart';
import 'package:flutterfire/src/service/auth_service.dart';

import '../component/MyTextField.dart';

class LoginPage extends StatefulWidget {
  void Function()? onPressed;

  LoginPage({super.key, required this.onPressed});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  final auth_service _auth = auth_service();

  // void login() async {
  //   // showDialog(
  //   //     context: context, builder: (context) => CircularProgressIndicator());
  //   // try {
  //   //   await FirebaseAuth.instance.signInWithEmailAndPassword(
  //   //       email: emailController.text, password: passController.text);
  //   //   if (context.mounted) {
  //   //     Navigator.pop(context);
  //   //   }
  //   // } on FirebaseException catch (e) {
  //   //   showDialog(
  //   //       context: context,
  //   //       builder: (BuildContext context) => AlertDialog(
  //   //             title:  Text(e.code),
  //   //           ));
  //   // }
  //   await _auth.LogIn(emailController.text, passController.text, context);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_circle_outlined,
              size: 72,
            ),
            SizedBox(
              height: 40,
            ),
            MyTextField(
                hintText: "Email",
                obscureText: false,
                controller: emailController),
            SizedBox(
              height: 30,
            ),
            MyTextField(
                hintText: "Pass",
                obscureText: true,
                controller: passController),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Forgot Password ? ',
                    style: TextStyle(fontSize: 17),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () async {
                try {
                  await _auth.LogIn(emailController.text, passController.text);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AuthPage()));
                } catch (e) {
                  showDialog(context: context, builder: (context) => AlertDialog(
                    title: Text(e.toString()),
                  ));
                }
              },
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey,
                ),
                child: Center(
                  child: Text('Sign in'),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('New User ?'),
                TextButton(
                    onPressed: widget.onPressed, child: Text('Sign up here'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
