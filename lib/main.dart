import 'package:demo/Provider/CartProvider.dart';
import 'view/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view/login_page.dart';
import 'view/cart_page.dart';

void main() {
  runApp(const MyApp(),);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: Builder(builder: (BuildContext context) {
        return MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFEFEFEF)),
          home: HomePage(),
        );
      }),
    );
  }
}