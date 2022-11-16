import 'package:flutter/material.dart';
import 'package:my_app/wallet_description.dart';

class MyWallet extends StatefulWidget {
  const MyWallet({super.key});

  @override
  State<MyWallet> createState() => _MyWalletState();
}

connectToMeta(BuildContext context) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => MyWalletDes()));
}

connectToWallet(BuildContext context) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => MyWalletDes()));
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
                const Text('Connect Wallet',
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
                              const SizedBox(height: 100),
                              ButtonTheme(
                                minWidth: 100,
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    elevation: 20,
                                    shadowColor: Colors.black,
                                    fixedSize: const Size.fromWidth(320),
                                  ),
                                  onPressed: () => connectToMeta(context),
                                  child: const Text('Connect To Metamask'),
                                ),
                              ),
                              const SizedBox(height: 20),
                              ButtonTheme(
                                minWidth: 100,
                                height: 200,
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    elevation: 20,
                                    shadowColor: Colors.black,
                                    fixedSize: const Size.fromWidth(320),
                                  ),
                                  onPressed: () => connectToWallet(context),
                                  child: const Text(
                                    'Connect To Wallet',
                                  ),
                                ),
                              ),
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
