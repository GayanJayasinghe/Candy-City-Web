// ignore_for_file: prefer_const_constructors
import 'dart:ui';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

Future<void> _dialogBuilder(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Disable'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Enable'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
        constraints: const BoxConstraints.expand(),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.lightBlue,
                Colors.purple,
              ],
              stops: [0.0, 0.5],
            ),
            image: DecorationImage(
              image: AssetImage('images/Background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Center(
                    child: Card(
                      elevation: 10,
                      color: Colors.white.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      child: SizedBox(
                        width: 520,
                        height: 420,
                        child: Center(
                          child: SizedBox(
                            width: 60,
                            height: 60,
                            child: FloatingActionButton.small(
                                backgroundColor: Colors.white12,
                                onPressed: () => _dialogBuilder(context),
                                child: Icon(Icons.add)),
                          ),
                        ),
                      ),
                    ),
                  ),
                )),
          ]),
        ),
      ),
      //         // ignore: prefer_interpolation_to_compose_strings
      //         //child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

      //         // Text('Signed in as:${user.email!}'),
      //         // MaterialButton(
      //         //   onPressed: () {
      //         //     FirebaseAuth.instance.signOut();
      //         //   },
      //         //   color: Colors.deepOrange[200],
      //         //   child: Text('sign out'),
      //         // )

      //         //])
      //         ))
    ));
  }
}
