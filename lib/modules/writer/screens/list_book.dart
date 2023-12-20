// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'package:pageperfectmobile/modules/member/models/book.dart';
import 'package:pageperfectmobile/modules/writer/screens/writer_page.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:pageperfectmobile/modules/writer/widgets/left_drawer_writer.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  Future<List<Book>> fetchProduct(BuildContext context) async {
    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    final request = context.watch<CookieRequest>();
    var url = ("https://pageperfect-f08.adaptable.app/writer/get-product/");
    var response = await request.get(url);
    // print(response);

    // melakukan decode response menjadi bentuk json
    var data = [...response];

    // melakukan konversi data json menjadi object Book
    List<Book> listProduct = [];
    for (var d in data) {
      if (d != null) {
        listProduct.add(Book.fromJson(d));
      }
    }
    // print(listProduct);
    return listProduct;
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
        future: fetchProduct(context),
        builder: (context, AsyncSnapshot<List<Book>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Column(
              children: [
                Text(
                  "Tidak ada data produk.",
                  style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                ),
                SizedBox(height: 8),
              ],
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Card(
                      elevation: 5,
                      child: SizedBox(
                        width: 200,
                        height: 150,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Title: ${snapshot.data![index].fields.title}",
                                style: const TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Harga: ${snapshot.data![index].fields.harga}",
                                style: const TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Stok: ${snapshot.data![index].fields.jumlahBuku}",
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
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: ElevatedButton(
                    //     style: ButtonStyle(
                    //       backgroundColor:
                    //           MaterialStateProperty.all(Colors.indigo),
                    //     ),
                    //     onPressed: () {
                    //       Navigator.pushReplacement(
                    //         context,
                    //         MaterialPageRoute(
                    //           builder: (context) => HomeWriterPage(),
                    //         ),
                    //       );
                    //     },
                    //     child: const Text(
                    //       "Back",
                    //       style: TextStyle(color: Colors.white),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
