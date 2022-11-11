import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/main_page.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    //ignore: prefer_const_constructors
    options: FirebaseOptions(
      apiKey: "AIzaSyBREIJ7g9q6DTkNRateQwmmrqR26-7mPMA",
      appId: "1:380638360301:web:9006cd67f761cf804412e4",
      messagingSenderId: "380638360301",
      projectId: "candy-city-4b1b6",
    ),
  );

// check if is running on Web
  if (kIsWeb) {
    // initialiaze the facebook javascript SDK
    await FacebookAuth.i.webInitialize(
      appId: "2927154857592093",
      cookie: true,
      xfbml: true,
      version: "v14.0",
    );
  }
  runApp(const MyApp());
//...
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // ignore: prefer_const_constructors
      home: MainPage(),
    );
  }
}
