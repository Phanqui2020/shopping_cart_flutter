import 'package:demo/view/home_page_component/home_screen_component/fav_btn.dart';
import 'package:demo/view/home_page_component/home_screen_component/price.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final String productImage;
  final String productName;
  final String productUnit;
  final int productPrice;
  final int index;
  const CategoryItem(this.index, this.productImage, this.productName, this.productUnit, this.productPrice);

  @override
  Widget build(BuildContext context) {
    const defaultPadding = 20.0;

    return GestureDetector(
      onTap: (){},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        decoration: const BoxDecoration(
          color:  Color(0xFFF7F7F7),
          borderRadius: BorderRadius.all(
            Radius.circular(defaultPadding * 1.25),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: productName,
              child: Image.network(productImage, height: 100,width: 100,),
            ),
            Text(
              productName,
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(fontWeight: FontWeight.w600),
            ),
            Text(
              "Fruits",
              style: Theme.of(context).textTheme.caption,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Price(amount: productPrice,unit: productUnit),
                FavBtn(productImage, productName, productUnit, productPrice, index, 12),
              ],
            )
          ],
        ),
      ),
    );
  }
}
