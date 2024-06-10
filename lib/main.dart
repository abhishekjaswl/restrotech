import 'package:flutter/material.dart';
import 'package:mobile_app/pages/cstm_navigation.dart';
import 'package:mobile_app/pages/home.dart';
import 'package:mobile_app/pages/kitchen.dart';
import 'package:mobile_app/pages/menu.dart';
import 'package:mobile_app/pages/login.dart';
import 'package:mobile_app/pages/order.dart';
import 'package:mobile_app/pages/table.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        theme: ThemeData(useMaterial3: true),
        title: 'RestroTech',
        debugShowCheckedModeBanner: false,
        initialRoute: '/navigator',
        routes: {
          '/login': (context) => const LoginPage(),
          '/navigator': (context) {
            return const CstmNavigation();
          },
          '/home': (context) {
            return const HomePage();
          },
          '/menu': (context) {
            return const MenuPage();
          },
          '/order': (context) {
            return const OrderPage();
          },
          '/table': (context) {
            return const TablePage();
          },
          '/kitchen': (context) {
            return const KitchenPage();
          },
        },
      ),
    );
  }
}
