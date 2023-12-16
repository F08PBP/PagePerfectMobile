import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pageperfectmobile/models/book.dart';
import 'package:pageperfectmobile/widgets/left_drawer.dart';

class ListBook extends StatefulWidget {
  const ListBook({Key? key}) : super(key: key);

  @override
  _ListBookState createState() => _ListBookState();
}

class _ListBookState extends State<ListBook> {
  Future<List<Book>> getBooks() async {
    var url = Uri.parse('http://10.0.2.2:8000/api/books/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    // decode json
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    // konversi data json menjadi object Book
    List<Book> list_book = [];
    for (var d in data) {
      if (d != null) {
        list_book.add(Book.fromJson(d));
      }
    }
    return list_book;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('List Book'),
        ),
        drawer: const LeftDrawer(),
        body: FutureBuilder(
            future: getBooks(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return const Center(child: CircularProgressIndicator());
              } else {
                if (!snapshot.hasData) {
                  return const Column(
                    children: [
                      Text(
                        "Tidak terdapat buku.",
                        style:
                            TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                      ),
                      SizedBox(height: 8),
                    ],
                  );
                } else {
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (_, index) => Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${snapshot.data![index].fields.title}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                    "Penulis buku: ${snapshot.data![index].fields.authors}"),
                                const SizedBox(height: 10),
                                Text(
                                    "Jumlah buku tersedia: ${snapshot.data![index].fields.jumlahBuku}"),
                                const SizedBox(height: 10),
                                Text(
                                    "Harga buku: Rp${snapshot.data![index].fields.harga}")
                              ],
                            ),
                          ));
                }
              }
            }));
  }
}
