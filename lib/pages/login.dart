import 'package:flutter/material.dart';

import '../../widgets/cstm_textfield.dart';
import '../widgets/cstm_button.dart';
import '../widgets/cstm_loginswitcher.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Login',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700,
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
                    leadingIcon: const Icon(
                      Icons.login_outlined,
                      color: Colors.white,
                    ),
                    text: 'Log In',
                    onPressed: () =>
                        {Navigator.pushNamed(context, '/navigator')},
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => {
                        // Navigator.of(context).push(
                        //     animeService.createRoute(const ResetPass()))
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                  CstmLoginSwitcher(
                    preText: 'New Here?',
                    onpressed: () {},
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
