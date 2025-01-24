import 'package:flutter/material.dart';

import '../Page/LogInPage.dart';
import '../Page/SignUpPage.dart';



class LoginOrSignup extends StatefulWidget {
  const LoginOrSignup({super.key});

  @override
  State<LoginOrSignup> createState() => _LoginOrSignupState();
}

class _LoginOrSignupState extends State<LoginOrSignup> {
  bool showloginpage = true;

  void togglePage() {
    setState(() {
      showloginpage = !showloginpage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showloginpage) {
      return LoginPage(
        onPressed: togglePage,
      );
    } else {
      return SignupPage(
        onPressed: togglePage,
      );
    }
  }
}
