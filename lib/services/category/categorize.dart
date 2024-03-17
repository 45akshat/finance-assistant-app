import 'dart:convert';
import 'package:http/http.dart' as http;

final serverUrl = 'http://192.168.100.117:5002/predict-industry';  // Update the URL

Future<String> predictIndustry(String companyName) async {
  final requestBody = {
    'company_name': companyName,
  };

  final response = await http.post(
    Uri.parse(serverUrl),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(requestBody),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    String predictedIndustry = data['predicted_industry'];
    return predictedIndustry;
  } else {
    throw Exception('HTTP Error! Status: ${response.statusCode}, Response: ${response.body}');
    // Handle the error as needed
  }
}
