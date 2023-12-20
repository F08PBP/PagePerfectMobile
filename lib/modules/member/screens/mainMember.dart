import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pageperfectmobile/modules/member/screens/BookPage.dart';
import 'package:pageperfectmobile/modules/member/models/book.dart';
import 'package:http/http.dart' as http;
import 'package:pageperfectmobile/modules/member/screens/history.dart';
import 'package:pageperfectmobile/modules/member/widgets/addToCart.dart';
import 'dart:convert';
import 'package:pageperfectmobile/modules/member/widgets/bottom_navbar.dart';
import 'package:pageperfectmobile/screens/umum/user.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:pageperfectmobile/screens/umum/login.dart';
import 'package:pageperfectmobile/screens/umum/landing.dart';

class HomeMemberPage extends StatefulWidget {
  const HomeMemberPage({super.key});

  @override
  _HomeMemberPageState createState() => _HomeMemberPageState();
}

class _HomeMemberPageState extends State<HomeMemberPage> {
  final String _username = loggedInUser.username; // Placeholder for username
  int _eWalletBalance = loggedInUser.money; // Placeholder for e-wallet balance
  late Future<List<Book>> _booksFuture;
  late Future<List<Book>> _recommendedBooks;
  final _formKey = GlobalKey<FormState>();
  int _formUang = 0;

  Future<List<Book>> fetchBooks() async {
    var url = Uri.parse(
        'https://pageperfect-f08.adaptable.app/member/get-book-json/');
    var response =
        await http.get(url, headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      List<dynamic> booksJson = jsonDecode(response.body);
      return booksJson.map((json) => Book.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load books from the server');
    }
  }

  Future<List<Book>> getRandomRecommendations(
      Future<List<Book>> booksFuture, int count) async {
    final List<Book> books =
        await booksFuture; // Await the future to get the list of books
    final random = Random();

    if (books.length <= count) {
      // If the total number of books is less than or equal to the count, return all books
      return books;
    }

    var indexes = <int>{};
    while (indexes.length < count) {
      indexes.add(random.nextInt(books.length));
    }

    return indexes.map((index) => books[index]).toList();
  }

  Future<void> topUp(BuildContext context, String uang) async {
    final response = await http.post(
      Uri.parse(
          'https://pageperfect-f08.adaptable.app/member/add-money-flutter/'),
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
        MaterialPageRoute(builder: (context) => const HomeMemberPage()),
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
    _booksFuture =
        fetchBooks(); // Fetch the books when the state is initialized
    _recommendedBooks = getRandomRecommendations(_booksFuture, 4);
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Books'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final response = await request
                  .logout('https://pageperfect-f08.adaptable.app/auth/logout/');
              String message = response["message"];
              if (response['status']) {
                String uname = _username;
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("$message Sampai jumpa, $uname."),
                ));
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LandingPage()),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(message),
                ));
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Center(
              child: GestureDetector(
                onTap: () {},
                child: const Text(
                  'Logout',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Centered content
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Center column contents vertically
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                // Semi-transparent overlay container
                Container(
                  padding: const EdgeInsets.all(16.0),
                  color: Colors.black.withOpacity(0.5),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Fit content in the center
                    children: <Widget>[
                      Text(
                        'Welcome $_username',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Jumlah saldo E-Wallet: Rp$_eWalletBalance',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
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
                                                if (int.tryParse(value) ==
                                                    null) {
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
                                          if (_formKey.currentState!
                                              .validate()) {
                                            topUp(
                                                context, _formUang.toString());
                                          }
                                          _formKey.currentState!.reset();
                                        })
                                  ],
                                );
                              });
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue, // Button text color
                        ),
                        child: const Text('Top Up E-Wallet'),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  const TransactionHistoryPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.orange, // Button text color
                        ),
                        child: const Text('History'),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Here are some book recommendations!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: MediaQuery.of(context).size.height *
                      0.2, // Adjust the height as needed
                  child: FutureBuilder<List<Book>>(
                    future: _recommendedBooks, // Use the future here
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child:
                                CircularProgressIndicator()); // Show loading indicator while waiting
                      } else if (snapshot.hasError) {
                        return Center(
                            child: Text(
                                'Error: ${snapshot.error}')); // Handle errors
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text(
                                'No books found')); // Handle empty or null data
                      } else {
                        // Data is available, build the list
                        List<Book> books =
                            snapshot.data!; // Now we have the list of books
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: books.length,
                          itemBuilder: (ctx, index) {
                            Book book = books[
                                index]; // Get the book at the current index
                            if (book.fields != null) {
                              Fields fields = book.fields;
                              return SizedBox(
                                width: 250, // Set a fixed width for each item
                                child: Card(
                                  elevation: 4.0,
                                  margin: const EdgeInsets.all(10),
                                  child: InkWell(
                                    onTap: () {
                                      // Handle book tap, navigate to book detail or perform other action
                                    },
                                    child: Row(
                                      children: <Widget>[
                                        // Icon on the left side
                                        Icon(
                                          Icons.book,
                                          size: 100,
                                          color: Colors.grey[700],
                                        ),
                                        // Details on the right side
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  fields.title,
                                                  style: const TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  'Author: ${fields.authors}',
                                                  style: const TextStyle(
                                                      fontSize: 14.0),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  'Price: Rp${fields.harga}',
                                                  style: const TextStyle(
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return Container(
                                margin: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: const Center(
                                  child: Text('Book information not available'),
                                ),
                              );
                            }
                          },
                        );
                      }
                    },
                  ),
                ),
                // Title for the list of books with "More" button
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 10.0),
                  child: Row(
                    children: [
                      const Text(
                        "List Book",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                          child:
                              Container()), // This will push the button to the right
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigate to more books page
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => const BookListPage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blue, // Text color
                          ),
                          child: const Text('More'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 200,
                  child: FutureBuilder<List<Book>>(
                    future: _booksFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No books found'));
                      } else {
                        var books = snapshot.data!.take(10).toList();
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: books.length,
                          itemBuilder: (context, index) {
                            Book book = books[index];
                            if (book.fields != null) {
                              Fields fields = book.fields;
                              return Container(
                                width: 120,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 6,
                                        offset: const Offset(0, 3)),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Icon(Icons.book,
                                          size: 100, color: Colors.grey[700]),
                                    ),
                                    Text(fields.title,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                    Text('Penulis: ${fields.authors}',
                                        style:
                                            const TextStyle(color: Colors.grey),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                    Text('Rp${fields.harga}',
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .primaryColor)),
                                    ElevatedButton(
                                      onPressed: () {
                                        showAddToCartSheet(
                                            context,
                                            fields.title,
                                            fields.harga,
                                            fields.jumlahTerjual,
                                            fields.jumlahBuku);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: Colors.blueAccent,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.zero),
                                      ),
                                      child: const Text('Add to Cart'),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return Container(
                                margin: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: const Center(
                                  child: Text('Book information not available'),
                                ),
                              );
                            }
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: buildFloatingCartIcon(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
