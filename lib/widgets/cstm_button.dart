import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/loading.dart';

class CstmButton extends StatelessWidget {
  final String text;
  final Color? textColor;
  final Color? btnColor;
  final VoidCallback? onPressed;

  const CstmButton({
    super.key,
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
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: Provider.of<IsLoadingData>(context).isLoading == true
          ? null
          : onPressed,
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
                fontWeight: FontWeight.w500,
              ),
            ),
            Provider.of<IsLoadingData>(context).isLoading == true
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
