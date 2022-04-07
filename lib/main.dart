import 'package:demo/Provider/cart_provider.dart';
import 'package:demo/sqlite/user_db_helper.dart';
import 'package:demo/view/register_page.dart';
import 'view/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view/login_page.dart';
import 'view/cart_page.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
          home: const LoginPage(),
        );
      }),
    );
  }
}