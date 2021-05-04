import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {

  CoinData coinData = CoinData();

  String selectedCurrency = 'AUD';
  Map<String,String> coinValue = {};
  bool isWaiting = false;

  void getData() async{
    isWaiting = true;

    try{
      var data = await CoinData().getData(selectedCurrency);

      isWaiting = false;
      setState(() {
        coinValue = data;
      });
    }
    catch(e){
      print(e);
    }
  }


  /*void updateUI(dynamic coinData){
    if(coinData==null){
      rate = 0;
    }
    else{
      rate = coinData["rate"].truncate();
    }
  }*/

  DropdownButton getAndroidDropdownButton(){
    List<DropdownMenuItem<String>> currencyMenu = [];
    for(String i in currenciesList){
      var newItem = DropdownMenuItem(
        child: Text(i),
        value: i,
      );
      currencyMenu.add(newItem);
    }

    return DropdownButton(
      value: selectedCurrency,
      items: currencyMenu,
      onChanged: (value){
        setState(() {
          selectedCurrency = value;
          getData();
        });
      },
    );
  }

  CupertinoPicker getIOSPicker(){
    List<Widget> currencyList = [];

    for(String i in currenciesList){
      currencyList.add(Text(i, style: TextStyle(color: Colors.white),));
    }

   return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex){
        setState(() {
          selectedCurrency = currencyList[selectedIndex].toString();
          getData();
        });
      },
      children: currencyList,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    //updateUI(data);
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CryptoCard(
              crypto: 'BTC',
              rate: isWaiting == true ? '?': coinValue['BTC'],
              currency: selectedCurrency
          ),
          CryptoCard(
              crypto: 'ETH',
              rate: isWaiting == true ? '?': coinValue['ETH'],
              currency: selectedCurrency
          ),
          CryptoCard(
              crypto: 'LTC',
              rate: isWaiting == true ? '?': coinValue['LTC'],
              currency: selectedCurrency
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? getIOSPicker() : getAndroidDropdownButton(),
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {

  CryptoCard({@required this.crypto, @required this.rate, @required this.currency});

  final String crypto;
  final String currency;
  final String rate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $crypto = $rate $currency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
