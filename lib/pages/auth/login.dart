// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_app/utils/config/config.dart';
import 'package:provider/provider.dart';

import '../../../widgets/cstm_textfield.dart';
import '../../models/user_model.dart';
import '../../providers/currentuser_provider.dart';
import '../../providers/loading.dart';
import '../../widgets/cstm_button.dart';
import '../../widgets/cstm_loginswitcher.dart';
import 'package:http/http.dart' as http;

import '../../widgets/cstm_snackbar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> loginUser() async {
    context.read<IsLoadingData>().setIsLoading(true);
    var regBody = {
      'email': _emailController.text.trim(),
      'password': _passwordController.text.trim(),
    };
    try {
      final response = await http.post(Uri.parse(login),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(regBody));
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['success']) {
        UserModel userInfo = UserModel.fromJson(jsonResponse['data']);
        context.read<CurrentUser>().setUser(userInfo);
        context.read<CurrentUser>().setToken(jsonResponse['token']);
        Navigator.pushNamed(context, '/navigator');
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Login',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Form(
              key: _loginFormKey,
              child: Column(
                children: [
                  CstmTextField(
                    mainController: _emailController,
                    text: 'Email Address',
                    inputType: TextInputType.emailAddress,
                  ),
                  CstmTextField(
                    mainController: _passwordController,
                    text: 'Password',
                    inputType: TextInputType.visiblePassword,
                  ),
                  CstmButton(
                    text: 'Log In',
                    onPressed: () => loginUser(),
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
                    preText: 'New Here?',
                    onpressed: () {
                      Navigator.pushReplacementNamed(context, '/register');
                    },
                    suffText: 'Sign Up',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
