import 'package:http/http.dart' as http;

// Replace 'YOUR_LAMBDA_URL' with the actual URL of your deployed Lambda function
const lambdaUrl = 'https://lbqn3amkemogpqcxzqnbvmlqsm0knjff.lambda-url.ap-south-1.on.aws/';

// Replace 'RECIPIENT_EMAIL' with the email address you want to send the email to
// const recipientEmail = 'akshatparmar78543@gmail.com';

// Construct the URL with the query string parameter

// Function to make the API request
Future<void> requestOtp(String recipientEmail) async {
  try {
    final apiUrl = Uri.parse('$lambdaUrl?email=${Uri.encodeComponent(recipientEmail)}');

    // Make a GET request to the Lambda function
    final response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      // Successful response
      print('Lambda Response: ${response.body}');
    } else {
      // Handle error response
      print('HTTP error! Status: ${response.statusCode}');
    }
  } catch (error) {
    // Handle general error
    print('Error: $error');
  }
}

// Function to be called when the "Request OTP" button is clicked
void onButtonClicked(String recipientEmail) {
  requestOtp(recipientEmail);
}

// Usage in your Flutter code
// ElevatedButton(
//   onPressed: onButtonClicked,
//   child: Text("Request OTP"),
// ),
