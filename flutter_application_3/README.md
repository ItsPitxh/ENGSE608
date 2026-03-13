# Flutter Application 3 — Layout Demo

## ภาพรวม

สาธิตการจัด **Layout** ใน Flutter โดยทำเป็นหน้าแนะนำสถานที่ท่องเที่ยว ประกอบด้วยรูปภาพ, ชื่อสถานที่, ปุ่ม Action และข้อความอธิบาย

---

## โครงสร้างไฟล์

```
flutter_application_3/
├── images/
│   └── lake.jpg
└── lib/
    └── main.dart
```

---

## อธิบาย Code: `main.dart`

### `class MyApp extends StatelessWidget`

Widget รากของแอป กำหนดชื่อแอปว่า `Layout demo` และ `home` เป็น `Scaffold` โดยตรง

```dart
body: const SingleChildScrollView(
  child: Column(
    children: [
      ImageSection(...),
      TitleSection(...),
      ButtonSection(),
      TextSection(...),
    ],
  ),
),
```

- **`SingleChildScrollView`** — ทำให้ scroll ได้ถ้าเนื้อหายาวกว่าหน้าจอ
- **`Column`** — เรียง Widget ลงมาในแนวตั้ง
- แต่ละ Widget ถูกแยกออกเป็นคลาสของตัวเองเพื่อความเป็นระเบียบ (Composition)

---

### `class ImageSection extends StatelessWidget`

รับ `image` (path ของรูป) แล้วแสดงรูปภาพเต็มความกว้าง

```dart
return Image.asset(image, width: 600, height: 240, fit: BoxFit.cover);
```

- **`Image.asset`** — โหลดรูปจากโฟลเดอร์ `assets` ในโปรเจกต์
- **`BoxFit.cover`** — ขยายรูปให้เต็มพื้นที่ที่กำหนดโดยไม่บิดเบี้ยว (ตัดส่วนเกินออก)

---

### `class TitleSection extends StatelessWidget`

รับ `name` (ชื่อสถานที่) และ `location` (ที่ตั้ง) แล้วแสดงเป็นแถวที่มีข้อความซ้ายและไอคอนขวา

```dart
return Padding(
  padding: const EdgeInsets.all(32),
  child: Row(
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
            Text(location, style: TextStyle(color: Colors.grey[500])),
          ],
        ),
      ),
      Icon(Icons.star, color: Colors.red[500]),
      const Text('41'),
    ],
  ),
);
```

- **`Padding`** — เพิ่มระยะห่างรอบๆ เนื้อหา
- **`Row`** — เรียง Widget ขวางในแนวนอน
- **`Expanded`** — ทำให้ Column ด้านซ้ายขยายเต็มพื้นที่ที่เหลือ (ดัน icon ชิดขวา)
- **`crossAxisAlignment.start`** — จัดข้อความชิดซ้ายในแนวขวาง

---

### `class ButtonSection extends StatelessWidget`

แสดงปุ่ม 3 ปุ่ม (CALL, ROUTE, SHARE) เรียงเท่าๆ กันในแนวนอน

```dart
return SizedBox(
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      ButtonWithText(color: color, icon: Icons.call, label: 'CALL'),
      ButtonWithText(color: color, icon: Icons.route, label: 'ROUTE'),
      ButtonWithText(color: color, icon: Icons.share, label: 'SHARE'),
    ],
  ),
);
```

- **`MainAxisAlignment.spaceEvenly`** — แบ่งพื้นที่ให้แต่ละปุ่มเท่ากัน
- สีปุ่มดึงมาจาก `Theme.of(context).primaryColor` เพื่อให้สอดคล้องกับธีมแอป

---

### `class ButtonWithText extends StatelessWidget`

Widget ปุ่มย่อยที่รับ `color`, `icon`, `label` แล้วแสดงไอคอนและข้อความซ้อนกันในแนวตั้ง

```dart
return Column(
  mainAxisSize: MainAxisSize.min,
  children: [
    Icon(icon, color: color),
    Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(label, style: TextStyle(color: color)),
    ),
  ],
);
```

- **`mainAxisSize: MainAxisSize.min`** — ให้ Column มีขนาดพอดีกับเนื้อหา ไม่ขยายเต็ม
- แยกออกมาเป็น class เดียวกันเพื่อใช้ซ้ำ 3 ครั้ง

---

### `class TextSection extends StatelessWidget`

รับ `description` แล้วแสดงข้อความยาวๆ พร้อม padding รอบ

```dart
return Padding(
  padding: const EdgeInsets.all(32),
  child: Text(description, softWrap: true),
);
```

- **`softWrap: true`** — อนุญาตให้ข้อความตัดบรรทัดอัตโนมัติ (ค่าเริ่มต้นก็ `true` อยู่แล้ว)

---

## วิธีรัน

```bash
flutter run
```
