import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_app/RealtimeDatabase.dart';
import 'package:my_app/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyWalletDes extends StatelessWidget {
  const MyWalletDes({super.key, required this.tokens, required this.userID});

  final tokens;
  final String userID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Card(
                        elevation: 10,
                        color: Colors.white.withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        child: SizedBox(
                          width: 460,
                          height: 320,
                          child: Center(
                              child: Column(
                            children: <Widget>[
                              const SizedBox(height: 15),
                              const Text('Wallet Details',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 36,
                                    fontFamily: 'LilyScriptOne',
                                    color: Colors.white,
                                    decoration: TextDecoration.underline,
                                  )),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text('User ID : $userID'),
                                    ]),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25.0),
                                child: SizedBox(
                                    width: 450,
                                    child: TextFormField(
                                        controller: null,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          // for below version 2 use this
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'[0-9]')),
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        decoration: const InputDecoration(
                                          labelText:
                                              "  Enter amount to deposit or withdraw",
                                          //hintText: "whatever you want",
                                          //icon: Icon(Icons.money)
                                        ))),
                              ),
                              const SizedBox(height: 30),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25.0),
                                child: Text(
                                    'In Candy City you have : $tokens CANDY'),
                              ),
                              const SizedBox(height: 55),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ButtonTheme(
                                      minWidth: 100,
                                      child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            elevation: 20,
                                            shadowColor: Colors.black,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 20, horizontal: 20)),
                                        onPressed: () => deposit(context),
                                        child: const Text(
                                          'Deposit',
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    ButtonTheme(
                                      minWidth: 100,
                                      height: 200,
                                      child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            elevation: 20,
                                            shadowColor: Colors.black,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 20, horizontal: 20)),
                                        onPressed: () => withdraw(context),
                                        child: const Text(
                                          'Withdraw',
                                        ),
                                      ),
                                    ),
                                  ]),
                            ],
                          )),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

deposit(BuildContext context) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => const HomePage()));
}

withdraw(BuildContext context) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => const HomePage()));
}
