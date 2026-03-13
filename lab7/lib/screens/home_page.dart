import 'package:flutter/material.dart';

import 'actions_page.dart';
import 'communication_page.dart';
import 'containment_page.dart';
import 'selection_page.dart';
import 'form_page.dart'; // ✅ เพิ่ม

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  // ✅ เพิ่ม FormPage เข้าไป
  final _pages = const [
    ActionsPage(),
    CommunicationPage(),
    ContainmentPage(),
    SelectionPage(),
    FormPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Week12 Navigation + Material"),
      ),

      // Drawer (NavigationDrawer - Material 3)
      drawer: NavigationDrawer(
        selectedIndex: _index,
        onDestinationSelected: (value) {
          setState(() => _index = value);
          Navigator.pop(context);
        },
        children: const [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Menu",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.touch_app),
            label: Text("Actions"),
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.campaign),
            label: Text("Communication"),
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.inventory_2),
            label: Text("Containment"),
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.tune),
            label: Text("Selection"),
          ),
          // ✅ เพิ่ม
          NavigationDrawerDestination(
            icon: Icon(Icons.edit_note),
            label: Text("Form"),
          ),
        ],
      ),

      body: _pages[_index],

      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.touch_app), label: "Actions"),
          NavigationDestination(icon: Icon(Icons.campaign), label: "Communication"),
          NavigationDestination(icon: Icon(Icons.inventory_2), label: "Containment"),
          NavigationDestination(icon: Icon(Icons.tune), label: "Selection"),
          // ✅ เพิ่ม
          NavigationDestination(icon: Icon(Icons.edit_note), label: "Form"),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Current tab: $_index")),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text("Add"),
      ),
    );
  }
}