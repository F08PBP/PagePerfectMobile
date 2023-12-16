import 'package:flutter/material.dart';

import 'package:pageperfectmobile/modules/member/widgets/allBook.dart';
import 'dart:convert';

import 'package:pageperfectmobile/modules/member/models/book.dart';
import 'package:pageperfectmobile/modules/member/widgets/bottom_navbar.dart';
import 'package:pageperfectmobile/screens/umum/user.dart';

class BookListPage extends StatefulWidget {
  @override
  _BookListPageState createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  TextEditingController searchController = TextEditingController();
  List<Book> _books = [];
  bool _isLoading = true;
  String _username = loggedInUser.username;
  int _eWalletBalance = loggedInUser.money;

  String searchQuery = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: searchController,
                              style: TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                hintText: 'Search by Title',
                                hintStyle: TextStyle(color: Colors.white), // Set hint text color
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white), // Set border color
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white), // Set border color when focused
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  searchQuery = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height, // Adjust the height as needed
                child: buildAllBooks(context, title: searchQuery),
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