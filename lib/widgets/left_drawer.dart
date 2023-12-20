import 'package:flutter/material.dart';
import 'package:pageperfectmobile/screens/temporary/menu.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            // TODO: Bagian drawer header
            decoration: BoxDecoration(
              color: Colors.indigo,
            ),
            child: Column(
              children: [
                Text(
                  'Shopping List',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Padding(padding: EdgeInsets.all(10)),
                Text(
                  "Catat seluruh keperluan belanjamu di sini!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
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
                    builder: (context) => MyHomePage(),
                  ));
            },
          ),
          const ListTile(
            leading: Icon(Icons.add_shopping_cart),
            title: Text('Tambah Produk'),
            // Bagian redirection ke ShopFormPage
            // onTap: () {
            //   Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) => const ShopFormPage()));
            // },
          ),
          const ListTile(
            leading: Icon(Icons.shopping_basket),
            title: Text('Daftar Produk'),
            // onTap: () {
            //   // Route menu ke halaman produk
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => const ProductPage()),
            //   );
            // },
          ),
        ],
      ),
    );
  }
}
