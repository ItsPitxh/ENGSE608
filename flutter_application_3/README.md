# Flutter Application 3 — Layout Demo

## ภาพรวม

โปรเจกต์ Flutter ที่สาธิตการจัด **Layout** โดยทำเป็นหน้าแนะนำสถานที่ท่องเที่ยว (ทะเลสาบ Oeschinen) ประกอบด้วยรูปภาพ, ชื่อสถานที่, ปุ่ม Action และข้อความอธิบาย

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

## Widget ที่ใช้

| Widget | หน้าที่ |
|---|---|
| `ImageSection` | แสดงรูปภาพสถานที่ด้านบน |
| `TitleSection` | แสดงชื่อและที่ตั้ง พร้อมไอคอน Star และจำนวน Rating |
| `ButtonSection` | แถวปุ่ม 3 ปุ่ม (CALL, ROUTE, SHARE) |
| `TextSection` | ย่อหน้าคำอธิบายรายละเอียดสถานที่ |

---

## แนวคิดที่ฝึก

- การแบ่ง UI ออกเป็น Widget ย่อยๆ (Composition)
- การใช้ `Row`, `Column`, `Expanded`, `Padding`
- การใช้ `SingleChildScrollView` สำหรับเนื้อหายาว
- การจัดการ Layout ด้วย `CrossAxisAlignment` และ `MainAxisAlignment`

---

## วิธีรัน

```bash
flutter run
```
