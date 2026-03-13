# Flutter Application 2 — Peach Counter App

## ภาพรวม

แอปนับจำนวน (Counter) ที่สาธิตการใช้ **StatefulWidget** และ **setState** — กดปุ่ม `+` แล้วตัวเลขเพิ่มขึ้น 1

---

## โครงสร้างไฟล์

```
flutter_application_2/
└── lib/
    └── main.dart
```

---

## อธิบาย Code: `main.dart`

### `void main()`

```dart
void main() {
  runApp(const MyApp());
}
```

จุดเริ่มต้นของแอป เรียก `runApp()` โดยส่ง `MyApp` เข้าไป

---

### `class MyApp extends StatelessWidget`

Widget รากของแอป ไม่มี State เปลี่ยนแปลงเอง (`StatelessWidget`)

```dart
return MaterialApp(
  title: 'Peach App',
  theme: ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  ),
  home: const MyHomePage(title: 'Peach Counter Aapp'),
);
```

- **`MaterialApp`** — ครอบแอปทั้งหมดเพื่อใช้ Material Design
- **`ThemeData`** + `colorScheme.fromSeed` — สร้างธีมสีจาก seed color `deepPurple` อัตโนมัติ
- **`home`** — กำหนดหน้าแรกเป็น `MyHomePage`

---

### `class MyHomePage extends StatefulWidget`

Widget หน้าหลักที่มี State เปลี่ยนได้ ต้องใช้ `StatefulWidget`

```dart
final String title;
```

รับ `title` มาแสดงใน AppBar ผ่าน `widget.title`

---

### `class _MyHomePageState extends State<MyHomePage>`

State ที่แท้จริงของหน้านี้ ตัวแปรและ logic อยู่ที่นี่

**ตัวแปร State**

```dart
int _counter = 0;
```

เก็บค่าตัวนับปัจจุบัน `_` นำหน้าหมายถึง private

**`void _incrementCounter()`**

```dart
void _incrementCounter() {
  setState(() {
    _counter++;
  });
}
```

- เพิ่มค่า `_counter` ขึ้น 1
- ครอบด้วย `setState(() {...})` เพื่อบอก Flutter ว่า State เปลี่ยนแล้ว ให้วาด UI ใหม่
- ถ้าแก้ `_counter++` โดยไม่ผ่าน `setState` ค่าจะเปลี่ยนแต่หน้าจอจะไม่อัปเดต

**`Widget build(BuildContext context)`**

```dart
return Scaffold(
  appBar: AppBar(title: Text(widget.title)),
  body: Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('You have pushed the button this many times:'),
        Text('$_counter',
          style: Theme.of(context).textTheme.headlineMedium),
      ],
    ),
  ),
  floatingActionButton: FloatingActionButton(
    onPressed: _incrementCounter,
    tooltip: 'Increment',
    child: const Icon(Icons.add),
  ),
);
```

- **`Scaffold`** — โครงหน้าพื้นฐาน มี AppBar, Body, FAB
- **`Center` + `Column`** — จัดให้เนื้อหาอยู่กลางหน้าจอในแนวตั้ง
- **`Text('$_counter')`** — แสดงค่า `_counter` ปัจจุบัน ทุกครั้งที่ `setState()` ถูกเรียก บรรทัดนี้จะถูกวาดใหม่
- **`FloatingActionButton`** — ปุ่มกลม ผูก `onPressed` กับ `_incrementCounter`

---

## วิธีรัน

```bash
flutter run
```
