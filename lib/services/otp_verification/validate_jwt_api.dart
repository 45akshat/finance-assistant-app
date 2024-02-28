import 'dart:convert';

import 'package:http/http.dart' as http;

// Replace 'YOUR_LAMBDA_URL' with the actual URL of your deployed Lambda function
const lambdaUrl = 'https://ov7pyyprrfdw42lqckiy34umga0vmvol.lambda-url.ap-south-1.on.aws/';

// Function to make the API request
Future<String> ValidateJwtApi(String recipientEmail, String token) async {
  try {
    final apiUrl = Uri.parse('$lambdaUrl?email=${Uri.encodeComponent(recipientEmail)}&token=${Uri.encodeComponent(token)}');

    // Make a GET request to the Lambda function
    final response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      // Successful response
      return response.body; // Return the response here
    } else {
      // Handle error response
      print('HTTP error! Status: ${response.statusCode}');
      var failureMsg = jsonEncode({'message': "Failed"});
      return failureMsg;
    }
  } catch (error) {
    // Handle general error
    print('Error: $error');
    throw Exception('Error: $error');
  }
}

