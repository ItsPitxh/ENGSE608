import 'package:flutter/material.dart';
import '../widgets/section_title.dart';

class ContainmentPage extends StatelessWidget {
  const ContainmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        SectionTitle(
          title: "Containment",
          subtitle: "Card / ListTile / ExpansionTile",
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text("Card Example"),
            subtitle: Text("This is a Material Card"),
            trailing: Icon(Icons.chevron_right),
          ),
        ),
        SizedBox(height: 10),
        Card(
          child: ExpansionTile(
            title: Text("Expansion Tile"),
            children: [
              ListTile(title: Text("Item 1")),
              ListTile(title: Text("Item 2")),
            ],
          ),
        ),
      ],
    );
  }
}