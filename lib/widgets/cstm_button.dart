import 'package:flutter/material.dart';

class CstmButton extends StatelessWidget {
  final Widget? leadingIcon;
  final String text;
  final Color? textColor;
  final Color? btnColor;
  final VoidCallback? onPressed;

  const CstmButton({
    super.key,
    this.leadingIcon,
    required this.text,
    this.textColor,
    this.btnColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: btnColor ?? Theme.of(context).colorScheme.tertiary,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              text,
              style: TextStyle(
                color: textColor ?? Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            leadingIcon ?? const SizedBox(),
          ],
        ),
      ),
    );
  }
}
