import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_app/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyWalletDes extends StatefulWidget {
  const MyWalletDes({super.key});

  @override
  State<MyWalletDes> createState() => _MyWalletDesState();
}

connectToMeta(BuildContext context) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => const HomePage()));
}

connectToWallet(BuildContext context) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => const HomePage()));
}

class _MyWalletDesState extends State<MyWalletDes> {
  final user = FirebaseAuth.instance.currentUser!;
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
                const Text('Wallet Details',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 36,
                      fontFamily: 'LilyScriptOne',
                      color: Colors.white,
                    )),
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
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text('User ID : ${user.uid}'),
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
                                          labelText: "  Enter Amount",
                                          //hintText: "whatever you want",
                                          //icon: Icon(Icons.money)
                                        ))),
                              ),
                              const SizedBox(height: 30),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 25.0),
                                child: Text(
                                    'Games Tokens You Have : USD.100,000,00'),
                              ),
                              const SizedBox(height: 100),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ButtonTheme(
                                      minWidth: 100,
                                      child: OutlinedButton(
                                        onPressed: () => connectToMeta(context),
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
                                        onPressed: () =>
                                            connectToWallet(context),
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
