import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pageperfectmobile/modules/employee/screens/details.dart';
import 'dart:convert';

import 'package:pageperfectmobile/modules/member/models/book.dart';

class BookFromWriterPage extends StatefulWidget {
  @override
  _BookFromWriterPageState createState() => _BookFromWriterPageState();
}

class _BookFromWriterPageState extends State<BookFromWriterPage> {
  late Future<List<Book>> booksFuture;

  Future<List<Book>> fetchBooks() async {
    var url = Uri.parse(
        'https://pageperfect-f08.adaptable.app/employee/get-book-json/');
    var response =
        await http.get(url, headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      List<dynamic> booksJson = jsonDecode(response.body);
      return booksJson.map((json) => Book.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load books');
    }
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
        title: Text('Book From Writer'),
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
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Book book = snapshot.data![index];
                if (book.fields != null) {
                  Fields fields = book.fields!;
                  return ListTile(
                    title: Text('${index + 1}. ${fields.title}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                          onPressed: () {
                            // Detail action
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    BookDetailsPage(book: book),
                              ),
                            );
                          },
                          child: Text('DETAIL'),
                          style: TextButton.styleFrom(primary: Colors.blue),
                        ),
                        TextButton(
                          onPressed: () async {
                            bool success =
                                await updateBookStatus(book.pk, "ACCEPT");
                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Book status updated to ACCEPT')));
                              // Reload the list of books
                              setState(() {
                                booksFuture = fetchBooks();
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Failed to update book status')));
                            }
                          },
                          child: Text('ACCEPT'),
                          style: TextButton.styleFrom(primary: Colors.green),
                        ),
                        TextButton(
                          onPressed: () async {
                            bool success =
                                await updateBookStatus(book.pk, "DENIED");
                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Book status updated to ACCEPT')));
                              // Reload the list of books
                              setState(() {
                                booksFuture = fetchBooks();
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Failed to update book status')));
                            }
                          },
                          child: Text('DENIED'),
                          style: TextButton.styleFrom(primary: Colors.red),
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
                    child: Center(
                      child: Text('Book information not available'),
                    ),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}

Future<bool> updateBookStatus(int bookId, String newStatus) async {
  var url = Uri.parse(
      'https://pageperfect-f08.adaptable.app/employee/update-book-status/$bookId/$newStatus/');
  var response =
      await http.post(url, headers: {"Content-Type": "application/json"});

  if (response.statusCode == 200) {
    // Jika status berhasil diubah
    return true;
  } else {
    // Jika terjadi kesalahan
    print('Failed to update book status: ${response.body}');
    return false;
  }
}
