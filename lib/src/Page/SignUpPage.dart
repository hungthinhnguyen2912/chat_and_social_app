import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire/src/auth/AuthPage.dart';
import 'package:flutterfire/src/service/auth_service.dart';
import '../component/MyTextField.dart';

class SignupPage extends StatefulWidget {
  void Function()? onPressed;

  SignupPage({super.key, required this.onPressed});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController confirmpassController = TextEditingController();
  auth_service _auth = auth_service();

  void register() async {
    if (passController.text != confirmpassController.text) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Password do not match'),
        ),
      );
    } else {
      try {
        await _auth.register(emailController.text, passController.text, usernameController.text);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => AuthPage()));
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Registration Failed'),
            content: Text('$e'),
          ),
        );
      }
    }
  }

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
                hintText: "UserName",
                obscureText: false,
                controller: usernameController),
            SizedBox(
              height: 30,
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
              height: 30,
            ),
            MyTextField(
                hintText: "Confirm password",
                obscureText: true,
                controller: confirmpassController),
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
              onTap: register,
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey,
                ),
                child: Center(
                  child: Text('Sign Up'),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Have account ?'),
                TextButton(
                    onPressed: widget.onPressed, child: Text('Log in With Me'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
