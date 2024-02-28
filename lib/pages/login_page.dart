import 'package:expense/components/login_components/login_form_widget.dart';
import 'package:expense/components/login_components/login_header.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailTextField = TextEditingController();
  TextEditingController _otpTextField = TextEditingController();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initialize controllers here
    _emailTextField = TextEditingController();
    _otpTextField = TextEditingController();
  }
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
          Colors.white,
          Colors.white,
        ])
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 100, left: 30, right: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // -- section 1 --
                LoginHeaderWidget(size),
                // -- end --
              
                // -- section 2 --
                loginFormWidget(_emailTextField, _formKey, context),
              
              ],
            ),
          ),
        ),
      ),
    );
  }
}