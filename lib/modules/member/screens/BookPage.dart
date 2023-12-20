import 'package:flutter/material.dart';

import 'package:pageperfectmobile/modules/member/widgets/allBook.dart';
import 'dart:convert';

import 'package:pageperfectmobile/modules/member/models/book.dart';
import 'package:pageperfectmobile/modules/member/widgets/bottom_navbar.dart';
import 'package:pageperfectmobile/screens/umum/user.dart';
import 'package:http/http.dart' as http;

class BookListPage extends StatefulWidget {
  const BookListPage({super.key});

  @override
  _BookListPageState createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  TextEditingController searchController = TextEditingController();
  final List<Book> _books = [];
  final bool _isLoading = true;
  final String _username = loggedInUser.username;
  int _eWalletBalance = loggedInUser.money;
  int _formUang = 0;
  final _formKey = GlobalKey<FormState>();

  String searchQuery = '';

  Future<void> topUp(BuildContext context, String uang) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/member/add-money-flutter/'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'uang': uang,
      }),
    );

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      // Update user money
      loggedInUser.money = responseData['money'];
      setState(() {
        _eWalletBalance = loggedInUser.money;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Top Up success!')),
      );
      Navigator.of(context).pop(
        MaterialPageRoute(builder: (context) => const BookListPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to Top Up.')),
      );
    }
  }

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
        title: const Text('Books'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
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
                      style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Text(
                      'Jumlah saldo E-Wallet: $_eWalletBalance',
                      style: const TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                scrollable: true,
                                title: const Text('Masukkan Jumlah Uang'),
                                content: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      children: <Widget>[
                                        TextFormField(
                                            decoration: const InputDecoration(
                                              labelText: 'Uang',
                                              icon: Icon(Icons.attach_money),
                                            ),
                                            onChanged: (String? value) {
                                              setState(() {
                                                _formUang = int.parse(value!);
                                              });
                                            },
                                            validator: (String? value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Nilai tidak boleh kosong';
                                              }
                                              if (int.tryParse(value) == null) {
                                                return 'Nilai harus berupa angka';
                                              }
                                              return null;
                                            }),
                                      ],
                                    ),
                                  ),
                                ),
                                actions: [
                                  ElevatedButton(
                                      child: const Text("Submit"),
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          topUp(context, _formUang.toString());
                                        }
                                        _formKey.currentState!.reset();
                                      })
                                ],
                              );
                            });
                      },
                      child: const Text('Top Up E-Wallet'),
                    ),
                    const Text(
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
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                hintText: 'Search by Title',
                                hintStyle: TextStyle(
                                    color: Colors.white), // Set hint text color
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white), // Set border color
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors
                                          .white), // Set border color when focused
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
              SizedBox(
                height: MediaQuery.of(context)
                    .size
                    .height, // Adjust the height as needed
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
