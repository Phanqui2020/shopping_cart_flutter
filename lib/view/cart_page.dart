import 'package:demo/Provider/cart_provider.dart';
import 'package:demo/model/cart_model.dart';
import 'package:demo/sqlite/cart_db_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  CartDB dBhelper = CartDB();

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("CART"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            FutureBuilder(
              future: cart.getCartList(),
                builder: (context, AsyncSnapshot<List<Cart>> sn){
                if(sn.hasData) {
                  if(sn.data!.isNotEmpty) {
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
                                      crossAxisAlignment: CrossAxisAlignment.center,
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
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                sn.data![index].productName.toString(),
                                                style: const TextStyle(fontSize: 16,fontWeight:FontWeight.w500),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                sn.data![index].productPrice.toString() + "" + r"$",
                                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Column(
                                            children: [
                                              IconButton(
                                                  onPressed:() => {
                                                    dBhelper.deleteProduct(sn.data![index].id!)
                                                    ,cart.removeCounter(),
                                                    cart.removeTotalPrice(double.parse(sn.data![index].productPrice.toString()))
                                                  }, icon: const Icon(CupertinoIcons.trash)
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.greenAccent,
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                                height: 30,
                                                width: 80,
                                                child: Row(
                                                  children: [
                                                    IconButton(
                                                        padding: EdgeInsets.zero,
                                                        constraints: const BoxConstraints(),
                                                        onPressed: (){
                                                      int quantity = sn.data![index].quantity!;
                                                      int price =  sn.data![index].initialPrice!;
                                                      if(quantity>1){
                                                        quantity--;
                                                        int? newPrice = quantity*price;
                                                        dBhelper.updateQuantity(
                                                            Cart(id: sn.data![index].id!,
                                                                productId: sn.data![index].productId!,
                                                                productName: sn.data![index].productName!,
                                                                initialPrice: sn.data![index].initialPrice!,
                                                                productPrice: newPrice,
                                                                quantity: quantity,
                                                                unitTag: sn.data![index].unitTag! ,
                                                                image: sn.data![index].image!)
                                                        ).then((value){
                                                          quantity = 0;
                                                          newPrice = 0;
                                                          cart.removeTotalPrice(double.parse(sn.data![index].initialPrice.toString()));
                                                        }).onError((error, stackTrace){
                                                          print(error.toString());
                                                        });
                                                      }
                                                    }, icon: const Icon(CupertinoIcons.minus)),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.blueGrey,
                                                        borderRadius: BorderRadius.circular(3),
                                                      ),
                                                      height: 30,
                                                      width: 30,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            sn.data![index].quantity.toString(),
                                                            textAlign: TextAlign.center,)
                                                        ]
                                                      ),
                                                    ),
                                                    IconButton(
                                                        padding: EdgeInsets.zero,
                                                        constraints: const BoxConstraints(),
                                                        onPressed: (){
                                                      int quantity = sn.data![index].quantity!;
                                                      int price =  sn.data![index].initialPrice!;
                                                      quantity++;
                                                      int? newPrice = quantity*price;

                                                      dBhelper.updateQuantity(
                                                          Cart(id: sn.data![index].id!,
                                                              productId: sn.data![index].productId!,
                                                              productName: sn.data![index].productName!,
                                                              initialPrice: sn.data![index].initialPrice!,
                                                              productPrice: newPrice,
                                                              quantity: quantity,
                                                              unitTag: sn.data![index].unitTag! ,
                                                              image: sn.data![index].image!)
                                                      ).then((value){
                                                        quantity = 0;
                                                        newPrice = 0;
                                                        cart.addTotalPrice(double.parse(sn.data![index].initialPrice.toString()));
                                                      }).onError((error, stackTrace){
                                                        print(error.toString());
                                                      });
                                                    }, icon: const Icon(CupertinoIcons.plus)),
                                                  ],
                                                ),
                                              ),
                                            ],
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
                  else{
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Image(image: AssetImage("assets/images/empty.png"),fit: BoxFit.fill),
                      ],
                    );
                  }
                }
                return Text("data");
            }),
            Consumer<CartProvider>(builder: (context,value, child){
              return Visibility(
                visible: value.getTotalPrice().toStringAsFixed(2) == "0.00" ? false : true,
                child: Column(
                  children: [
                    TotalPrice(title: "Total Price", value: r'$' + value.getTotalPrice().toStringAsFixed(2)),
                    const SizedBox(height: 10,),
                    Container(
                      height: 50.0,
                      width: double.infinity,
                      child: RaisedButton(
                        color: Colors.blue,
                        onPressed: () {},
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)
                        ),
                        child: const Text(
                          "Checkout",
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                  ],
                ),
              );
            })
          ],
        ),
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
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25))
        ],
      ),
    );
  }
}


