import 'package:expense/pages/otp_verification.dart';
import 'package:expense/services/req_otp.dart';
import 'package:flutter/material.dart';

Form loginFormWidget(TextEditingController _emailTextField,
    GlobalKey<FormState> _formKey, BuildContext context) {
  return Form(
      key: _formKey,
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              TextFormField(
                controller: _emailTextField,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person_outline_outlined),
                    labelText: "Email",
                    hintText: "abc@gmail.com",
                    border: OutlineInputBorder()),
                // keyboardType: TextInputType.emailAddress, // Set the keyboard type for email
                validator: (value) {
                  // Add email validation logic if needed
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        String userEmail = _emailTextField.text;
                        requestOtp(userEmail);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OtpVerification(
                                      userEmail: userEmail,
                                    )));
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    child: Text(
                      "Request Otp",
                      style: TextStyle(
                        fontFamily: 'Poppins',

                        color: Colors.white),
                    )),
              ),
            ],
          )));
}
