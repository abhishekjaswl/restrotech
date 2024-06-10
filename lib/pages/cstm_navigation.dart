import 'package:flutter/material.dart';
import 'package:mobile_app/pages/kitchen.dart';
import 'package:mobile_app/pages/menu.dart';
import 'package:mobile_app/pages/order.dart';
import 'package:mobile_app/pages/table.dart';

class CstmNavigation extends StatefulWidget {
  const CstmNavigation({super.key});

  @override
  State<CstmNavigation> createState() => _CstmNavigationState();
}

class _CstmNavigationState extends State<CstmNavigation> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
            border:
                BorderDirectional(top: BorderSide(color: Color(0xFFD1D0D0)))),
        child: NavigationBar(
          height: 70,
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          indicatorShape:
              const UnderlineInputBorder(borderSide: BorderSide.none),
          indicatorColor: const Color(0xFFFFAD39),
          selectedIndex: currentPageIndex,
          destinations: const <Widget>[
            NavigationDestination(
              icon: Icon(Icons.menu_book),
              label: 'Menu',
            ),
            NavigationDestination(
              icon: Icon(Icons.all_inbox),
              label: 'Orders',
            ),
            NavigationDestination(
              icon: Icon(Icons.table_bar),
              label: 'Tables',
            ),
            NavigationDestination(
              icon: Icon(Icons.microwave),
              label: 'Kitchen',
            ),
          ],
        ),
      ),
      body: <Widget>[
        const MenuPage(),
        const OrderPage(),
        const TablePage(),
        const KitchenPage(),
      ][currentPageIndex],
    );
  }
}
