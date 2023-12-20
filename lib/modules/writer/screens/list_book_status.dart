import 'package:flutter/material.dart';
import 'package:pageperfectmobile/modules/member/models/book.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:pageperfectmobile/modules/writer/widgets/left_drawer_writer.dart';

class ProductStatusPage extends StatefulWidget {
  const ProductStatusPage({Key? key}) : super(key: key);

  @override
  _ProductStatusPageState createState() => _ProductStatusPageState();
}

class _ProductStatusPageState extends State<ProductStatusPage> {
  Future<Map<String, List<Book>>> fetchProducts(BuildContext context) async {
    final request = context.watch<CookieRequest>();
    var url = "https://pageperfect-f08.adaptable.app/writer/get-product/";
    var response = await request.get(url);

    var data = [...response];

    List<Book> acceptedProducts = [];
    List<Book> deniedProducts = [];
    List<Book> waitingProducts = [];

    for (var d in data) {
      if (d != null) {
        Book book = Book.fromJson(d);
        if (book.fields.statusAccept == "ACCEPT") {
          acceptedProducts.add(book);
        } else if (book.fields.statusAccept == "DENIED") {
          deniedProducts.add(book);
        } else if (book.fields.statusAccept == "WAITING") {
          waitingProducts.add(book);
        }
      }
    }

    Map<String, List<Book>> resultMap = {
      'acceptedProducts': acceptedProducts,
      'deniedProducts': deniedProducts,
      'waitingProducts': waitingProducts,
    };

    return resultMap;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product'),
      ),
      drawer: LeftDrawer(),
      body: FutureBuilder(
        future: fetchProducts(context),
        builder: (context, AsyncSnapshot<Map<String, List<Book>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "Tidak ada data produk.",
                style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
              ),
            );
          } else {
            return Row(
              children: [
                _buildProductColumn("Accepted Products", snapshot.data!['acceptedProducts']!),
                _buildProductColumn("Denied Products", snapshot.data!['deniedProducts']!),
                _buildProductColumn("Waiting Products", snapshot.data!['waitingProducts']!),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildProductColumn(String title, List<Book> productList) {
  Color titleColor;

  // Set the title color based on the status
  switch (title) {
    case 'Accepted Products':
      titleColor = Colors.green;
      break;
    case 'Denied Products':
      titleColor = Colors.red;
      break;
    case 'Waiting Products':
      titleColor = const Color.fromARGB(255, 53, 52, 52);
      break;
    default:
      titleColor = Colors.black; // Default color
  }

  return Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: titleColor),
          ),
        ),
        if (productList.isNotEmpty)
          Expanded(
            child: ListView.builder(
              itemCount: productList.length,
              itemBuilder: (_, index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                padding: const EdgeInsets.all(20.0),
                child: Card(
                  elevation: 5,
                  child: SizedBox(
                    width: 100,
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Status: ${productList[index].fields.statusAccept}",
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Title: ${productList[index].fields.title}",
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Harga: ${productList[index].fields.harga}",
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Stok: ${productList[index].fields.jumlahBuku}",
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    ),
  );
}
}
