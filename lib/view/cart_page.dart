import 'package:demo/Provider/CartProvider.dart';
import 'package:demo/model/cart_model.dart';
import 'package:demo/sqlite/db_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  DBhelper dBhelper = DBhelper();

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("CART"),
      ),
      body: Column(
        children: [
          FutureBuilder(

            future: cart.getCartList(),
              builder: (context, AsyncSnapshot<List<Cart>> sn){
              if(sn.hasData) {
                return Expanded(
                    child: ListView.builder(
                        itemCount: sn.data!.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Image(
                                        image: NetworkImage(
                                            sn.data![index].image.toString()),
                                        height: 100,
                                        width: 100,
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment
                                              .start,
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          children: [
                                            Text(
                                              sn.data![index].productName
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                  FontWeight.w500),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              sn.data![index].productPrice
                                                  .toString() +
                                                  "" +
                                                  r"$/" +
                                                  sn.data![index].unitTag
                                                      .toString(),
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                  FontWeight.w500),
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
                                                    color: Theme
                                                        .of(context)
                                                        .primaryColor,
                                                    textColor: Colors.white,
                                                    child: const Text("-"),
                                                    onPressed: () => {},
                                                    splashColor:
                                                    Colors.blueGrey,
                                                  ),
                                                  const SizedBox(
                                                    width: 2,
                                                  ),
                                                  Container(
                                                    height: 20.0,
                                                    width: 50.0,
                                                    child: TextField(
                                                      maxLines: 1,
                                                      decoration:
                                                      InputDecoration(
                                                        fillColor:
                                                        Colors.grey[300],
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
                                                    color: Theme
                                                        .of(context)
                                                        .primaryColor,
                                                    textColor: Colors.white,
                                                    child: const Text("+"),
                                                    onPressed: () => {},
                                                    splashColor:
                                                    Colors.blueGrey,
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
                                                color: Colors.white,
                                                width: 2.0),
                                            borderRadius:
                                            BorderRadius.circular(250.0),
                                          ),
                                          height: 40.0,
                                          minWidth: 40.0,
                                          color:
                                          Theme
                                              .of(context)
                                              .primaryColor,
                                          textColor: Colors.white,
                                          child:
                                          const Icon(CupertinoIcons.trash),
                                          onPressed: () => {
                                            dBhelper!.deleteProduct(sn.data![index].id!)
                                            ,cart.removeCounter(),
                                            cart.removeTotalPrice(double.parse(sn.data![index].productPrice.toString()))
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
                        })
                );
              }
              return Text('');
          }),
          Consumer<CartProvider>(builder: (context,value, child){
            return Column(
              children: [
                TotalPrice(title: "Total Price", value: r'$' + value.getTotalPrice().toStringAsFixed(2))],
              );
            })
        ],
      ),
    );
  }
}

class TotalPrice extends StatelessWidget {
  final String title, value;
  const TotalPrice({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(

        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.subtitle2,),
          Text(value, style: Theme.of(context).textTheme.subtitle2,)
        ],
      ),
    );
  }
}


