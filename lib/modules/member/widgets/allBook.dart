import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pageperfectmobile/modules/member/models/book.dart';
import 'package:pageperfectmobile/modules/member/widgets/addToCart.dart';

FutureBuilder<List<Book>> buildAllBooks(BuildContext context,
    {String title = ''}) {
  Future<List<Book>> fetchBooks() async {
    var baseUrl = 'https://pageperfect-f08.adaptable.app/member/get-book-json/';
    var url = Uri.parse(baseUrl);

    if (title.isNotEmpty) {
      url = Uri.parse('$baseUrl$title/');
    }

    var response =
        await http.get(url, headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      List<dynamic> booksJson = jsonDecode(response.body);
      return booksJson.map((json) => Book.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load books');
    }
  }

  return FutureBuilder<List<Book>>(
    future: fetchBooks(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Center(child: Text('No books found'));
      } else {
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.6,
          ),
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            Book book = snapshot.data![index];
            if (book.fields != null) {
              Fields fields = book.fields;

              return GestureDetector(
                onTap: () {
                  // Your onTap code here
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEEEEE),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  margin: const EdgeInsets.all(12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Icon(
                            Icons.book,
                            size: 100,
                            color: Colors.grey[700],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                fields.title ?? 'No title', // Handle null title
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Penulis: ${fields.authors ?? 'Unknown'}', // Handle null authors
                                style: const TextStyle(
                                  fontSize: 14.0,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Harga: ${fields.harga ?? 'N/A'}', // Handle null harga
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
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
                            backgroundColor: Colors.blueAccent, // Text color
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero, // Square corners
                            ),
                          ),
                          child: const Text('Add to Cart'),
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
  );
}
