import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InvestmentsPage extends StatefulWidget {
  @override
  _InvestmentsPageState createState() => _InvestmentsPageState();
}

class _InvestmentsPageState extends State<InvestmentsPage> {
  Future<List<Map<String, dynamic>>> getOrderBook() async {
    final url =
        'http://192.168.1.100:5001/get_order_book'; // Update with your server address
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'api_key': 'mBqeJfcE',
      'username': 'p179398',
      'pin': '3171',
      'totp': '3JMG36SOWRRIJGYLC35J5ICMOI',
    });

    final response =
        await http.post(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> orderBookData = data['OrderBook'];
      return orderBookData.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load order book');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Investments'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getOrderBook(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final item = snapshot.data![index];
                return ListTile(
                  contentPadding: EdgeInsets.all(10),
                  title: Text(
                    item['tradingsymbol'],
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    'Price: ${item['price']}',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,

                    ),
                  ),
                  trailing: Text(
                    'Qty: ${item['quantity']}',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: InvestmentsPage(),
  ));
}
