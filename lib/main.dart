import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:one_to_one_chatapp/authenticate.dart';

import 'loginpage.dart';

void main()async
{
  WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp();



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
