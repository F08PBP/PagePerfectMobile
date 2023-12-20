import 'package:flutter/material.dart';
import 'package:pageperfectmobile/modules/member/screens/cart.dart';

Widget buildFloatingCartIcon(BuildContext context) {
  return FloatingActionButton(
    onPressed: () {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const CartPage()),
      );
    }, // Cart icon
    backgroundColor: Colors.green, // Set your preferred background color
    elevation: 10,
    child: const Icon(Icons.shopping_cart, color: Colors.white), // Add elevation for a shadow
  );
}