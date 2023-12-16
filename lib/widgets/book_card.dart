import 'package:flutter/material.dart';
import 'package:pageperfectmobile/models/book.dart';

class BookCard extends StatelessWidget {
  final Book book;
  const BookCard(this.book, {Key? key});

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Inkwell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DetailBook(book: book),
                ),
              );
            },
            child: Container(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [])))));
  }
}
