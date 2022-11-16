import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const SizedBox(
                height: 75,
              ),
              //Hello again!
              const Text('Hello Again!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 36,
                    fontFamily: 'LilyScriptOne',
                  )),
              const SizedBox(height: 10),
              const Text('Welcome back, you\'ve been missed!',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'LilyScriptOne',
                  )),
              const SizedBox(height: 50),

              //email textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: SizedBox(
                  width: 450,
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(FontAwesomeIcons.cartPlus),
                      hintText: 'Email',
                      fillColor: Colors.blue[200],
                      filled: true,
                      border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(50)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              //password textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: SizedBox(
                  width: 450,
                  child: TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock),
                      hintText: 'Password',
                      fillColor: Colors.blue[200],
                      filled: true,
                      border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(50)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: GestureDetector(
                      onTap: signIn,
                      child:
                          Stack(alignment: Alignment.center, children: <Widget>[
                        Image.asset(
                          'images/Button.png',
                          height: 240,
                          width: 300,
                        ),
                        const Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'LilyScriptOne',
                          ),
                        ),
                      ]))),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Or sign in with',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.lightBlue,
                      fontFamily: 'LilyScriptOne',
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 25,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SignInButton(
                    Buttons.Facebook,
                    mini: true,
                    onPressed: signInWithFacebook,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  SignInButton(
                    Buttons.Apple,
                    mini: true,
                    onPressed: signInWithApple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  )
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }
}
