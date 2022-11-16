import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/RealtimeDatabase.dart';
import 'package:my_app/Web3Connection.dart';
import 'package:my_app/wallet_description.dart';

class MyWallet extends StatefulWidget {
  const MyWallet({super.key});

  @override
  State<MyWallet> createState() => _MyWalletState();
}

connectToMeta(BuildContext context) async {
  var tokensAmount = await RealtimeDatabase.read('items/token');
  Web3Connection.connectToMetaMaskWallet((p0, p1) => {
        if (true)
          {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => MyWalletDes(
                    tokens: tokensAmount,
                    userID: FirebaseAuth.instance.currentUser!.uid)))
          }
        else
          {print(p0)}
      });
}

connectToWallet(BuildContext context) async {
  var tokensAmount = await RealtimeDatabase.read('items/token');
  Web3Connection.connectToWalletConnect((p0, p1) => {
        if (p1)
          {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => MyWalletDes(
                    tokens: tokensAmount,
                    userID: FirebaseAuth.instance.currentUser!.uid)))
          }
        else
          {print(p0)}
      });
}

class _MyWalletState extends State<MyWallet> {
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
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
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
                                const Text('Connect Wallet',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 36,
                                      fontFamily: 'LilyScriptOne',
                                      color: Colors.white,
                                      decoration: TextDecoration.underline,
                                    )),
                                const SizedBox(height: 40),
                                SizedBox(
                                  width: 200,
                                  height: 60,
                                  child: OutlinedButton.icon(
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      elevation: 20,
                                      shadowColor: Colors.black,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 20),
                                    ),
                                    // ignore: prefer_const_constructors
                                    icon: Image.asset(
                                      'images/metamask.png',
                                      height: 30,
                                      width: 30,
                                    ),
                                    onPressed: () => connectToMeta(context),
                                    label: const Text('Metamask'),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: 200,
                                  height: 60,
                                  child: OutlinedButton.icon(
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      elevation: 20,
                                      shadowColor: Colors.black,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 34),
                                    ),
                                    onPressed: () => connectToWallet(context),
                                    icon: Image.asset(
                                      'images/wallet.png',
                                      height: 30,
                                      width: 30,
                                    ),
                                    label: const Text(
                                      'WalletConnect',
                                    ),
                                  ),
                                ),
                              ],
                            )),
                          ),
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
