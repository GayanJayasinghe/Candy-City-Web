import 'dart:ui';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_app/RealtimeDatabase.dart';
import 'package:my_app/Web3Connection.dart';
import 'package:my_app/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyWalletDes extends StatelessWidget {
  MyWalletDes({super.key, required this.tokens, required this.userID});

  var tokens;
  final String userID;
  final amountController = TextEditingController();

  deposit(BuildContext context) async {
    if (amountController.text.isNotEmpty) {
      var amount = BigInt.parse(amountController.text);
      print(amount);
      await Web3Connection.depositFund(amount);
      tokens = await RealtimeDatabase.read('items/token');
      print(tokens);
    }
  }

  withdraw(BuildContext context) {
    if (amountController.text.isNotEmpty) {
      var amount = int.parse(amountController.text);
      print(amount);
      Web3Connection.withdrawFund(amountController.text);
    }
  }

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
                                          controller: amountController,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            // for below version 2 use this
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9]')),
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          decoration: const InputDecoration(
                                            labelText:
                                                "Enter amount to deposit or withdraw",
                                          ))),
                                ),
                                const SizedBox(height: 30),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0),
                                  child: Text(
                                      'In Candy City you have : $tokens CANDY'),
                                ),
                                const SizedBox(height: 15),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 0.0),
                                          child: GestureDetector(
                                              onTap: () => deposit(context),
                                              child: Stack(
                                                  alignment: Alignment.center,
                                                  children: <Widget>[
                                                    Image.asset(
                                                      'images/Button1.png',
                                                      height: 80,
                                                      width: 150,
                                                    ),
                                                    const Text(
                                                      'Deposit',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                        //fontFamily: 'LilyScriptOne',
                                                      ),
                                                    ),
                                                  ]))),
                                      const SizedBox(width: 20),
                                      Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 0.0),
                                          child: GestureDetector(
                                              onTap: () => withdraw(context),
                                              child: Stack(
                                                  alignment: Alignment.center,
                                                  children: <Widget>[
                                                    Image.asset(
                                                      'images/Button.png',
                                                      height: 80,
                                                      width: 150,
                                                    ),
                                                    const Text(
                                                      'Withdraw',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                        //fontFamily: 'LilyScriptOne',
                                                      ),
                                                    ),
                                                  ]))),
                                    ]),
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
