# FakeStore 061 — Flutter E-Commerce App

## ภาพรวม

แอป Flutter ที่เชื่อมต่อกับ **FakeStore API** (https://fakestoreapi.com) เพื่อจำลองระบบร้านค้าออนไลน์ มีระบบ Login พร้อมแยกสิทธิ์ผู้ใช้ระหว่าง **Admin** และ **User** และจัดการข้อมูลสินค้า/ผู้ใช้ผ่าน REST API

---

## โครงสร้างไฟล์

```
fakestore_061/
└── lib/
    ├── main.dart
    ├── models/
    │   ├── product_model.dart
    │   └── user_model.dart
    ├── providers/
    │   ├── auth_provider.dart
    │   ├── product_provider.dart
    │   └── user_provider.dart
    ├── screens/
    │   ├── login_screen.dart
    │   ├── product_list_screen.dart
    │   ├── user_list_screen.dart
    │   └── user_form_screen.dart
    └── services/
        ├── product_api_service.dart
        └── user_api_service.dart
```

---

## ฟีเจอร์หลัก

- **Login Screen** — กรอก username/password ตรวจสอบผ่าน FakeStore API
- **Role-based Navigation** — Admin เห็นหน้าจัดการ User, User ทั่วไปเห็นหน้าสินค้า
- **Product List** — แสดงรายการสินค้าจาก API
- **User List** (Admin only) — แสดง/แก้ไขข้อมูลผู้ใช้ทั้งหมด
- **User Form** — ฟอร์มเพิ่ม/แก้ไขข้อมูลผู้ใช้

---

## สิทธิ์การใช้งาน

| Role | หน้าที่เข้าได้ |
|---|---|
| **Admin** (`johnd`) | User List, User Form |
| **User** (ทั่วไป) | Product List |

---

## แนวคิดที่ฝึก

| แนวคิด | รายละเอียด |
|---|---|
| **Provider** | จัดการ State ด้วย `ChangeNotifier` |
| **MultiProvider** | ลงทะเบียน Provider หลายตัวพร้อมกัน |
| **REST API** | GET/POST/PUT ผ่าน FakeStore API |
| **Role-based UI** | แสดง/ซ่อน หน้าตาม Role |
| **Form Validation** | ตรวจสอบ input ก่อน submit |

---

## Dependencies

```yaml
dependencies:
  provider: ^6.x.x
  http: ^1.x.x
```

---

## วิธีรัน

```bash
flutter pub get
flutter run
```

> **Tip:** ใช้ username `johnd` เพื่อเข้าในฐานะ Admin
