import 'package:flutter/material.dart';

class TTailorPriceText extends StatelessWidget {
  const TTailorPriceText({
    super.key,
    this.currencySign = '\$',
    required this.price,
    this.maxLines = 1,
    this.isLarge = false,
    this.linieThrough = false,
  });

  final String currencySign, price;
  final int maxLines;
  final bool isLarge;
  final bool linieThrough;

  @override
  Widget build(BuildContext context) {
    return Text(
      currencySign + price,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: isLarge
          ? Theme.of(context).textTheme.headlineMedium!.apply(
              decoration: linieThrough ? TextDecoration.lineThrough : null)
          : Theme.of(context).textTheme.titleLarge!.apply(
              decoration: linieThrough ? TextDecoration.lineThrough : null),
    );
  }
}
