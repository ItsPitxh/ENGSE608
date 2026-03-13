import 'package:flutter/material.dart';
import '../widgets/section_title.dart';

class CommunicationPage extends StatelessWidget {
  const CommunicationPage({super.key});

  void _showDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Dialog"),
        content: const Text("This is an AlertDialog in Communication tab."),
        icon: const Icon(Icons.chat_bubble_outline),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("You pressed OK ✅")),
              );
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SectionTitle(
          title: "Communication",
          subtitle: "MaterialBanner + SnackBar + Dialog",
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                FilledButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showMaterialBanner(
                      MaterialBanner(
                        content: const Text("This is a Material Banner"),
                        leading: const Icon(Icons.info),
                        actions: [
                          TextButton(
                            onPressed: () => ScaffoldMessenger.of(context)
                                .hideCurrentMaterialBanner(),
                            child: const Text("DISMISS"),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text("Show Banner"),
                ),
                FilledButton.tonal(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Hello from SnackBar 👋")),
                    );
                  },
                  child: const Text("Show SnackBar"),
                ),
                // ✅ เพิ่มปุ่มเปิด Dialog
                OutlinedButton.icon(
                  onPressed: () => _showDialog(context),
                  icon: const Icon(Icons.open_in_new),
                  label: const Text("Show Dialog"),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}