import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:one_to_one_chatapp/loginpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<User?> createAccount(String name, String email, String password) async {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  try {
    User? user = (await firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;
    if (user != null) {
      print('Account created Successfully');

      user.updateProfile(displayName: name);
      await firebaseFirestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .set({
        "name": name,
        "email": email,
        "status": "Unavailable",
        "uid": firebaseAuth.currentUser!.uid
      });
      return user;
    } else {
      print("Account creation failed");
      return user;
    }
  } catch (e) {
    print(e);
    return null;
  }
}

Future<User?> logIn(String email, String password) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  try {
    User? user = (await auth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;
    if (user != null) {
      print('Login Successfull');
      return user;
    } else {
      print('Login failed');
      return user;
    }
  } catch (e) {
    print(e);
    return null;
  }
}

Future logOut(BuildContext context) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  try {
    await auth.signOut().then((value) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
    });
  } catch (e) {
    print("Error");
  }
}
