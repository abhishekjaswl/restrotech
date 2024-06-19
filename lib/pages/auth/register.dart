// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_app/utils/config/config.dart';
import 'package:provider/provider.dart';
import '../../../widgets/cstm_textfield.dart';
import '../../providers/loading.dart';
import '../../widgets/cstm_button.dart';
import '../../widgets/cstm_loginswitcher.dart';
import 'package:http/http.dart' as http;

import '../../widgets/cstm_snackbar.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _registerFormKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> registerUser() async {
    if (!_registerFormKey.currentState!.validate()) return;

    context.read<IsLoadingData>().setIsLoading(true);
    var regBody = {
      'name': _fullNameController.text.trim(),
      'email': _emailController.text.trim(),
      'phoneNumber': _phoneController.text.trim(),
      'address': _addressController.text.trim(),
      'password': _passwordController.text.trim(),
    };
    try {
      final response = await http.post(
        Uri.parse(register),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(regBody),
      );
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['success']) {
        Navigator.pushNamed(context, '/login');
        ScaffoldMessenger.of(context).showSnackBar(
          CstmSnackBar(
            text: jsonResponse['message'],
            type: 'success',
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          CstmSnackBar(
            text: jsonResponse['message'],
            type: 'error',
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        CstmSnackBar(
          text: e.toString(),
          type: 'error',
        ),
      );
    } finally {
      context.read<IsLoadingData>().setIsLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCDBAE),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 150),
              const Text(
                'Register',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              Form(
                key: _registerFormKey,
                child: Column(
                  children: [
                    CstmTextField(
                      mainController: _fullNameController,
                      text: 'Full Name',
                      inputType: TextInputType.name,
                    ),
                    CstmTextField(
                      mainController: _emailController,
                      text: 'Email Address',
                      inputType: TextInputType.emailAddress,
                    ),
                    CstmTextField(
                      mainController: _phoneController,
                      text: 'Phone Number',
                      inputType: TextInputType.phone,
                    ),
                    CstmTextField(
                      mainController: _addressController,
                      text: 'Address',
                      inputType: TextInputType.streetAddress,
                    ),
                    CstmTextField(
                      mainController: _passwordController,
                      text: 'Password',
                      inputType: TextInputType.visiblePassword,
                    ),
                    CstmButton(
                      text: 'Register',
                      onPressed: () => registerUser(),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => {},
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.black,
                              color: Colors.black),
                        ),
                      ),
                    ),
                    CstmLoginSwitcher(
                      preText: 'Already Have an Account?',
                      onpressed: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      suffText: 'Login',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
