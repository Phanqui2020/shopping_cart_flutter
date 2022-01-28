import 'package:badges/badges.dart';
import 'package:demo/Provider/CartProvider.dart';
import 'package:demo/sqlite/db_helper.dart';
import 'package:demo/view/cart_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:demo/model/cart_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DBhelper? dBhelper = DBhelper();

  List<String> productName = [
    'Mango',
    'Orange',
    'Grapes',
    'Banana',
    'Chery',
    'Peach',
    'Mixed Fruit Basket',
  ];

  List<String> productUnit = [
    'KG',
    'KG',
    'KG',
    'KG',
    'KG',
    'KG',
    'KG',
  ];

  List<int> productPrice = [10, 20, 30, 40, 50, 60, 70];

  List<String> productImage = [
    'https://image.shutterstock.com/image-photo/mango-isolated-on-white-background-600w-610892249.jpg',
    'https://image.shutterstock.com/image-photo/orange-fruit-slices-leaves-isolated-600w-1386912362.jpg',
    'https://image.shutterstock.com/image-photo/green-grape-leaves-isolated-on-600w-533487490.jpg',
    'https://media.istockphoto.com/photos/banana-picture-id1184345169?s=612x612',
    'https://media.istockphoto.com/photos/cherry-trio-with-stem-and-leaf-picture-id157428769?s=612x612',
    'https://media.istockphoto.com/photos/single-whole-peach-fruit-with-leaf-and-slice-isolated-on-white-picture-id1151868959?s=612x612',
    'https://media.istockphoto.com/photos/fruit-background-picture-id529664572?s=612x612',
  ];

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("HOME"),
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
                constraints: BoxConstraints(),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const CartPage()));
                },
                icon: const Icon(Icons.shopping_bag_outlined),
              )),
          const SizedBox(width: 20.0),
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: productName.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Image(
                                  image: NetworkImage(
                                      productImage[index].toString()),
                                  height: 100,
                                  width: 100,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        productName[index].toString(),
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        productPrice[index].toString() +
                                            "" +
                                            r"$/" +
                                            productUnit[index].toString(),
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        child: Row(
                                          children: [
                                            MaterialButton(
                                              height: 20.0,
                                              minWidth: 10.0,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              textColor: Colors.white,
                                              child: const Text("-"),
                                              onPressed: () => {},
                                              splashColor: Colors.blueGrey,
                                            ),
                                            const SizedBox(
                                              width: 2,
                                            ),
                                            Container(
                                              height: 20.0,
                                              width: 50.0,
                                              child: TextField(
                                                maxLines: 1,
                                                decoration: InputDecoration(
                                                  fillColor: Colors.grey[300],
                                                  filled: true,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 2,
                                            ),
                                            MaterialButton(
                                              height: 20.0,
                                              minWidth: 10.0,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              textColor: Colors.white,
                                              child: const Text("+"),
                                              onPressed: () => {},
                                              splashColor: Colors.blueGrey,
                                            ),
                                            const SizedBox(
                                              width: 2,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: MaterialButton(
                                    shape: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.white, width: 2.0),
                                      borderRadius:
                                          BorderRadius.circular(250.0),
                                    ),
                                    height: 40.0,
                                    minWidth: 40.0,
                                    color: Theme.of(context).primaryColor,
                                    textColor: Colors.white,
                                    child: const Icon(CupertinoIcons.cart),
                                    onPressed: () => {
                                      dBhelper!
                                          .insert(Cart(
                                        id: index,
                                        productId: index.toString(),
                                        productName:
                                            productName[index].toString(),
                                        initialPrice: productPrice[index],
                                        productPrice: productPrice[index],
                                        quantity: 1,
                                        unitTag: productUnit[index].toString(),
                                        image: productImage[index].toString(),
                                      ))
                                          .then((value) {
                                        print("success!");
                                        cart.addCounter();
                                        cart.addTotalPrice(double.parse(
                                            productPrice[index].toString()));
                                      }).onError((error, stackTrace) {
                                        print(error.toString());
                                      })
                                    },
                                    splashColor: Colors.blueGrey,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  })),
        ],
      ),
    );
  }
}
