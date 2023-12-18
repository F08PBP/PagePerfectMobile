import 'package:flutter/material.dart';
import 'package:pageperfectmobile/modules/member/screens/cart.dart';

Widget buildFloatingCartIcon(BuildContext context) {
  return FloatingActionButton(
    onPressed: () {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => CartPage()),
      );
    },
    child: Icon(Icons.shopping_cart, color: Colors.white), // Cart icon
    backgroundColor: Colors.green, // Set your preferred background color
    elevation: 10, // Add elevation for a shadow
  );
}