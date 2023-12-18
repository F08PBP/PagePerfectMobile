import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pageperfectmobile/modules/member/models/book.dart';
import 'package:pageperfectmobile/modules/member/models/purchased_book.dart';
import 'package:pageperfectmobile/modules/member/models/transaction.dart';

class TransactionHistoryPage extends StatefulWidget {
  @override
  _TransactionHistoryPageState createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  late Future<List<Transaksi>> _transactionsFuture;
  late Future<List<Book>> _booksFuture;
  Map<int, String> _bookTitles = {};

  Future<List<Transaksi>> fetchTransactions() async {
    var url = Uri.parse(
        // 'http://10.0.2.2:8000/member/show-transaction/'
        'http://127.0.0.1:8000/member/show-transaction/');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      return transaksiFromJson(response.body);
    } else {
      throw Exception('Failed to load transactions from the server');
    }
  }

  Future<List<Purchased>> fetchPurchasedItems(int transactionId) async {
    var url = Uri.parse(
        //'http://10.0.2.2:8000/member/show-purchased-json/$transactionId'
        'http://127.0.0.1:8000/member/show-purchased-json/$transactionId');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      return purchasedFromJson(response.body);
    } else {
      throw Exception('Failed to load purchased items');
    }
  }

  Future<List<Book>> fetchBooks() async {
    var baseUrl =
        // 'http://10.0.2.2:8000/member/get-book-json/';
        'http://127.0.0.1:8000/member/get-book-json/';
    var url = Uri.parse(baseUrl);

    var response =
        await http.get(url, headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      List<Book> books = bookFromJson(response.body);
      _bookTitles = Map.fromIterable(books,
          key: (book) => book.pk, value: (book) => book.fields.title);
      return books;
    } else {
      throw Exception('Failed to load books');
    }
  }

  @override
  void initState() {
    super.initState();
    _transactionsFuture = fetchTransactions();
    _booksFuture = fetchBooks();
  }

  String getBookTitle(int bookId) {
    return _bookTitles[bookId] ?? 'Unknown Book';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction History'),
      ),
      body: FutureBuilder<List<Transaksi>>(
        future: _transactionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No transactions found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (ctx, index) {
                var transaction = snapshot.data![index];
                return ExpansionTile(
                  leading: Icon(Icons.history,
                      color: Theme.of(context).primaryColor),
                  title: Text('Transaction ID: ${transaction.pk}'),
                  subtitle: Text('Date: ${transaction.fields.dateAdded}'),
                  children: <Widget>[
                    Text('Notes: ${transaction.fields.notes}'),
                    FutureBuilder<List<Purchased>>(
                      future: fetchPurchasedItems(transaction.pk),
                      builder: (context, purchasedSnapshot) {
                        if (purchasedSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return ListTile(
                              title: Text('Loading purchased items...'));
                        } else if (purchasedSnapshot.hasError) {
                          return ListTile(
                              title: Text('Error: ${purchasedSnapshot.error}'));
                        } else if (!purchasedSnapshot.hasData ||
                            purchasedSnapshot.data!.isEmpty) {
                          return ListTile(title: Text('No items found'));
                        } else {
                          return Column(
                            children: purchasedSnapshot.data!
                                .map((purchasedItem) => ListTile(
                                      title: Text(
                                          'Book Title: ${getBookTitle(purchasedItem.fields.book)}'),
                                      subtitle: Text(
                                          'Quantity: ${purchasedItem.fields.quantity}'),
                                    ))
                                .toList(),
                          );
                        }
                      },
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
