import 'package:flutter/material.dart';
import '../widgets/section_title.dart';

class SelectionPage extends StatefulWidget {
  const SelectionPage({super.key});

  @override
  State<SelectionPage> createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  double sliderValue = 50;
  String dropdownValue = "Option 1";
  Set<String> selected = {"Day"};

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SectionTitle(
          title: "Selection",
          subtitle: "SegmentedButton / Slider / DropdownMenu",
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Segmented Button"),
                const SizedBox(height: 10),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: "Day", label: Text("Day")),
                    ButtonSegment(value: "Month", label: Text("Month")),
                    ButtonSegment(value: "Year", label: Text("Year")),
                  ],
                  selected: selected,
                  onSelectionChanged: (newSelection) {
                    setState(() => selected = newSelection);
                  },
                ),
                const SizedBox(height: 20),
                const Text("Slider"),
                Slider(
                  value: sliderValue,
                  max: 100,
                  divisions: 10,
                  label: sliderValue.round().toString(),
                  onChanged: (value) => setState(() => sliderValue = value),
                ),
                const SizedBox(height: 20),
                const Text("Dropdown Menu"),
                DropdownMenu<String>(
                  initialSelection: dropdownValue,
                  onSelected: (value) {
                    if (value == null) return;
                    setState(() => dropdownValue = value);
                  },
                  dropdownMenuEntries: const [
                    DropdownMenuEntry(value: "Option 1", label: "Option 1"),
                    DropdownMenuEntry(value: "Option 2", label: "Option 2"),
                    DropdownMenuEntry(value: "Option 3", label: "Option 3"),
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