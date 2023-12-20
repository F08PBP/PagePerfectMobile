// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pageperfectmobile/screens/umum/login.dart';
import 'package:pageperfectmobile/screens/umum/login.dart';

import '../screens/umum/register.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            // Bagian drawer header
            decoration: BoxDecoration(
              color: Colors.indigo,
            ),
            child: Column(
              children: [
                Text(
                  'PagePerfect',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Padding(padding: EdgeInsets.all(10)),
                Text(
                  "Cari buku favoritmu di sini!",
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

          // Bagian routing
          ListTile(
            leading: const Icon(Icons.login_rounded),
            title: const Text('Account Login'),
            // Bagian redirection ke MyHomePage
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.app_registration_outlined),
            title: const Text('Account Register'),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegisterPage(),
                  ));
            },
          ),
        ],
      ),
    );
  }
}