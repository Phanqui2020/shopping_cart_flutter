import 'package:demo/common/common_ulti.dart';
import 'package:demo/model/cart_model.dart';
import 'package:demo/sqlite/cart_db_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Provider/cart_provider.dart';

class FavBtn extends StatelessWidget {
  final String productImage;
  final String productName;
  final String productUnit;
  final int productPrice;
  final int index;

  FavBtn(this.productImage, this.productName, this.productUnit, this.productPrice, this.index, this.radius);

  final double radius;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final commonUlti = CommonUlti();
    final CartDB _cartDB = CartDB();
    return CircleAvatar(
      radius: radius,
      backgroundColor: const Color(0xFFE3E2E3),
      child: IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        icon: const Icon(Icons.shopping_cart_outlined),
        onPressed: () {
          _cartDB.insert(
              Cart(
                id: index,
                productId: index.toString(),
                productName: productName.toString(),
                initialPrice: productPrice,
                productPrice: productPrice,
                quantity: 1,
                unitTag: productUnit.toString(),
                image: productImage.toString(),
              ))
              .then((value) {
            commonUlti.showToast("Added to cart");
            cart.addCounter();
            cart.addTotalPrice(double.parse(productPrice.toString()));
          }).onError((error, stackTrace) {
            if (error.toString().contains("UNIQUE")) {
              commonUlti.showToast("Already have in cart");
            }
          });
        },
      ),
    );
  }
}