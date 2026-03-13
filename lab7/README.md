# Lab 7 — Week 12 Navigation + Material Components

## ภาพรวม

โปรเจกต์ Flutter สำหรับฝึกการใช้ **Material 3 Components** และระบบ **Navigation** หลายรูปแบบ โดยแบ่งเนื้อหาออกเป็น 5 หน้า นำทางผ่านทั้ง Bottom Navigation Bar และ Drawer

---

## โครงสร้างไฟล์

```
lab7/
└── lib/
    ├── main.dart
    ├── screens/
    │   ├── home_page.dart          # หน้าหลัก + Navigation
    │   ├── actions_page.dart       # ปุ่มและ Dialog
    │   ├── communication_page.dart # SnackBar, Banner, Dialog
    │   ├── containment_page.dart   # Card, List, Chip
    │   ├── selection_page.dart     # Checkbox, Radio, Switch, Slider
    │   └── form_page.dart          # ฟอร์มเต็มรูปแบบ
    └── widgets/
        └── section_title.dart      # Widget หัวข้อซ้ำๆ
```

---

## หน้าทั้ง 5 และ Widget ที่ฝึก

| หน้า | Widget / Component |
|---|---|
| **Actions** | `FilledButton`, `OutlinedButton`, `IconButton`, `AlertDialog`, Counter |
| **Communication** | `SnackBar`, `Banner`, Dialog แบบต่างๆ |
| **Containment** | `Card`, `ListTile`, `Chip` |
| **Selection** | `Checkbox`, `Radio`, `Switch`, `Slider`, `DropdownMenu` |
| **Form** | `TextFormField`, `DatePicker`, `TimePicker`, `SwitchListTile`, `CheckboxListTile`, Form Validation |

---

## ระบบ Navigation

- **Bottom Navigation Bar** — นำทางด้วยแถบด้านล่าง (Material 3 `NavigationBar`)
- **Navigation Drawer** — เมนูด้านข้างที่เปิดจาก hamburger icon
- **FloatingActionButton** — แสดง index แท็บปัจจุบันผ่าน SnackBar

---

## แนวคิดที่ฝึก

| แนวคิด | รายละเอียด |
|---|---|
| **Material 3** | ใช้ `useMaterial3: true` และ `colorSchemeSeed` |
| **Multi-screen App** | แยก Widget แต่ละหน้าออกเป็นไฟล์ |
| **Navigation Patterns** | BottomNavigationBar + Drawer พร้อมกัน |
| **Form & Validation** | ตรวจสอบ input ก่อน Submit |
| **Date/Time Picker** | `showDatePicker` / `showTimePicker` |

---

## วิธีรัน

```bash
flutter pub get
flutter run
```
