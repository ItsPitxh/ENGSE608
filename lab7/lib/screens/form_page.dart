import 'package:flutter/material.dart';
import '../widgets/section_title.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  DateTime? _date;
  TimeOfDay? _time;

  bool _agree = false;
  bool _notify = true;

  String _role = "Student";

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (picked == null) return;
    setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time ?? TimeOfDay.now(),
    );
    if (picked == null) return;
    setState(() => _time = picked);
  }

  String _dateText() {
    if (_date == null) return "Select date";
    final d = _date!;
    return "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";
  }

  String _timeText() {
    if (_time == null) return "Select time";
    final t = _time!;
    return t.format(context);
  }

  void _submit() {
    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;

    if (!_agree) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("กรุณาติ๊กยอมรับเงื่อนไขก่อน")),
      );
      return;
    }

    final name = _nameCtrl.text.trim();
    final email = _emailCtrl.text.trim();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Submit Result"),
        content: Text(
          "Name: $name\n"
          "Email: $email\n"
          "Role: $_role\n"
          "Date: ${_dateText()}\n"
          "Time: ${_timeText()}\n"
          "Notify: ${_notify ? "On" : "Off"}\n"
          "Agree: ${_agree ? "Yes" : "No"}",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
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
          title: "Form",
          subtitle: "TextField + DatePicker + TimePicker + Selection widgets",
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(
                      labelText: "Full Name",
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) {
                      final s = (v ?? "").trim();
                      if (s.isEmpty) return "กรุณากรอกชื่อ";
                      if (s.length < 3) return "ชื่อต้องยาวอย่างน้อย 3 ตัวอักษร";
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) {
                      final s = (v ?? "").trim();
                      if (s.isEmpty) return "กรุณากรอกอีเมล";
                      if (!s.contains("@")) return "รูปแบบอีเมลไม่ถูกต้อง";
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // DropdownMenu (Material 3)
                  const Text("Role"),
                  const SizedBox(height: 8),
                  DropdownMenu<String>(
                    initialSelection: _role,
                    onSelected: (value) {
                      if (value == null) return;
                      setState(() => _role = value);
                    },
                    dropdownMenuEntries: const [
                      DropdownMenuEntry(value: "Student", label: "Student"),
                      DropdownMenuEntry(value: "Developer", label: "Developer"),
                      DropdownMenuEntry(value: "Teacher", label: "Teacher"),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Date & Time pickers
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _pickDate,
                          icon: const Icon(Icons.calendar_today_outlined),
                          label: Text(_dateText()),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _pickTime,
                          icon: const Icon(Icons.schedule),
                          label: Text(_timeText()),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  const Divider(),

                  // Switch + Checkbox
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text("Enable notifications"),
                    value: _notify,
                    onChanged: (v) => setState(() => _notify = v),
                  ),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text("I agree to terms"),
                    value: _agree,
                    onChanged: (v) => setState(() => _agree = v ?? false),
                  ),

                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: _submit,
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text("Submit"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}