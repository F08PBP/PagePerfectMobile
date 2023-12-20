import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:pageperfectmobile/screens/umum/login.dart';
import 'package:pageperfectmobile/modules/writer/screens/book_form.dart';
import 'package:pageperfectmobile/modules/writer/screens/list_book.dart';
import 'package:pageperfectmobile/modules/writer/screens/list_book_status.dart';

String loggedUsername = "";

class WriterComponent {
  final String name;
  final IconData icon;
  final Color color;

  WriterComponent(this.name, this.icon, this.color);
}

class WriterComponentCard extends StatelessWidget {
  final WriterComponent item;

  const WriterComponentCard(this.item, {super.key}); // Constructor

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final request = context.watch<CookieRequest>();
    return Material(
      color: item.color,
      child: InkWell(
        // Area responsive terhadap sentuhan
        onTap: () async {
          // Memunculkan SnackBar ketika diklik
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
                content: Text("Kamu telah menekan tombol ${item.name}!")));
          if (item.name == "Lihat Semua Bukumu") {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const ProductPage()));
          } else if (item.name == "Tambah Buku") {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const BookFormPage()));
          } else if (item.name == "Logout") {
            final response = await request.logout(
                // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
                "https://pageperfect-f08.adaptable.app/auth/logout/");
            String message = response["message"];
            if (response['status']) {
              String uname = response["username"];
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("$message Sampai jumpa, $uname."),
              ));
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(message),
              ));
            }
          } else {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const ProductStatusPage()));
          }
        },
        child: Container(
          // Container untuk menyimpan Icon dan Text
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  color: Colors.white,
                  size: 30.0,
                ),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeWriterPage extends StatelessWidget {
  HomeWriterPage({Key? key}) : super(key: key);

  final List<WriterComponent> items = [
    WriterComponent("Tambah Buku", Icons.add_shopping_cart, Colors.green),
    WriterComponent("Lihat Semua Bukumu", Icons.visibility, Colors.blue),
    WriterComponent("Lihat Status Bukumu", Icons.mark_email_read,
        const Color.fromARGB(255, 123, 75, 3)),
    WriterComponent("Logout", Icons.logout, Colors.red),
  ];

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hello Writer',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        // Widget wrapper yang dapat discroll
        child: Padding(
          padding: const EdgeInsets.all(10.0), // Set padding dari halaman
          child: Column(
            // Widget untuk menampilkan children secara vertikal
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  loggedUsername,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // const Padding(
              //   padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              //   // Widget Text untuk menampilkan tulisan dengan alignment center dan style yang sesuai
              //   child: Text(
              //     'PBP Shop', // Text yang menandakan toko
              //     textAlign: TextAlign.center,
              //     style: TextStyle(
              //       fontSize: 30,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),
              // Grid layout
              GridView.count(
                // Container pada card kita.
                primary: true,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 4,
                shrinkWrap: true,
                children: items.map((WriterComponent item) {
                  // Iterasi untuk setiap item
                  return WriterComponentCard(item);
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
