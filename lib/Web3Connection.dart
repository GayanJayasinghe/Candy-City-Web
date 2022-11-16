import 'dart:convert';
import 'dart:html';

import 'package:flutter_web3/flutter_web3.dart';
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
  static const _privateKey = '2e44e14c394a5868fb8902462cfdd0b755ba11118fb15ab6de9f70e8f7174e73';

  List<String>? _accounts;
  String _gameABIJson = '';
  String _tokenABIJson = '';
  Web3Provider? _web3provider;
  Contract? _gameContract;
  Contract? _tokenContract;

  Web3Connection(){
    connectToMetaMaskWallet();
  }

  Future<dynamic> connectToWalletConnect() async {
    try {
      WalletConnectProvider walletConnectProvider =  WalletConnectProvider.fromInfura("9aa3d95b3bc440fa88ea12eaa4456161");
      await walletConnectProvider.connect();
      var walletconnectJson = window.localStorage['walletconnect'];
      var walletconnectObj = jsonDecode(walletconnectJson!);
      String accountsList = walletconnectObj['accounts'][0];
      print('Account address : $accountsList');
      _web3provider = Web3Provider.fromWalletConnect(walletConnectProvider);
    } catch (e) {
      print('User rejected the modal ' + e.toString());
    }
  }

  Future<dynamic> connectToMetaMaskWallet() async {
    if (ethereum != null) {
      try {
        print('Connecting MetaMask wallet...');
        _web3provider = Web3Provider(ethereum!);
        _accounts = await ethereum!.requestAccount();

        for (var element in _accounts!) {
          print('Account address : $element');
        }
      } on EthereumUserRejected {
        print('User rejected the modal');
      }
    } else {
      print('Your browser does not support!');
    }
  }

  getSigner() {
    return _web3provider!.getSigner();
  }

  getTokenWalletSigner() {
    return _web3provider!.getSigner();
  }

  getGameABI() {
    if (_gameABIJson.isEmpty) {
      _gameABIJson = jsonEncode(_abi);
    }
    return _gameABIJson;
  }

  getTokenABI() {
    if (_tokenABIJson.isEmpty) {
      _tokenABIJson = jsonEncode(_erc20Abi);
    }
    return _tokenABIJson;
  }

  getGameContract() {
    _gameContract ??= Contract(
      _gameContractAddress,
      Interface(getGameABI()),
      getSigner(),
    );
    return _gameContract;
  }

  getTokenContract() {
    _tokenContract ??= Contract(
      _tokenContractAddress,
      Interface(getTokenABI()),
      getSigner(),
    );
    return _tokenContract;
  }

  Future<dynamic> approveFundDeposit(int value) async {

    var val = BigInt.from(1000000000000000);

   final gas = await _web3provider!.getSigner().estimateGas(TransactionRequest(
      to:_gameContractAddress, from: _accounts![0],value : val
    ));

   print('Gas price ' + gas.toString());

   var gasPrice = gas * BigInt.from(13) / BigInt.from(10);
    final results =
        await getTokenContract().send('approve', [_gameContractAddress, val, {
        'gasLimit': gasPrice}]);

    final receipt = await results.wait();
    print(receipt);
    return receipt;
  }

  Future<dynamic> depositFund(int amount) async {
    await approveFundDeposit(amount);
    final gas = await _web3provider!.getSigner().estimateGas(TransactionRequest(
        to:_gameContractAddress, from: _accounts![0],value : BigInt.from(amount)
    ));

    var gasPrice = gas * BigInt.from(13) / BigInt.from(10);

    final results = await getGameContract().send('deposit', [amount, {
      'gasLimit': gasPrice}]);

    final receipt = await results.wait(); // Wait until transaction complete
    print(receipt);
  }

  Future<dynamic> withdrawFund(int amount) async {
    var time = DateTime.now().millisecondsSinceEpoch;

    final anotherWallet = Wallet(_privateKey);

    print(anotherWallet.address);
    var dig = EthUtils.solidityKeccak256(['address', 'uint256', 'uint256'], [_accounts![0], time, amount]);
    //var signature = await getSigner().signMessage(msg);
    var signature2 = await anotherWallet.signMessage(EthUtils.arrayify(dig));

    final gas = await _web3provider!.getSigner().estimateGas(TransactionRequest(
        to:_gameContractAddress, from: _accounts![0],value : BigInt.from(amount)
    ));

    var gasPrice = gas * BigInt.from(13) / BigInt.from(10);

    final tx = await getGameContract().send('withdraw',[amount, time, signature2, {
      'gasLimit': gasPrice}]);

    final receipt = tx.wait(); // Wait until transaction complete
    print(receipt);
  }
}
