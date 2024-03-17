import 'dart:convert';
import 'package:http/http.dart' as http;

final serverUrl = 'http://192.168.100.117:5001/get_order_book';

Future<List<String>> getOrderBook() async {
  final requestBody = {
    'api_key': 'mBqeJfcE',
    'username': 'p179398',
    'pin': '3171',
    'totp': '3JMG36SOWRRIJGYLC35J5ICMOI',
  };

  final response = await http.post(
    Uri.parse(serverUrl),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(requestBody),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as List;
    
    List<String> result = [];
    
    for (var item in data) {
      String tradingSymbol = item['tradingsymbol'];
      String price = item['price'].toString();
      result.add('Trading Symbol: $tradingSymbol, Price: $price');
    }

    return result;
  } else {
    throw Exception('HTTP Error! Status: ${response.statusCode}, Response: ${response.body}');
    // Handle the error as needed
  }
}
