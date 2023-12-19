import 'package:flutter/material.dart';
import 'package:pageperfectmobile/modules/member/models/book.dart';

class BookDetailsPage extends StatelessWidget {
  final Book book;

  BookDetailsPage({required this.book});

  @override
  Widget build(BuildContext context) {
    Fields fields = book.fields;

    return Scaffold(
      appBar: AppBar(
        title: Text(fields.title),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Author', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(fields.authors),
            Divider(),
            Text('Price', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(fields.harga.toString()),
            Divider(),
            Text('Rating', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(fields.averageRating.toString()),
            Divider(),
            Text('ISBN', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(fields.isbn),
            Divider(),
            Text('Language', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(fields.languageCode.toString().split('.').last),
            Divider(),
            Text('Num Pages', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(fields.numPages.toString()),
            Divider(),
            Text('Publication Date', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(fields.publicationDate),
            Divider(),
            Text('Publisher', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(fields.publisher),
            Divider(),
            // Add more fields as needed
          ],
        ),
      ),
    );
  }
}
