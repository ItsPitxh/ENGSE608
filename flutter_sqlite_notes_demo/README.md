# Flutter SQLite Notes Demo

## ภาพรวม

แอป Flutter สำหรับจดบันทึก (Notes) ที่เก็บข้อมูลลงฐานข้อมูลในเครื่องด้วย **SQLite** ผ่าน `sqflite` package รองรับการสร้าง, แก้ไข และลบโน้ตได้ครบถ้วน โดยใช้สถาปัตยกรรมแบบ Repository Pattern

---

## โครงสร้างไฟล์

```
flutter_sqlite_notes_demo/
└── lib/
    ├── main.dart
    ├── data/
    │   ├── db/
    │   │   └── app_database.dart       # สร้างและจัดการ SQLite DB
    │   ├── models/
    │   │   └── note.dart               # Data Model
    │   └── repositories/
    │       └── note_repository.dart    # CRUD ผ่าน DB
    └── ui/
        ├── home_page.dart              # หน้าแสดงรายการโน้ต
        ├── note_form_page.dart         # ฟอร์มเพิ่ม/แก้ไขโน้ต
        └── state/
            └── note_store.dart         # State Management
```

---

## ฟีเจอร์หลัก

- **แสดงรายการโน้ตทั้งหมด** — แสดง title, content และวันที่แก้ไขล่าสุด
- **เพิ่มโน้ตใหม่** — กรอก title และ content แล้วบันทึกลง SQLite
- **แก้ไขโน้ต** — แตะโน้ตเพื่อเปิดฟอร์มแก้ไข
- **ลบโน้ต** — ลบออกจากฐานข้อมูล

---

## โครงสร้าง Data Model

```dart
class Note {
  int? id
  String title
  String content
  DateTime createdAt
  DateTime updatedAt
}
```

---

## แนวคิดที่ฝึก

| แนวคิด | รายละเอียด |
|---|---|
| **SQLite / sqflite** | เก็บข้อมูลในเครื่องแบบ offline |
| **Repository Pattern** | แยก Logic การเข้าถึง DB ออกจาก UI |
| **Provider** | จัดการ State ด้วย `ChangeNotifier` |
| **CRUD Operations** | Create, Read, Update, Delete ข้อมูล |
| **Multi-screen Navigation** | นำทางระหว่าง Home และ Form |

---

## Dependencies

```yaml
dependencies:
  sqflite: ^2.x.x
  provider: ^6.x.x
  path: ^1.x.x
```

---

## วิธีรัน

```bash
flutter pub get
flutter run
```
