import 'dart:convert';
import 'dart:html';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_web3/flutter_web3.dart';
import 'package:my_app/RealtimeDatabase.dart';
import 'package:my_app/WalletConnectionObj.dart';

class Web3Connection {
  static const _abi = [
    {
      "inputs": [
        {"internalType": "uint256", "name": "amount_", "type": "uint256"}
      ],
      "name": "deposit",
      "outputs": [],
      "stateMutability": "payable",
      "type": "function"
    },
    {
      "inputs": [
        {"internalType": "uint256", "name": "amount", "type": "uint256"},
        {"internalType": "uint256", "name": "time", "type": "uint256"},
        {"internalType": "bytes", "name": "sign", "type": "bytes"}
      ],
      "name": "withdraw",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {"stateMutability": "payable", "type": "receive"},
    {
      "inputs": [],
      "name": "depositFee",
      "outputs": [
        {"internalType": "uint256", "name": "", "type": "uint256"}
      ],
      "stateMutability": "view",
      "type": "function"
    }
  ];

  static const _erc20Abi = [
    {
      "constant": false,
      "inputs": [
        {"name": "_spender", "type": "address"},
        {"name": "_value", "type": "uint256"}
      ],
      "name": "approve",
      "outputs": [
        {"name": "", "type": "bool"}
      ],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "constant": true,
      "inputs": [
        {"name": "_owner", "type": "address"},
        {"name": "_spender", "type": "address"}
      ],
      "name": "allowance",
      "outputs": [
        {"name": "", "type": "uint256"}
      ],
      "payable": false,
      "stateMutability": "view",
      "type": "function"
    },
  ];

  static const _tokenContractAddress =
      '0x06C04B0AD236e7Ca3B3189b1d049FE80109C7977';
  static const _gameContractAddress =
      '0x61dd8354917c92f986BA81f2222Ac033A4Bb1521';
  static const _privateKey =
      '2e44e14c394a5868fb8902462cfdd0b755ba11118fb15ab6de9f70e8f7174e73';

  static List<String>? _accounts;
  static String _gameABIJson = '';
  static String _tokenABIJson = '';
  static Web3Provider? _web3provider;
  static Contract? _gameContract;
  static Contract? _tokenContract;

  static _resetWallets() {
    _accounts = null;
    _web3provider = null;
    _gameContract = null;
    _tokenContract = null;
  }

  static Future<dynamic> connectToWalletConnect(
      Function(String, bool) action) async {
    try {
      _resetWallets();
      WalletConnectProvider walletConnectProvider =
          WalletConnectProvider.fromInfura("9aa3d95b3bc440fa88ea12eaa4456161");
      await walletConnectProvider.connect();
      var walletconnectJson = window.localStorage['walletconnect'];
      var walletconnectObj = jsonDecode(walletconnectJson!);
      List<dynamic> accountsList = walletconnectObj['accounts'];
      print('Account address : $accountsList');
      _accounts = [];
      accountsList.forEach((element) {
        _accounts!.add(element);
      });

      _web3provider = Web3Provider.fromWalletConnect(walletConnectProvider);
      action('Connected', true);
    } catch (e) {
      print('User rejected the modal ' + e.toString());
      action(e.toString(), false);
    }
  }

  static Future<dynamic> connectToMetaMaskWallet(
      Function(String, bool) action) async {
    if (ethereum != null) {
      try {
        _resetWallets();
        print('Connecting MetaMask wallet...');
        _web3provider = Web3Provider(ethereum!);
        _accounts = await ethereum!.requestAccount();

        for (var element in _accounts!) {
          print('Account address : $element');
        }
        action('Connected', true);
      } on EthereumUserRejected {
        print('User rejected the modal');
        action('User rejected the modal', false);
      }
    } else {
      print('Your browser does not support!');
      action('Your browser does not support!', false);
    }
  }

  static _getSigner() {
    return _web3provider!.getSigner();
  }

  static _getGameABI() {
    if (_gameABIJson.isEmpty) {
      _gameABIJson = jsonEncode(_abi);
    }
    return _gameABIJson;
  }

  static _getTokenABI() {
    if (_tokenABIJson.isEmpty) {
      _tokenABIJson = jsonEncode(_erc20Abi);
    }
    return _tokenABIJson;
  }

  static _getGameContract() {
    _gameContract ??= Contract(
      _gameContractAddress,
      Interface(_getGameABI()),
      _getSigner(),
    );
    return _gameContract;
  }

  static _getTokenContract() {
    _tokenContract ??= Contract(
      _tokenContractAddress,
      Interface(_getTokenABI()),
      _getSigner(),
    );
    return _tokenContract;
  }

  static Future<dynamic> _approveFundDeposit(BigInt value) async {
    //var val = BigInt.from(1000000000000000);

    final gas = await _web3provider!.getSigner().estimateGas(TransactionRequest(
        to: _gameContractAddress, from: _accounts![0], value: value));

    print('Gas price ' + gas.toString());

    var gasPrice = gas * BigInt.from(13) / BigInt.from(10);
    final results = await _getTokenContract().send('approve', [
      _gameContractAddress,
      value,
      {'gasLimit': gasPrice}
    ]);

    final receipt = await results.wait();
    print(receipt);
    return receipt;
  }

  static Future<dynamic> depositFund(
      BigInt amount, BuildContext context) async {
    try {
      BigInt amountD = amount * BigInt.parse('1000000000000000000');
      await _approveFundDeposit(amountD);
      final gas = await _web3provider!.getSigner().estimateGas(
          TransactionRequest(
              to: _gameContractAddress, from: _accounts![0], value: amountD));

      var gasPrice = gas * BigInt.from(13) / BigInt.from(10);

      final results = await _getGameContract().send('deposit', [
        amountD,
        {'gasLimit': gasPrice}
      ]);

      final receipt = await results.wait(); // Wait until transaction complete
      var tokensAmount =
          await RealtimeDatabase.read('items/token') + amount.toInt();
      print(tokensAmount);
      RealtimeDatabase.write('items/token', tokensAmount);
      print(receipt);
      AwesomeDialog(
              context: context,
              headerAnimationLoop: false,
              dialogType: DialogType.noHeader,
              title: 'Well done',
              width: 500,
              titleTextStyle: const TextStyle(
                fontSize: 32,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600,
                fontFamily: 'LilyScriptOne',
              ),
              desc:
                  'Fund has been deposited from ${_accounts![0]} successfully',
              btnOkOnPress: () {
                debugPrint('OnClcik');
              },
              btnOkColor: Colors.green,
              btnOkText: 'Close')
          .show();
    } catch (e) {
      AwesomeDialog(
              context: context,
              headerAnimationLoop: false,
              dialogType: DialogType.noHeader,
              title: 'Error',
              width: 500,
              titleTextStyle: const TextStyle(
                fontSize: 32,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600,
                fontFamily: 'LilyScriptOne',
              ),
              desc: e.toString(),
              btnOkOnPress: () {
                debugPrint('OnClcik');
              },
              btnOkColor: Colors.pink,
              btnOkText: 'Close')
          .show();
    }
  }

  static Future<dynamic> withdrawFund(
      String amount, BuildContext context) async {
    try {
      var time = DateTime.now().millisecondsSinceEpoch;

      final anotherWallet = Wallet(_privateKey);

      BigInt amountD =
          BigInt.parse(amount) * BigInt.parse('1000000000000000000');
      print(anotherWallet.address);
      print('_accounts');
      print(_accounts![0]);
      print('EthUtils');
      print(EthUtils);

      var dig = EthUtils.solidityKeccak256(['address', 'uint256', 'uint256'],
          [_accounts![0], time, BigNumber.from(amountD.toString())]);
      //var signature = await getSigner().signMessage(msg);
      var signature2 = await anotherWallet.signMessage(EthUtils.arrayify(dig));

      print('_web3provider');
      print(_web3provider);
      print('_gameContractAddress');
      print(_gameContractAddress);

      print(_getGameContract());
      final gas = await _web3provider!.getSigner().estimateGas(
          TransactionRequest(
              to: _gameContractAddress, from: _accounts![0], value: amountD));

      var gasPrice = gas * BigInt.from(13) / BigInt.from(10);

      final tx = await _getGameContract().send('withdraw', [
        amountD,
        time,
        signature2,
        {'gasLimit': gasPrice}
      ]);

      final receipt = tx.wait(); // Wait until transaction complete
      print(receipt);

      var tokensAmount =
          await RealtimeDatabase.read('items/token') - int.parse(amount);
      print(tokensAmount);
      RealtimeDatabase.write('items/token', tokensAmount);

      AwesomeDialog(
              context: context,
              headerAnimationLoop: false,
              dialogType: DialogType.noHeader,
              title: 'Well done',
              width: 500,
              titleTextStyle: const TextStyle(
                fontSize: 32,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600,
                fontFamily: 'LilyScriptOne',
              ),
              desc: 'Fund has been withdrawn to ${_accounts![0]} successfully',
              btnOkOnPress: () {
                debugPrint('OnClcik');
              },
              btnOkColor: Colors.green,
              btnOkText: 'Close')
          .show();
    } catch (e) {
      AwesomeDialog(
              context: context,
              headerAnimationLoop: false,
              dialogType: DialogType.noHeader,
              title: 'Error',
              width: 500,
              titleTextStyle: const TextStyle(
                fontSize: 32,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600,
                fontFamily: 'LilyScriptOne',
              ),
              desc: e.toString(),
              btnOkOnPress: () {
                debugPrint('OnClcik');
              },
              btnOkColor: Colors.pink,
              btnOkText: 'Close')
          .show();
    }
  }
}
