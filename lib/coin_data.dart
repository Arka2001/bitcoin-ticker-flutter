import 'dart:convert';
import 'package:http/http.dart' as http;

const apikey = 'B50DFD84-28E3-408F-8D96-6395170A8A13';
const url = 'https://rest.coinapi.io/v1/exchangerate';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {

  Future getData (String currency) async{
    Map<String,String> priceList= {};
    for(String crypto in cryptoList) {
      String requestURL = '$url/$crypto/$currency?apikey=$apikey';
      http.Response apiResponse = await http.get(requestURL);

      if(apiResponse.statusCode==200){
        var data = jsonDecode(apiResponse.body);
        double price = data['rate'];
        priceList[crypto] = price.toStringAsFixed(0);
      }else{
        print(apiResponse.statusCode);
        throw 'Problem with the get request';
      }
    }

    return priceList;
  }
}
