import 'package:flutter/material.dart';

class CstmSnackBar extends SnackBar {
  CstmSnackBar({
    super.key,
    required String text,
    required String type,
  }) : super(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                type == 'error'
                    ? Icons.report
                    : type == 'success'
                        ? Icons.task_alt
                        : Icons.warning,
                color: Colors.white,
              ),
              const SizedBox(
                width: 20,
              ),
              SizedBox(
                width: 250,
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 5,
                ),
              ),
            ],
          ),
          margin: const EdgeInsets.all(20),
          dismissDirection: DismissDirection.horizontal,
          behavior: SnackBarBehavior.floating,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          backgroundColor: type == 'error'
              ? const Color(0xFFA33333)
              : type == 'success'
                  ? const Color(0xFF00A82A)
                  : Colors.deepOrangeAccent,
        );
}
