// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_new
import 'dart:convert';
import 'dart:html';
import 'dart:io';
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
                            onPressed: logIn,
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
                            onPressed: () async {
                              final credential =
                                  await SignInWithApple.getAppleIDCredential(
                                scopes: [
                                  AppleIDAuthorizationScopes.email,
                                  AppleIDAuthorizationScopes.fullName,
                                ],
                                webAuthenticationOptions:
                                    WebAuthenticationOptions(
                                  // ignore: todo
                                  // TODO: Set the `clientId` and `redirectUri` arguments to the values you entered in the Apple Developer portal during the setup
                                  clientId: 'com.candycity.myapp2',

                                  redirectUri:
                                      // For web your redirect URI needs to be the host of the "current page",
                                      // while for Android you will be using the API server that redirects back into your app via a deep link
                                      kIsWeb
                                          ? Uri.parse(
                                              'https://gayanjayasinghe.github.io')
                                          : Uri.parse(
                                              'https://gayanjayasinghe.github.io',
                                            ),
                                ),
                                // ignore: todo
                                // TODO: Remove these if you have no need for them
                                nonce: 'example-nonce',
                                state: 'example-state',
                              );

                              print(credential);

                              // Now send the credential (especially `credential.authorizationCode`) to your server to create a session
                              // after they have been validated with Apple (see `Integration` section for more information on how to do this)

                              final signInWithAppleEndpoint = Uri(
                                scheme: 'https',
                                host: 'https://gayanjayasinghe.github.io',
                                path: '/sign_in_with_apple',
                                queryParameters: <String, String>{
                                  'code': credential.authorizationCode,
                                  if (credential.givenName != null)
                                    'firstName': credential.givenName!,
                                  if (credential.familyName != null)
                                    'lastName': credential.familyName!,
                                  'useBundleId': !kIsWeb ? 'true' : 'false',
                                  if (credential.state != null)
                                    'state': credential.state!,
                                },
                              );

                              final session = await http.Client().post(
                                signInWithAppleEndpoint,
                              );

                              // If we got this far, a session based on the Apple ID credential has been created in your system,
                              // and you can now set this as the app's session
                              // ignore: avoid_print
                              print(session);
                            },
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
