import 'package:flutter/material.dart';

class CstmTextField extends StatefulWidget {
  final TextEditingController? mainController;
  final String text;
  final TextInputType inputType;

  const CstmTextField({
    super.key,
    this.mainController,
    required this.text,
    required this.inputType,
  });

  @override
  State<CstmTextField> createState() => _CstmTextFieldState();
}

class _CstmTextFieldState extends State<CstmTextField> {
  bool _isPassword = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isPassword = isPassword();
    });
  }

  isPassword() {
    switch (widget.inputType) {
      case TextInputType.visiblePassword:
        return true;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: widget.mainController,
        obscureText: _isPassword,
        keyboardType: widget.inputType,
        decoration: InputDecoration(
          labelText: widget.text,
          labelStyle: const TextStyle(fontSize: 15),
          filled: true,
          focusColor: Theme.of(context).colorScheme.tertiary,
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.tertiary),
            borderRadius: BorderRadius.circular(20),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: const EdgeInsets.all(13),
          suffixIcon: isPassword()
              ? PassHider(
                  obscureCheck: _isPassword,
                  onToggle: () {
                    setState(() {
                      _isPassword = !_isPassword;
                    });
                  },
                )
              : null,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter ${widget.text}';
          }
          if (widget.text == 'Email Address' &&
              !RegExp(r'\S+@\S+\.\S+').hasMatch(widget.mainController!.text)) {
            return 'Invalid Email.';
          }
          if (widget.text == 'Password' &&
              widget.mainController!.text.length < 6) {
            return 'Password cannot be less than 6 characters.';
          }
          return null;
        },
      ),
    );
  }
}

class PassHider extends StatelessWidget {
  final bool obscureCheck;
  final VoidCallback onToggle;

  const PassHider({
    super.key,
    required this.obscureCheck,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashRadius: 20,
      icon: Icon(
        obscureCheck
            ? Icons.visibility_off_outlined
            : Icons.visibility_outlined,
      ),
      onPressed: onToggle,
    );
  }
}
