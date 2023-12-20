import 'package:flutter/material.dart';
import 'package:pageperfectmobile/modules/employee/screens/bookFromWriter.dart';
import 'package:pageperfectmobile/modules/employee/screens/catalog.dart';
import 'package:pageperfectmobile/modules/employee/screens/setting.dart';
import 'package:pageperfectmobile/screens/umum/login.dart';
import 'package:pageperfectmobile/screens/umum/user.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:pageperfectmobile/screens/umum/landing.dart';

class EmployeePage extends StatefulWidget {
  @override
  _EmployeePageState createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  String username = loggedInUser.username;

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    void _handleLogout() async {
      final response = await request
          .logout("https://pageperfect-f08.adaptable.app/auth/logout/");

      String message = response["message"];

      if (response['status']) {
        String uname = username;

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("$message Sampai jumpa, $uname."),
        ));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LandingPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("$message"),
        ));
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Employee'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _handleLogout();
            },
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  // Implement the same logout logic here
                },
                child: Text(
                  'Logout',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(16.0),
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'WELCOME EMPLOYEE',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        username,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30), // Space between text and buttons
                ElevatedButton(
                  onPressed: () {
                    // Action for "Catalog Book"
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => MainCatalogPage()),
                    );
                  },
                  child: Text('Catalog Book'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(200, 50),
                  ),
                ),
                SizedBox(height: 10), // Space between buttons
                ElevatedButton(
                  onPressed: () {
                    // Action for "Setting Book"
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => ActiveBooksPage()),
                    );
                  },
                  child: Text('Setting Book'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(200, 50),
                  ),
                ),
                SizedBox(height: 10), // Space between buttons
                ElevatedButton(
                  onPressed: () {
                    // Action for "Book From Writer"
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => BookFromWriterPage()),
                    );
                  },
                  child: Text('Book From Writer'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(200, 50),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
