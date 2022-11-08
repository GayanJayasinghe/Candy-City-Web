// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(children: [
      // ignore: prefer_interpolation_to_compose_strings
      Text('Signed in as:' + user.email!),
      MaterialButton(
        onPressed: () {
          FirebaseAuth.instance.signOut();
        },
        color: Colors.deepOrange[200],
        child: Text('sign out'),
      )
    ])));
  }
}
