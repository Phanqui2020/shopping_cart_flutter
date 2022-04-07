import 'package:badges/badges.dart';
import 'package:demo/Provider/cart_provider.dart';
import 'package:demo/view/cart_page.dart';
import 'package:demo/view/home_page_component/account_screen.dart';
import 'package:demo/view/home_page_component/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _currentIndex = 1;
  final List<String> _currentTitle = [ "ACCOUNT","HOME", "CHAT"];
  final screens = [
    const AccountScreen(),
    const HomeScreen(),
    const Text("Developing function...", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.lightGreenAccent)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentTitle[_currentIndex]),
        actions: [
          Badge(
            animationType: BadgeAnimationType.slide,
              position: BadgePosition.topEnd(top: 4, end: -5),
              badgeContent:
                  Consumer<CartProvider>(builder: (context, value, child) {
                    return Text(value.getCounter().toString());
              }),
              animationDuration: const Duration(microseconds: 300),
              child: IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const CartPage()));
                },
                icon: const Icon(Icons.shopping_bag_outlined),
              )),
          const SizedBox(width: 20.0),
        ],
      ),
      body:Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: screens[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person),
            label: "Account",
            backgroundColor: Colors.blue,
          ),

          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home),
            label: "Home",
            backgroundColor: Colors.red,
          ),

          BottomNavigationBarItem(
              icon: Icon(Icons.inbox),
            label: "Chat",
            backgroundColor: Colors.green,
          ),
        ],
      ),
    );
  }
}

