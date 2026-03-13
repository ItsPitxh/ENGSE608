import 'package:flutter/material.dart';
import '../widgets/section_title.dart';

class ActionsPage extends StatefulWidget {
  const ActionsPage({super.key});

  @override
  State<ActionsPage> createState() => _ActionsPageState();
}

class _ActionsPageState extends State<ActionsPage> {
  int counter = 0;

  void _toast(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), duration: const Duration(milliseconds: 900)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SectionTitle(
          title: "Actions",
          subtitle: "FilledButton / Tonal / IconButton + Dialog",
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Counter: $counter",
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    FilledButton(
                      onPressed: () => setState(() => counter++),
                      child: const Text("Filled +1"),
                    ),
                    FilledButton.tonalIcon(
                      onPressed: () => setState(() => counter += 5),
                      icon: const Icon(Icons.plus_one),
                      label: const Text("Tonal +5"),
                    ),
                    OutlinedButton(
                      onPressed: () => setState(() => counter = 0),
                      child: const Text("Reset"),
                    ),
                    IconButton.filledTonal(
                      onPressed: () async {
                        final ok = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text("Dialog"),
                            content: const Text("This is Material Dialog"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text("Cancel"),
                              ),
                              FilledButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text("OK"),
                              ),
                            ],
                          ),
                        );
                        if (!mounted) return;
                        _toast(ok == true ? "Confirmed ✅" : "Cancelled");
                      },
                      icon: const Icon(Icons.favorite),
                      tooltip: "Favorite",
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}