import 'package:add_boat/screens/dashboard.dart';
import 'package:add_boat/screens/manage_boat.dart';
import 'package:add_boat/screens/manage_bookings.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget content = const ManageBoatScreen();
    if (_selectedIndex == 0) {
      content = const Dashboard();
    }
    if (_selectedIndex == 1) {
      content = ManageBookingsScreen();
    }
    if (_selectedIndex == 2) {
      content = const ManageBoatScreen();
    }
    if (_selectedIndex == 3) {}
    if (_selectedIndex == 4) {}

    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 52.0,
              top: 20,
              bottom: 20.0,
            ),
            child: Text(
              'GTM',
              style: GoogleFonts.montserrat(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.w600,
                  fontSize: 30),
            ),
          ),
          const Divider(height: 0),
          Expanded(
            child: Row(
              children: [
                // Navigation Bar on the left
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Card(
                    child: SizedBox(
                      width: 300,
                      child: ListView(
                        padding: const EdgeInsets.only(left: 25, right: 20),
                        children: <Widget>[
                          ListTile(
                            title: const Text(
                              'Dashboard',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                _selectedIndex = 0;
                              });
                            },
                          ),
                          const Divider(),
                          ListTile(
                            contentPadding:
                                const EdgeInsets.only(left: 20, right: 30),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9),
                            ),
                            selected: _selectedIndex == 1,
                            selectedTileColor: _selectedIndex == 1
                                ? Colors.blue
                                : Colors.black,
                            focusColor: Colors.blue,
                            selectedColor: Colors.blue,
                            title: Text(
                              'Manage Bookings',
                              style: TextStyle(
                                  color: _selectedIndex == 1
                                      ? Colors.white
                                      : Colors.black),
                            ),
                            onTap: () {
                              setState(() {
                                _selectedIndex = 1;
                              });
                            },
                          ),
                          ListTile(
                            contentPadding:
                                const EdgeInsets.only(left: 20, right: 30),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9),
                            ),
                            selected: _selectedIndex == 2,
                            selectedTileColor: _selectedIndex == 2
                                ? Colors.blue
                                : Colors.black,
                            title: Text(
                              'Manage Boats',
                              style: TextStyle(
                                  color: _selectedIndex == 2
                                      ? Colors.white
                                      : Colors.black),
                            ),
                            onTap: () {
                              setState(() {
                                _selectedIndex = 2;
                              });
                            },
                          ),
                          ListTile(
                            contentPadding:
                                const EdgeInsets.only(left: 20, right: 30),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9),
                            ),
                            selectedColor: Colors.blue,
                            title: const Text('Manage Meals'),
                            onTap: () {
                              setState(() {
                                _selectedIndex = 3;
                              });
                            },
                          ),
                          ListTile(
                            contentPadding:
                                const EdgeInsets.only(left: 20, right: 30),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9),
                            ),
                            selectedColor: Colors.white,
                            focusColor: Colors.blue,
                            title: const Text('Manage Pricing'),
                            onTap: () {
                              setState(() {
                                _selectedIndex = 4;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Main Content
                Expanded(child: content),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
