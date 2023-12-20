import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pageperfectmobile/modules/member/screens/mainMember.dart';
import 'dart:convert';

import 'package:pageperfectmobile/screens/umum/user.dart';

void showCheckoutSheet(BuildContext context, String totalPrice) {
  // This controller will keep track of the input in the TextField.
  TextEditingController notesController = TextEditingController();

  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(20),
        height: 250, // Increased height to accommodate the notes TextField
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Price: Rp$totalPrice',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: notesController,
              decoration: const InputDecoration(
                labelText: 'Notes',
                hintText: 'Any special requests or notes?',
                border: OutlineInputBorder(),
              ),
              maxLines: 2, // Allows for multi-line input
            ),
            const SizedBox(height: 20),
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
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Buy'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Cancel'),
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
    Uri.parse(
        // 'http://10.0.2.2:8000/member/confirm_purchase_flutter/'
        'https://pageperfect-f08.adaptable.app/member/confirm_purchase_flutter/'),
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
      const SnackBar(content: Text('Buy success!')),
    );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomeMemberPage()),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Failed to Buy the book')),
    );
  }
}
