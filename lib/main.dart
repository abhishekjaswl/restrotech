import 'package:flutter/material.dart';
import 'package:mobile_app/pages/auth/register.dart';
import 'package:mobile_app/pages/cstm_navigation.dart';
import 'package:mobile_app/pages/home.dart';
import 'package:mobile_app/pages/kitchen.dart';
import 'package:mobile_app/pages/menu.dart';
import 'package:mobile_app/pages/auth/login.dart';
import 'package:mobile_app/pages/order.dart';
import 'package:mobile_app/pages/table.dart';
import 'package:mobile_app/providers/currentuser_provider.dart';
import 'package:mobile_app/providers/loading.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => CurrentUser(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => IsLoadingData(),
        ),
      ],
      child: SafeArea(
        child: MaterialApp(
          theme: ThemeData(useMaterial3: true),
          title: 'RestroTech',
          debugShowCheckedModeBanner: false,
          initialRoute: '/login',
          routes: {
            '/login': (context) => const LoginPage(),
            '/register': (context) => const RegisterPage(),
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
      ),
    );
  }
}
