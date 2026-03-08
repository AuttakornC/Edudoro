import 'package:edudoro/color.dart';
import 'package:edudoro/components/util/svgIcon.dart';
import 'package:edudoro/providers/coin_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeCoin extends StatefulWidget {
  @override
  State<HomeCoin> createState() => _HomeCoinState();
}

class _HomeCoinState extends State<HomeCoin> {
  @override
  Widget build(BuildContext context) {
    final coinContext = context.watch<CoinProvider>();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () => {Navigator.of(context).pushNamed("/shop")},
          icon: SVGIcon(src: "assets/icons/CartIcon.svg"),
        ),
        Text(
          coinContext.coin.toString(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: yellow100,
          ),
        ),
        SizedBox(width: 2),
        SVGIcon(
          src: "assets/icons/CoinIcon.svg",
          color: yellow100,
          width: 24,
          height: 24,
        ),
      ],
    );
  }
}
