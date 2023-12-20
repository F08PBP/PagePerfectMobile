import 'package:flutter/material.dart';
import 'package:pageperfectmobile/modules/writer/screens/book_form.dart';
import 'package:pageperfectmobile/modules/writer/screens/list_book.dart';
import 'package:pageperfectmobile/screens/temporary/menu.dart';
import 'package:pageperfectmobile/modules/writer/screens/writer_page.dart';
import 'package:pageperfectmobile/modules/writer/screens/list_book_status.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            // TODO: Bagian drawer header
            decoration: const BoxDecoration(
              color: Colors.indigo,
            ),
            child: Column(
              children: [
                Text(
                  'Hello $loggedUsername',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Padding(padding: EdgeInsets.all(10)),
                const Text(
                  "What are you gonna do today?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          // TODO: Bagian routing
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Halaman Utama'),
            // Bagian redirection ke MyHomePage
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeWriterPage(),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_shopping_cart),
            title: const Text('Tambah Produk'),
            //Bagian redirection ke ShopFormPage
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BookFormPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_basket),
            title: Text('List Buku'),
            onTap: () {
              // Route menu ke halaman produk
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProductPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.mark_chat_read),
            title: Text('List Status Buku'),
            onTap: () {
              // Route menu ke halaman produk
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ProductStatusPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
