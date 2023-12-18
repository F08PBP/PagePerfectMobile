import 'package:flutter/material.dart';
import 'package:pageperfectmobile/modules/member/models/book.dart';
import 'package:pageperfectmobile/modules/member/models/cartModels.dart';
import 'package:pageperfectmobile/modules/member/widgets/bottomCheckout.dart';
import 'package:http/http.dart' as http;

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Future<List<Cart>> _cartFuture;
  late Future<List<Book>> _booksFuture;
  late Map<int, double> _bookPrices;
  late Map<int, String> _bookTitles;

  Future<List<Cart>> fetchCartItems() async {
    var url = Uri.parse(
        // 'http://10.0.2.2:8000/member/show-cart-json/'
        'http://127.0.0.1:8000/member/show-cart-json/');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      return cartFromJson(response.body);
    } else {
      throw Exception('Failed to load cart from the server');
    }
  }

  Future<Map<int, double>> fetchBookPrices() async {
    var books = await fetchBooks(); // Make sure this is an async call
    var bookPrices = <int, double>{};
    for (var book in books) {
      if (book.pk != null && book.fields?.harga != null) {
        bookPrices[book.pk!] = book.fields!.harga!.toDouble();
      }
    }
    return bookPrices;
  }

  Future<Map<int, String>> fetchBookTitles() async {
    var books = await fetchBooks();
    var bookTitles = <int, String>{};
    for (var book in books) {
      if (book.pk != null && book.fields?.title != null) {
        bookTitles[book.pk!] = book.fields!.title!;
      }
    }
    return bookTitles;
  }

  Future<List<Book>> fetchBooks() async {
    var baseUrl = 'http://127.0.0.1:8000/member/get-book-json/';
    // 'http://10.0.2.2:8000/member/get-book-json/';
    var url = Uri.parse(baseUrl);

    var response =
        await http.get(url, headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      var books = bookFromJson(response.body);
      // Simpan harga buku ke dalam _bookPrices untuk digunakan nanti
      return books;
    } else {
      throw Exception('Failed to load books from the server');
    }
  }

  double calculateTotal(List<Cart> cartItems) {
    // Hitung total harga dengan menggunakan harga buku dari _bookPrices
    if (_bookPrices == null) {
      return 0.0;
    }
    return cartItems.fold(0, (total, current) {
      final bookPrice = _bookPrices[current.fields.book];
      return total + (bookPrice ?? 0) * current.fields.quantity;
    });
  }

  @override
  void initState() {
    super.initState();
    _cartFuture = fetchCartItems();
    _booksFuture = fetchBooks();
    // Fetch book prices and update _bookPrices
    fetchBookPrices().then((prices) {
      setState(() {
        _bookPrices = prices;
      });
    }).catchError((error) {
      print('Error fetching book prices: $error');
    });
    // Fetch book titles and update _bookTitles
    fetchBookTitles().then((titles) {
      setState(() {
        _bookTitles = titles;
      });
    }).catchError((error) {
      print('Error fetching book titles: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<List<Cart>>(
        future: _cartFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Your cart is empty'));
          } else {
            List<Cart> cartItems = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index].fields;
                      // Ambil harga buku dari _bookPrices menggunakan book ID
                      if (_bookPrices == null) {
                        return CircularProgressIndicator();
                      }
                      double bookPrice = _bookPrices[item.book] ?? 0;
                      String bookTitle = _bookTitles[item.book] ?? 'No title';
                      return ListTile(
                        title: Text(
                            'Book Title: ${bookTitle}'), // Tempatkan judul buku yang sebenarnya di sini
                        subtitle: Text('Quantity: ${item.quantity}'),
                        trailing: Text(
                            '\Rp${bookPrice.toStringAsFixed(2)}'), // Tampilkan harga buku yang sebenarnya
                      );
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Total:',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      FutureBuilder<List<Cart>>(
                        future:
                            _cartFuture, // Pastikan menggunakan Future yang tepat
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              '\Rp${calculateTotal(snapshot.data!).toStringAsFixed(2)}',
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            );
                          } else {
                            return Text(
                              '\$0.00',
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.green,
        child: Container(
          height: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                onPressed: () => showCheckoutSheet(context),
                style: ElevatedButton.styleFrom(primary: Colors.white),
                child: Text(
                  'Checkout',
                  style: TextStyle(color: Colors.green),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
