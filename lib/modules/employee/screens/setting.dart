import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pageperfectmobile/modules/employee/models/catalog.dart';
import 'package:pageperfectmobile/modules/employee/screens/details.dart';
import 'dart:convert';

import 'package:pageperfectmobile/modules/member/models/book.dart';

class ActiveBooksPage extends StatefulWidget {
  @override
  _ActiveBooksPageState createState() => _ActiveBooksPageState();
}

class _ActiveBooksPageState extends State<ActiveBooksPage> {
  late Future<List<Book>> booksFuture;
  late Future<List<Catalog>> catalogFuture;
  late Map<int, Book> booksMap;
  late Map<int, Catalog> catalogMap = {};

  @override
  void initState() {
    super.initState();
    booksFuture = fetchBooks().then((books) {
      booksMap = {for (var book in books) book.pk: book};
      return books;
    });
    catalogFuture = fetchCatalog().then((catalogs) {
      catalogMap = {for (var catalog in catalogs) catalog.pk: catalog};
      return catalogs;
    });
  }

  Future<List<Catalog>> fetchCatalog() async {
    var url = Uri.parse('http://127.0.0.1:8000/employee/get-active-json/');
    var response = await http.get(url, headers: {"Content-Type": "application/json"});
    if (response.statusCode == 200) {
      return catalogFromJson(response.body);
    } else {
      throw Exception('Failed to load catalog');
    }
  }

  Future<List<Book>> fetchBooks() async {
    var url = Uri.parse('http://127.0.0.1:8000/employee/get-catalog-json/');
    var response = await http.get(url, headers: {"Content-Type": "application/json"});
    if (response.statusCode == 200) {
      List<dynamic> booksJson = jsonDecode(response.body);
      return booksJson.map((json) => Book.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load books');
    }
  }

  void toggleCatalogVisibility(Catalog catalog) async {
    var url = Uri.parse('http://127.0.0.1:8000/employee/catalog/toggle-visibility/${catalog.pk}/');
    var response = await http.post(url, headers: {"Content-Type": "application/json"});
    
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success']) {
        setState(() {
          catalog.fields.isShowToMember = jsonResponse['isShowToMember'];
        });
      } else {
        // Handle the error
        print('Failed to toggle visibility: ${jsonResponse['error']}');
      }
    } else {
      // Handle the error
      print('Failed to toggle visibility with status code: ${response.statusCode}');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Active Books'),
      ),
      body: FutureBuilder<List<Catalog>>(
        future: catalogFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No catalog found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var catalogItem = snapshot.data![index];
                var book = booksMap[catalogItem.fields.book];
                if (book == null) return Container(); // or some error widget

                return ListTile(
                  title: Text(book.fields.title),
                  subtitle: Text(book.fields.authors),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          catalogItem.fields.isShowToMember ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () => toggleCatalogVisibility(catalogItem),
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigate to details page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookDetailsPage(book: book),
                            ),
                          );
                        },
                        child: Text('Details'),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}