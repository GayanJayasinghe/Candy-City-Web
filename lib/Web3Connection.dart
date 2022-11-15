import 'dart:convert';

import 'package:flutter_web3/flutter_web3.dart';

class Web3Connection{

  static const _abi = [
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "amount_",
          "type": "uint256"
        }
      ],
      "name": "deposit",
      "outputs": [],
      "stateMutability": "payable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "amount",
          "type": "uint256"
        },
        {
          "internalType": "uint256",
          "name": "time",
          "type": "uint256"
        },
        {
          "internalType": "bytes",
          "name": "sign",
          "type": "bytes"
        }
      ],
      "name": "withdraw",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "stateMutability": "payable",
      "type": "receive"
    },
    {
      "inputs": [],
      "name": "depositFee",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    }
  ];

  static const  _erc20Abi = [
    {
      "constant": false,
      "inputs": [
        {
          "name": "_spender",
          "type": "address"
        },
        {
          "name": "_value",
          "type": "uint256"
        }
      ],
      "name": "approve",
      "outputs": [
        {
          "name": "",
          "type": "bool"
        }
      ],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "constant": true,
      "inputs": [
        {
          "name": "_owner",
          "type": "address"
        },
        {
          "name": "_spender",
          "type": "address"
        }
      ],
      "name": "allowance",
      "outputs": [
        {
          "name": "",
          "type": "uint256"
        }
      ],
      "payable": false,
      "stateMutability": "view",
      "type": "function"
    },
  ];

  static const  _tokenContractAddress = '0x06C04B0AD236e7Ca3B3189b1d049FE80109C7977';
  static const  _gameContractAddress = '0x1b845c64c07361d13a08f479c60F72DBb4616d73';
  static const  _privateKey = '0x8C6b28B59ad9624f7BF458984c865702a2a683D8';

  List<String>? _accounts;
  String _gameABIJson = '';
  String _tokenABIJson = '';
  final Web3Provider _web3provider = Web3Provider(ethereum!);
  Contract? _gameContract;
  Contract? _tokenContract;

  Future<dynamic> connectToWallet() async {
    if (ethereum != null) {
      try {
        print('Connecting wallet...');
        _accounts = await ethereum!.requestAccount();
        for (var element in _accounts!) { print('Account address : $element');}
      } on EthereumUserRejected {
        print('User rejected the modal');
      }
    } else{
      print('Your browser does not support!');
    }
  }

  getSigner(){
    return _web3provider!.getSigner();
  }

  getTokenWalletSigner(){
    return _web3provider!.getSigner();
  }

  getGameABI(){
    if(_gameABIJson.isEmpty)
    {
      _gameABIJson = jsonEncode(_abi);
    }
    return _gameABIJson;
  }

  getTokenABI(){
    if(_tokenABIJson.isEmpty)
    {
      _tokenABIJson = jsonEncode(_erc20Abi);
    }
    return _tokenABIJson;
  }

  getGameContract(){
    _gameContract ??= Contract(
        _gameContractAddress,
        Interface(getGameABI()),
        getSigner(),
      );
    return _gameContract;
  }

  getTokenContract(){
    _tokenContract ??= Contract(
      _tokenContractAddress,
      Interface(getTokenABI()),
      getSigner(),
    );
    return _tokenContract;
  }

  Future<dynamic> approveFundDeposit(int value) async {
    await connectToWallet();
    final results = await getTokenContract().send('approve',[_gameContractAddress, 1]);
    final receipt = await results.wait();
    print(receipt);
    return receipt;
  }

  Future<dynamic> depositFund(int amount) async {
    await approveFundDeposit(amount);
    final results = await getGameContract().send('deposit',[amount]);

    final receipt = await results.wait(); // Wait until transaction complete
    print(receipt);
  }
}
