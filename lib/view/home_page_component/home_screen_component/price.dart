import 'package:flutter/material.dart';

class Price extends StatelessWidget {
  const Price({
    Key? key,
    required this.amount,
    required this.unit,
  }) : super(key: key);
  final int amount;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: "\$ ",
        style: Theme.of(context)
            .textTheme
            .subtitle1!
            .copyWith(fontWeight: FontWeight.w600, color: const Color(0xFF40A944)),
        children: [
          TextSpan(
            text: amount.toString(),
            style: const TextStyle(color: Colors.black),
          ),
          const TextSpan(
            text: "/"
          ),
          TextSpan(
            text: unit,
            style:
                const TextStyle(color: Colors.black26, fontWeight: FontWeight.normal),
          )
        ],
      ),
    );
  }
}
