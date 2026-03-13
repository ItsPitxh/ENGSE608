# Flutter Application 1 — Pich-app (Hello World)

## ภาพรวม

โปรเจกต์ Flutter เริ่มต้นที่แสดงข้อความ "Pich-app" บนหน้าจอ เป็นตัวอย่างการสร้าง Flutter App พื้นฐานที่สุด

---

## โครงสร้างไฟล์

```
flutter_application_1/
└── lib/
    └── main.dart
```

---

## อธิบาย Code: `main.dart`

### `void main()`

```dart
void main() {
  const app = MaterialApp(
    title: 'Pich-app',
    home: Text('Pich-app'),
  );
  runApp(app);
}
```

- **`main()`** — จุดเริ่มต้นของทุก Dart program Flutter จะเริ่มทำงานจากที่นี่
- **`MaterialApp`** — Widget หลักที่ครอบทั้งแอป ทำให้ใช้ Material Design ได้ พารามิเตอร์ `title` คือชื่อแอปที่แสดงใน task switcher, `home` คือ Widget แรกที่แสดงผล
- **`Text('Pich-app')`** — Widget แสดงข้อความ วางเป็น `home` ตรงๆ โดยไม่ผ่าน `Scaffold`
- **`runApp(app)`** — ฟังก์ชัน Flutter ที่รับ Widget แล้วแสดงผลบนหน้าจอเต็มจอ

> สังเกตว่าใช้ `const` ได้เพราะค่าทุกอย่างถูกกำหนดตายตัวตั้งแต่ compile time

---

## วิธีรัน

```bash
flutter run
```
