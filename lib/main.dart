import 'package:flutter/material.dart';
import 'login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // ignore: prefer_const_constructors
    options: FirebaseOptions(
      apiKey: "AIzaSyBREIJ7g9q6DTkNRateQwmmrqR26-7mPMA",
      appId: "1:380638360301:web:9006cd67f761cf804412e4",
      messagingSenderId: "380638360301",
      projectId: "candy-city-4b1b6",
    ),
  );

// Ideal time to initialize
  FirebaseAuth.instance.useEmulator('http://localhost:55978');
  //await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);

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
      home: LoginPage(),
    );
  }
}
