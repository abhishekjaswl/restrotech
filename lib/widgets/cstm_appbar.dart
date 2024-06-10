import 'package:flutter/material.dart';

class CstmAppBar extends StatefulWidget {
  const CstmAppBar({
    super.key,
  });

  @override
  State<CstmAppBar> createState() => _CstmAppBarState();
}

class _CstmAppBarState extends State<CstmAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Builder(
          builder: (BuildContext context) {
            return Image.asset('assets/images/logo.png');
          },
        ),
      ),
      elevation: 0,
      leadingWidth: 70,
      toolbarHeight: 80,
    );
  }
}
