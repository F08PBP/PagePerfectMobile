import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pageperfectmobile/modules/member/screens/mainMember.dart';
import 'dart:convert';

import 'package:pageperfectmobile/screens/umum/user.dart';

void showCheckoutSheet(BuildContext context) {
  // This controller will keep track of the input in the TextField.
  TextEditingController notesController = TextEditingController();

  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.all(20),
        height: 250, // Increased height to accommodate the notes TextField
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Price: 100000',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: notesController,
              decoration: InputDecoration(
                labelText: 'Notes',
                hintText: 'Any special requests or notes?',
                border: OutlineInputBorder(),
              ),
              maxLines: 2, // Allows for multi-line input
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    final String notes = notesController.text;

                    buyBook(context, notes);

                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    onPrimary: Colors.white,
                  ),
                  child: Text('Buy'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    onPrimary: Colors.white,
                  ),
                  child: Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

Future<void> buyBook(BuildContext context, String notes) async {
  final response = await http.post(
    Uri.parse('http://127.0.0.1:8000/member/confirm_purchase_flutter/'),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'notes': notes,
    }),
  );

  if (response.statusCode == 200) {
    var responseData = jsonDecode(response.body);
    // Update user money
    loggedInUser.money = responseData['money'];

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Buy success!')),
    );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => HomeMemberPage()),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to Buy the book.')),
    );
  }
}
