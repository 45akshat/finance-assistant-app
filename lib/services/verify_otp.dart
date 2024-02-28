import 'dart:convert';

import 'package:http/http.dart' as http;

// Replace 'YOUR_LAMBDA_URL' with the actual URL of your deployed Lambda function
const lambdaUrl = 'https://gaqjyqhexaqsegidaoxm3dwx4i0blxwx.lambda-url.ap-south-1.on.aws/';

// Replace 'RECIPIENT_EMAIL' with the email address you want to send the email to
// const recipientEmail = 'akshatparmar78543@gmail.com';

// Construct the URL with the query string parameter

// Function to make the API request
Future<String> VerifyOtpApi(String recipientEmail, String _otpEntered) async {
  try {
    final apiUrl = Uri.parse('$lambdaUrl?email=${Uri.encodeComponent(recipientEmail)}&otp=${Uri.encodeComponent(_otpEntered)}');

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

