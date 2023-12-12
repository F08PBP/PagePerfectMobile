import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pageperfectmobile/modules/member/screens/BookPage.dart';
import 'package:pageperfectmobile/modules/member/models/book.dart';
import 'package:http/http.dart' as http;
import 'package:pageperfectmobile/modules/member/screens/history.dart';
import 'package:pageperfectmobile/modules/member/widgets/addToCart.dart';
import 'dart:convert';

import 'package:pageperfectmobile/modules/member/widgets/bottom_navbar.dart';

class HomeMemberPage extends StatefulWidget {
  @override
  _HomeMemberPageState createState() => _HomeMemberPageState();
}

class _HomeMemberPageState extends State<HomeMemberPage> {
  final String _username = 'tesakun'; // Placeholder for username
  final int _eWalletBalance = 110000; // Placeholder for e-wallet balance
  late Future<List<Book>> _booksFuture;
  late Future<List<Book>> _recommendedBooks;

  Future<List<Book>> fetchBooks() async {
    var url = Uri.parse('http://127.0.0.1:8000/member/get-book-json/');
    var response = await http.get(url, headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      List<dynamic> booksJson = jsonDecode(response.body);
      return booksJson.map((json) => Book.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load books from the server');
    }
  }

  Future<List<Book>> getRandomRecommendations(Future<List<Book>> booksFuture, int count) async {
    final List<Book> books = await booksFuture; // Await the future to get the list of books
    final random = Random();

    if (books.length <= count) {
      // If the total number of books is less than or equal to the count, return all books
      return books;
    }

    var indexes = Set<int>();
    while (indexes.length < count) {
      indexes.add(random.nextInt(books.length));
    }

    return indexes.map((index) => books[index]).toList();
  }

  @override
  void initState() {
    super.initState();
    _booksFuture = fetchBooks(); // Fetch the books when the state is initialized
    _recommendedBooks = getRandomRecommendations(_booksFuture, 4);
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Books'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Centered content
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center column contents vertically
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
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Jumlah saldo E-Wallet: $_eWalletBalance',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          // Top Up E-Wallet logic
                        },
                        child: Text('Top Up E-Wallet'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue, // Button background color
                          onPrimary: Colors.white, // Button text color
                        ),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => TransactionHistoryPage(),
                            ),
                          );
                        },
                        child: Text('History'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.orange, // Button background color
                          onPrimary: Colors.white, // Button text color
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
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

                Container(
                  height: MediaQuery.of(context).size.height * 0.2, // Adjust the height as needed
                  child: FutureBuilder<List<Book>>(
                    future: _recommendedBooks, // Use the future here
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator()); // Show loading indicator while waiting
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}')); // Handle errors
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No books found')); // Handle empty or null data
                      } else {
                        // Data is available, build the list
                        List<Book> books = snapshot.data!; // Now we have the list of books
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: books.length,
                          itemBuilder: (ctx, index) {
                            Book book = books[index]; // Get the book at the current index
                            return Container(
                              width: 250, // Set a fixed width for each item
                              child: Card(
                                elevation: 4.0,
                                margin: EdgeInsets.all(10),
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
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                book.fields.title,
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                'Author: ${book.fields.authors}',
                                                style: TextStyle(fontSize: 14.0),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                'Price: \$${book.fields.harga}',
                                                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
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
                          },
                        );

                      }
                    },
                  ),
                ),           
                // Title for the list of books with "More" button
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                  child: Row(
                    children: [
                      Text(
                        "List Book",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(child: Container()), // This will push the button to the right
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigate to more books page
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => BookListPage()),
                            );
                          },
                          child: Text('More'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue, // Button color
                            onPrimary: Colors.white, // Text color
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: 200,
                  child: FutureBuilder<List<Book>>(
                    future: _booksFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No books found'));
                      } else {
                        var books = snapshot.data!.take(10).toList();
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: books.length,
                          itemBuilder: (context, index) {
                            Book book = books[index];
                            Fields fields = book.fields;
                            return Container(
                              width: 120,
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6, offset: Offset(0, 3)),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Icon(Icons.book, size: 100, color: Colors.grey[700]),
                                  ),
                                  Text(fields.title, style: TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                                  Text('Penulis: ${fields.authors}', style: TextStyle(color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
                                  Text('\$${fields.harga}', style: TextStyle(color: Theme.of(context).primaryColor)),
                                  ElevatedButton(
                                    onPressed: () {
                                      showAddToCartSheet(context, fields.title, fields.harga!);
                                    },
                                    child: Text('Add to Cart'),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.blueAccent,
                                      onPrimary: Colors.white,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                                    ),
                                  ),
                                ],
                              ),
                            );
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