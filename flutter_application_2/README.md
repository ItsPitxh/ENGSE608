# Flutter Application 2 — Peach Counter App

## ภาพรวม

โปรเจกต์ Flutter ที่สาธิตการใช้ **StatefulWidget** และ **setState** โดยทำเป็นแอปนับจำนวน (Counter) ที่ผู้ใช้กดปุ่มแล้วตัวเลขเพิ่มขึ้นทีละ 1

---

## โครงสร้างไฟล์

```
flutter_application_2/
└── lib/
    └── main.dart
```

---

## การทำงาน

แอปแสดงตัวนับจำนวนกลางหน้าจอ เมื่อกดปุ่ม `+` (FloatingActionButton) ตัวเลขจะเพิ่มขึ้น 1 ทุกครั้ง โดยใช้ `setState()` เพื่ออัปเดต UI

---

## แนวคิดที่ฝึก

| แนวคิด | รายละเอียด |
|---|---|
| **StatefulWidget** | Widget ที่มี State เปลี่ยนแปลงได้ |
| **setState()** | สั่งให้ Flutter วาด UI ใหม่เมื่อ State เปลี่ยน |
| **FloatingActionButton** | ปุ่มลอยมุมล่างขวา |
| **Scaffold / AppBar** | โครงสร้างหน้าพื้นฐานของ Material App |

---

## วิธีรัน

```bash
flutter run
```
