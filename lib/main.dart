import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:one_to_one_chatapp/authenticate.dart';

import 'loginpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyD3Y-50AcHAzzPObIPbKdzM0QbEVov1utg",
            appId: "1:1065214532556:android:33367047c6a44e1fa59b69",
            messagingSenderId: "1065214532556",
            projectId: "talk-nest-e44ce"));
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Authenticate(),
    );
  }
}
