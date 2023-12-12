import 'package:flutter/material.dart';

import 'package:pageperfectmobile/modules/member/widgets/allBook.dart';
import 'dart:convert';

import 'package:pageperfectmobile/modules/member/models/book.dart';
import 'package:pageperfectmobile/modules/member/widgets/bottom_navbar.dart';

class BookListPage extends StatefulWidget {
  @override
  _BookListPageState createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  List<Book> _books = [];
  bool _isLoading = true;
  String _username = 'tesakun'; // Placeholder for username
  int _eWalletBalance = 110000; // Placeholder for e-wallet balance

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Books'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Scrollable content
          ListView(
            children: [
              // Welcome message container
              Container(
                width: double.infinity,
                color: Colors.black.withOpacity(0.7),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome $_username',
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      'Jumlah saldo E-Wallet: $_eWalletBalance',
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Top Up E-Wallet logic
                      },
                      child: Text('Top Up E-Wallet'),
                    ),
                    Text(
                      'Here are some book recommendations!',
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                  ],
                ),
              ),
              // Container for book list - This should be modified to contain your book list
              Container(
                height: MediaQuery.of(context).size.height, // Adjust the height as needed
                child: buildAllBooks(context),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: buildFloatingCartIcon(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
