# Lab 7 — Week 12 Navigation + Material Components

## ภาพรวม

โปรเจกต์ Flutter สำหรับฝึก **Material 3 Components** และระบบ **Navigation** หลายรูปแบบ แบ่งเนื้อหาเป็น 5 หน้า นำทางผ่านทั้ง Bottom Navigation Bar และ Drawer

---

## โครงสร้างไฟล์

```
lab7/lib/
├── main.dart
├── screens/
│   ├── home_page.dart
│   ├── actions_page.dart
│   ├── communication_page.dart
│   ├── containment_page.dart
│   ├── content_page.dart
│   ├── selection_page.dart
│   └── form_page.dart
└── widgets/
    └── section_title.dart
```

---

## อธิบาย Code ทีละไฟล์

---

### `main.dart`

จุดเริ่มต้นแอป กำหนดธีมและ home page

```dart
MaterialApp(
  title: 'Week12 Navigation + Material',
  theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.teal),
  home: const HomePage(),
)
```

- `useMaterial3: true` — เปิดใช้ Material 3 Design
- `colorSchemeSeed: Colors.teal` — สร้าง color palette ทั้งชุดจากสี teal อัตโนมัติ

---

### `widgets/section_title.dart`

**`class SectionTitle extends StatelessWidget`** — Widget หัวข้อซ้ำๆ ที่ใช้ในทุกหน้า

```dart
SectionTitle({required String title, required String subtitle})
```

แสดง title ด้วย `headlineSmall` style และ subtitle ด้วย `bodyMedium` style ตาม Theme

สร้างเป็น Widget แยกเพื่อให้แต่ละหน้าใช้ซ้ำได้โดยไม่ต้อง copy style เอง

---

### `screens/home_page.dart`

หน้าหลักที่เป็น container ของทุกหน้า จัดการ Navigation

**State**

```dart
int _index = 0;  // index ของแท็บปัจจุบัน

final _pages = const [
  ActionsPage(), CommunicationPage(), ContainmentPage(),
  SelectionPage(), FormPage(),
];
```

**Drawer (NavigationDrawer)**

```dart
NavigationDrawer(
  selectedIndex: _index,
  onDestinationSelected: (value) {
    setState(() => _index = value);
    Navigator.pop(context);  // ปิด drawer หลังเลือก
  },
  children: [
    Padding(...Text("Menu")),
    NavigationDrawerDestination(icon: ..., label: ...),
    // ...5 destinations
  ],
)
```

- `NavigationDrawer` — Drawer แบบ Material 3 ที่ highlight รายการที่เลือกอยู่
- `Navigator.pop(context)` — ปิด Drawer หลังเลือกหน้า

**Bottom Navigation Bar**

```dart
NavigationBar(
  selectedIndex: _index,
  onDestinationSelected: (value) => setState(() => _index = value),
  destinations: [...5 NavigationDestination],
)
```

- ใช้ `_index` ตัวเดียวกับ Drawer → สลับหน้าจาก 2 ที่ได้โดยซิงค์กัน

**FloatingActionButton**

```dart
FloatingActionButton.extended(
  onPressed: () {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Current tab: $_index")),
    );
  },
  icon: Icon(Icons.add),
  label: Text("Add"),
)
```

แสดง SnackBar บอก index แท็บปัจจุบัน ตัวอย่างการใช้ `ScaffoldMessenger`

---

### `screens/actions_page.dart`

สาธิต Button หลายแบบและ AlertDialog

**State**

```dart
int counter = 0;
```

**`_toast(String text)`** — helper แสดง SnackBar สั้นๆ 900ms

**ปุ่มแบบต่างๆ:**

```dart
FilledButton(onPressed: () => setState(() => counter++), child: Text("Filled +1"))
FilledButton.tonalIcon(onPressed: () => setState(() => counter += 5), ...)
OutlinedButton(onPressed: () => setState(() => counter = 0), child: Text("Reset"))
```

- `FilledButton` — ปุ่มเติมสี (primary)
- `FilledButton.tonalIcon` — ปุ่มเติมสีอ่อน มีไอคอน
- `OutlinedButton` — ปุ่มกรอบ

**AlertDialog:**

```dart
final ok = await showDialog<bool>(
  context: context,
  builder: (_) => AlertDialog(
    title: Text("Dialog"),
    actions: [
      TextButton(onPressed: () => Navigator.pop(context, false), child: Text("Cancel")),
      FilledButton(onPressed: () => Navigator.pop(context, true), child: Text("OK")),
    ],
  ),
);
_toast(ok == true ? "Confirmed ✅" : "Cancelled");
```

- `showDialog<bool>` — dialog ที่คืนค่า bool
- `Navigator.pop(context, value)` — ปิด dialog พร้อมส่งค่ากลับ
- รอผลด้วย `await` แล้วนำไปใช้ต่อ

---

### `screens/communication_page.dart`

สาธิต MaterialBanner, SnackBar และ AlertDialog

**`_showDialog(BuildContext context)`** — method แยกต่างหากสำหรับสร้าง Dialog ไม่ใส่ใน build โดยตรงเพื่อความสะอาด

**MaterialBanner:**

```dart
ScaffoldMessenger.of(context).showMaterialBanner(
  MaterialBanner(
    content: Text("This is a Material Banner"),
    leading: Icon(Icons.info),
    actions: [
      TextButton(
        onPressed: () => ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
        child: Text("DISMISS"),
      ),
    ],
  ),
);
```

- Banner แสดงด้านบนหน้าจอ ต้องกด DISMISS เองถึงจะปิด

**SnackBar:**

```dart
ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(content: Text("Hello from SnackBar 👋")),
);
```

- แสดงชั่วคราวด้านล่าง หายไปเอง

---

### `screens/containment_page.dart`

สาธิต Card, ListTile และ ExpansionTile (StatelessWidget ไม่มี State)

**Card + ListTile:**

```dart
Card(
  child: ListTile(
    leading: Icon(Icons.shopping_cart),
    title: Text("Card Example"),
    subtitle: Text("This is a Material Card"),
    trailing: Icon(Icons.chevron_right),
  ),
)
```

**Card + ExpansionTile:**

```dart
Card(
  child: ExpansionTile(
    title: Text("Expansion Tile"),
    children: [
      ListTile(title: Text("Item 1")),
      ListTile(title: Text("Item 2")),
    ],
  ),
)
```

- `ExpansionTile` — กด expand/collapse เพื่อซ่อน/แสดง children

---

### `screens/content_page.dart`

สาธิต Card แบบ Feed รายการหลายอัน

**สร้างรายการด้วย `List.generate`:**

```dart
final items = List.generate(8, (i) => (
  title: 'Item ${i + 1}',
  subtitle: 'คำอธิบาย...',
  icon: Icons.widgets_outlined
));
```

ใช้ Record type `(title: ..., subtitle: ..., icon: ...)` สำหรับเก็บข้อมูลชั่วคราวแบบ anonymous

**วน render ด้วย spread operator:**

```dart
...items.map((e) {
  return Card(
    child: Column(children: [
      ListTile(leading: CircleAvatar(...), title: ..., trailing: IconButton(...)),
      Divider(height: 0),
      Padding(child: Row(children: [Text(...), TextButton.icon(...)]))
    ]),
  );
})
```

---

### `screens/selection_page.dart`

สาธิต SegmentedButton, Slider และ DropdownMenu

**State**

```dart
double sliderValue = 50;
String dropdownValue = "Option 1";
Set<String> selected = {"Day"};  // SegmentedButton ใช้ Set ไม่ใช่ String
```

**SegmentedButton:**

```dart
SegmentedButton<String>(
  segments: [
    ButtonSegment(value: "Day", label: Text("Day")),
    ButtonSegment(value: "Month", label: Text("Month")),
    ButtonSegment(value: "Year", label: Text("Year")),
  ],
  selected: selected,
  onSelectionChanged: (newSelection) {
    setState(() => selected = newSelection);
  },
)
```

- ใช้ `Set<String>` เพราะรองรับ multi-select ได้ในอนาคต

**Slider:**

```dart
Slider(
  value: sliderValue, max: 100, divisions: 10,
  label: sliderValue.round().toString(),
  onChanged: (value) => setState(() => sliderValue = value),
)
```

- `divisions: 10` — snap ทุก 10 หน่วย
- `label` — แสดงค่าเป็น tooltip ขณะลาก

---

### `screens/form_page.dart`

ฟอร์มเต็มรูปแบบที่รวม Input หลายชนิด

**State**

```dart
final _formKey = GlobalKey<FormState>();
final _nameCtrl = TextEditingController();
final _emailCtrl = TextEditingController();
DateTime? _date;
TimeOfDay? _time;
bool _agree = false, _notify = true;
String _role = "Student";
```

**`_pickDate()`** — แสดง date picker แล้วเก็บผลใน `_date`

```dart
final picked = await showDatePicker(
  context: context,
  initialDate: _date ?? DateTime.now(),
  firstDate: DateTime(now.year - 5),
  lastDate: DateTime(now.year + 5),
);
if (picked == null) return;  // ถ้าผู้ใช้กด cancel ไม่ทำอะไร
setState(() => _date = picked);
```

**`_pickTime()`** — เหมือน `_pickDate()` แต่ใช้ `showTimePicker`

**`_submit()`** — ตรวจ validation ก่อน แล้วแสดงผลใน AlertDialog

```dart
final ok = _formKey.currentState?.validate() ?? false;
if (!ok) return;
if (!_agree) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("กรุณาติ๊กยอมรับเงื่อนไขก่อน")));
  return;
}
// แสดง dialog สรุปข้อมูล
```

**`dispose()`** — คืน memory ของ TextEditingController ทั้ง 2 ตัว

**DropdownMenu (Material 3):**

```dart
DropdownMenu<String>(
  initialSelection: _role,
  onSelected: (value) => setState(() => _role = value!),
  dropdownMenuEntries: [
    DropdownMenuEntry(value: "Student", label: "Student"),
    // ...
  ],
)
```

ต่างจาก `DropdownButton` ตรงที่รองรับการพิมพ์ค้นหาใน menu ได้

**SwitchListTile และ CheckboxListTile:**

```dart
SwitchListTile(title: Text("Enable notifications"), value: _notify,
  onChanged: (v) => setState(() => _notify = v))

CheckboxListTile(title: Text("I agree to terms"), value: _agree,
  onChanged: (v) => setState(() => _agree = v ?? false))
```

รวม Label + Switch/Checkbox ไว้ด้วยกันในบรรทัดเดียว

---

## วิธีรัน

```bash
flutter pub get
flutter run
```
