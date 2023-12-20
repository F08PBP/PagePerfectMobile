// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:pageperfectmobile/widgets/left_drawer_landing.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LandingPage(),
    );
  }
}

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Landing Page',
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: const LeftDrawer(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/images/background.png'), // Ganti dengan path gambar Anda
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: [
                    TextSpan(
                      text: 'P',
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none),
                    ),
                    TextSpan(
                      text: 'age ',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                          decoration: TextDecoration.none),
                    ),
                    TextSpan(
                      text: 'P',
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none),
                    ),
                    TextSpan(
                      text: 'erfect',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                          decoration: TextDecoration.none),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                padding: EdgeInsets.all(16.0),
                color: Colors.black.withOpacity(0.5),
                child: Text(
                  'Got tired of missing out on releases from your favourite author? '
                  'You have found a perfect solution...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}