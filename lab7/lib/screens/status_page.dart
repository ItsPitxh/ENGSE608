import 'package:flutter/material.dart';
import '../widgets/section_title.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({super.key});

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  bool _loading = false;
  bool _enabled = true;
  bool _check = false;
  int _badge = 3;

  Future<void> _fakeLoad() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    setState(() {
      _loading = false;
      _badge = (_badge + 1) % 10;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('โหลดเสร็จแล้ว')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SectionTitle(
          title: 'Status',
          subtitle: 'Progress / SnackBar / Badge + Switch/Checkbox',
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Badge(
                      label: Text('$_badge'),
                      child: const Icon(Icons.notifications_none),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _loading ? 'กำลังโหลด...' : 'พร้อมใช้งาน',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    FilledButton(
                      onPressed: _loading ? null : _fakeLoad,
                      child: const Text('Load'),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                if (_loading) const LinearProgressIndicator(),
                const SizedBox(height: 10),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Enable feature'),
                    Switch(
                      value: _enabled,
                      onChanged: (v) => setState(() => _enabled = v),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: _check,
                      onChanged: (v) => setState(() => _check = v ?? false),
                    ),
                    const Text('ยอมรับเงื่อนไข'),
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