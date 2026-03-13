import 'package:flutter/material.dart';
import '../widgets/section_title.dart';

class ContentPage extends StatelessWidget {
  const ContentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = List.generate(
      8,
      (i) => (
        title: 'Item ${i + 1}',
        subtitle: 'คำอธิบายสั้น ๆ สำหรับรายการที่ ${i + 1}',
        icon: Icons.widgets_outlined
      ),
    );

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SectionTitle(
          title: 'Content',
          subtitle: 'Card + ListTile + Divider แบบฟีดการ์ด',
        ),
        ...items.map((e) {
          return Card(
            child: Column(
              children: [
                ListTile(
                  leading: CircleAvatar(child: Icon(e.icon)),
                  title: Text(e.title),
                  subtitle: Text(e.subtitle),
                  trailing: IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('More: ${e.title}')),
                      );
                    },
                    icon: const Icon(Icons.more_vert),
                  ),
                ),
                const Divider(height: 0),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'รายละเอียดเพิ่มเติมแบบสั้น ๆ (เดโม containment)',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.open_in_new),
                        label: const Text('Open'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}