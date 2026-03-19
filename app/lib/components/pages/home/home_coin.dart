/*
 * File: home_coin.dart
 * Description: Displays the user's coin balance and provides access to the shop in the Edudoro home screen.
 * Responsibilities:
 * - Shows the current coin count from CoinProvider.
 * - Provides a button to navigate to the shop page.
 * - Uses consistent iconography and color styling.
 * Dependencies:
 * - Depends on CoinProvider to fetch the latest coin state.
 * Lifecycle:
 * - Reactively rebuilds whenever CoinProvider notifies changes.
 * Author: Auttakorn Camsoi
 * Course: Mobile Application Development Framework
 */

import 'package:edudoro/color.dart';
import 'package:edudoro/components/util/svgIcon.dart';
import 'package:edudoro/providers/coin_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// A widget that displays the user's coin balance and a shop navigation button.
///
/// Fields:
/// - None
///
/// Usage:
/// - Embedded in the [HomeFooter] to display current wealth and access the shop.
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
