import 'dart:convert';

import 'package:expense/pages/home_page.dart';
import 'package:expense/services/otp_verification/user_info_save_locally.dart';
import 'package:expense/services/verify_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class OtpVerification extends StatefulWidget {
  final String userEmail;

 const OtpVerification({Key? key, required this.userEmail}) : super(key: key);

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  String _otpEntered = ""; 


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("OTP", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            const Text("OTP has been sent to your Email", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            OtpTextField(
              onSubmit: (code){
                _otpEntered = code;
              },
              numberOfFields: 6,
              fillColor:  Colors.black.withOpacity(0.1),
              filled: true,
            ),
            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: ()async{
                if(_otpEntered.isEmpty || _otpEntered != ""){
                  var response = await VerifyOtpApi(widget.userEmail, _otpEntered);
                  print(json.decode(response));
                  var resJson = json.decode(response);
                  // use this and redirect user to Home Page and restrict back access.
                  if(resJson['message'] == "OTP verified successfully!"){

                    saveJwtToken(resJson['token']);

                    saveKeyLocally("email", widget.userEmail);

                      // Navigate to the home screen and clear the navigation history
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const HomePage()),
                        (route) => false,
                      );
                  }else{
                    print("RETRY");
                  }
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              child: const Text("Next", style: TextStyle(color: Colors.white),),
            )
            )
          
          ],
        ),
      ),
    );
  }
}