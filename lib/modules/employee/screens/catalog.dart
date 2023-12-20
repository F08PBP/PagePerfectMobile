import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pageperfectmobile/modules/employee/screens/details.dart';
import 'package:pageperfectmobile/modules/member/models/book.dart';

class MainCatalogPage extends StatefulWidget {
  @override
  _MainCatalogPageState createState() => _MainCatalogPageState();
}

class _MainCatalogPageState extends State<MainCatalogPage> {
  late Future<List<Book>> booksFuture;

  Future<List<Book>> fetchBooks() async {
    var url = Uri.parse(
        'https://pageperfect-f08.adaptable.app/employee/get-catalog-json/');
    var response =
        await http.get(url, headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      List<dynamic> booksJson = jsonDecode(response.body);
      return booksJson.map((json) => Book.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load books');
    }
  }

  void reloadBooks() {
    setState(() {
      booksFuture = fetchBooks();
    });
  }

  @override
  void initState() {
    super.initState();
    booksFuture = fetchBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Catalog'),
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).pop(); // Go back on pressing 'Back'
          },
        ),
      ),
      body: FutureBuilder<List<Book>>(
        future: booksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No books found'));
          } else {
            return ListView(
              children: [
                ...snapshot.data!.asMap().entries.map((entry) {
                  int idx = entry.key;
                  Book book = entry.value;
                  Fields fields = book.fields;
                  return ListTile(
                    title: Text('${idx + 1}. ${fields.title}'),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Stock: ${fields.jumlahBuku}'),
                        Text('Sold: ${fields.jumlahTerjual}'),
                        ElevatedButton(
                          onPressed: () {
                            // Navigate to the details page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    BookDetailsPage(book: book),
                              ),
                            );
                          },
                          child: Text('DETAIL'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            showAddStockBottomSheet(context, book);
                          },
                          child: Text('Add stock'),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            );
          }
        },
      ),
    );
  }

  void showAddStockBottomSheet(BuildContext context, Book book) {
    int quantity = 0;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              color: Colors.white,
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    book.fields.title,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          if (quantity > 0) {
                            setState(() {
                              quantity--;
                            });
                          }
                        },
                      ),
                      Text(
                        '$quantity',
                        style: TextStyle(fontSize: 18),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            quantity++;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      bool success = await addBookStock(book.pk, quantity);
                      if (success) {
                        Navigator.pop(context); // Tutup bottom sheet
                        reloadBooks();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Stock added successfully!')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to add stock')),
                        );
                      }
                    },
                    child: Text('Add Stock'),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}

Future<bool> addBookStock(int bookId, int addedStock) async {
  var url = Uri.parse(
      'https://pageperfect-f08.adaptable.app/employee/add-book-stock/');
  var response = await http.post(
    url,
    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
    body: {
      'book_id': bookId.toString(),
      'added_stock': addedStock.toString(),
    },
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    print('Failed to add stock: ${response.body}');
    return false;
  }
}
