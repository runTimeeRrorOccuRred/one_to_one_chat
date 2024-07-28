import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:one_to_one_chatapp/homescreen.dart';
import 'package:one_to_one_chatapp/loginpage.dart';

class Authenticate extends StatelessWidget {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    if (firebaseAuth.currentUser != null) {
      // print("hiiiiii");
      // print(firebaseAuth.currentUser!.displayName);
      return HomeScreen(
        userName: firebaseAuth.currentUser!.displayName,
      );
    } else {
      return const LoginPage();
    }
  }
}
