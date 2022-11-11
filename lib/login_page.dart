// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_new
import 'dart:convert';
import 'dart:html';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
// Needed because we can't import `dart:html` into a mobile app,
// while on the flip-side access to `dart:io` throws at runtime (hence the `kIsWeb` check below)

import 'package:http/http.dart' as http;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  // text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _errorMessage = '';
  final _processRunning = false;

  Future signIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<UserCredential> signInWithApple() async {
    // Create and configure an OAuthProvider for Sign In with Apple.
    final provider = OAuthProvider('apple.com')
      ..addScope('email')
      ..addScope('name');

    // Sign in the user with Firebase.
    return await FirebaseAuth.instance.signInWithPopup(provider);
  }

  Future<UserCredential> signInWithFacebook() async {
    // Create a new provider
    FacebookAuthProvider facebookProvider = FacebookAuthProvider();

    facebookProvider.addScope('email');
    facebookProvider.setCustomParameters({
      'display': 'popup',
    });

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithPopup(facebookProvider);

    // Or use signInWithRedirect
    // return await FirebaseAuth.instance.signInWithRedirect(facebookProvider);
  }

  Future<void> logIn() async {
    final LoginResult result = await FacebookAuth.instance
        .login(); // by default we request the email and the public profile

    // loginBehavior is only supported for Android devices, for ios it will be ignored
    // final result = await FacebookAuth.instance.login(
    //   permissions: ['email', 'public_profile', 'user_birthday', 'user_friends', 'user_gender', 'user_link'],
    //   loginBehavior: LoginBehavior
    //       .DIALOG_ONLY, // (only android) show an authentication dialog instead of redirecting to facebook app
    // );

    if (result.status == LoginStatus.success) {
      var _accessToken = result.accessToken;
      //_printCredentials();
      // get the user data
      // by default we get the userId, email,name and picture
      final userData = await FacebookAuth.instance.getUserData();
      // final userData = await FacebookAuth.instance.getUserData(fields: "email,birthday,friends,gender,link");
      var _userData = userData;
      print('User data : ' + jsonEncode(_userData));
    } else {
      print(result.status);
      print(result.message);
    }

    setState(() {
      var _checking = false;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(),
            ),
            const VerticalDivider(
              width: 20,
              thickness: 1,
              indent: 20,
              endIndent: 0,
              color: Colors.grey,
            ),
            Expanded(
              child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.android,
                        size: 100,
                      ),
                      SizedBox(
                        height: 75,
                      ),
                      //Hello again!
                      Text('Hello Again!',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 36,
                          )),
                      SizedBox(height: 10),
                      Text('Welcome back, you\'ve been missed!',
                          style: TextStyle(
                            fontSize: 20,
                          )),
                      SizedBox(height: 50),

                      //email textfield
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            fillColor: Colors.grey[200],
                            filled: true,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),

                      //password textfield
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            fillColor: Colors.grey[200],
                            filled: true,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),

                      //sign in button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: GestureDetector(
                          onTap: signIn,
                          child: Container(
                            width: 400.0,
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: Colors.deepPurple,
                                borderRadius: BorderRadius.circular(12)),
                            child: Center(
                              child: Text(
                                'Sign In',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 25),

                      //not a member? register now
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Or sign in with',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(
                        height: 25,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SignInButton(
                            Buttons.Facebook,
                            mini: true,
                            onPressed: signInWithFacebook,
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0),
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          SignInButton(
                            Buttons.Apple,
                            mini: true,
                            onPressed: signInWithApple,
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0),
                            ),
                          )
                        ],
                      )
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
