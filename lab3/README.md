# Lab 3 - Product Inventory (Dart OOP)

## ภาพรวม

โปรเจกต์นี้เป็นตัวอย่างการเขียนโปรแกรมเชิงวัตถุ (OOP) ด้วยภาษา Dart โดยจำลองระบบจัดการสินค้าคงคลัง (Product Inventory) ที่ประกอบด้วย Abstract Class, Inheritance, Encapsulation และ Polymorphism

---

## โครงสร้างไฟล์

```
lab3/
└── product_inventory.dart
```

---

## คลาสที่มีในโปรแกรม

### 1. `Product` (Abstract Class)
เป็นคลาสแม่ที่ใช้เป็นแม่แบบสำหรับสินค้าทุกประเภท

**Properties:**
- `_id` — รหัสสินค้า (private, กำหนดได้ครั้งเดียว)
- `name` — ชื่อสินค้า
- `_price` — ราคาสินค้า (private, มี getter/setter)
- `stock` — จำนวนสต็อกสินค้า

**Methods:**
- `applyDiscount(percentage)` — ลดราคาสินค้าตามเปอร์เซ็นต์ที่กำหนด
- `restock(amount)` — เพิ่มจำนวนสต็อกสินค้า
- `showInfo()` — แสดงข้อมูลสินค้า

---

### 2. `GeneralProduct` extends `Product`
สินค้าทั่วไปที่ไม่มีคุณสมบัติพิเศษเพิ่มเติม เช่น สมุดโน้ต, ปากกา

---

### 3. `DigitalProduct` extends `Product`
สินค้าดิจิทัล เช่น E-Book, ซอฟต์แวร์

**Properties เพิ่มเติม:**
- `fileSize` — ขนาดไฟล์ (หน่วย: MB)

---

### 4. `FoodProduct` extends `Product`
สินค้าประเภทอาหารหรือของสด

**Properties เพิ่มเติม:**
- `expireDate` — วันหมดอายุของสินค้า

---

## แนวคิด OOP ที่ใช้

| แนวคิด | รายละเอียด |
|---|---|
| **Abstraction** | `Product` เป็น abstract class ที่ไม่สามารถสร้าง instance ได้โดยตรง |
| **Encapsulation** | `_id` และ `_price` เป็น private field มี getter/setter ป้องกันการแก้ไขค่าผิดพลาด |
| **Inheritance** | `GeneralProduct`, `DigitalProduct`, `FoodProduct` ต่างสืบทอดจาก `Product` |
| **Polymorphism** | ใช้ `List<Product>` เก็บสินค้าต่างประเภท และเรียก `showInfo()` แตกต่างกันตามชนิดจริง |

---

## ตัวอย่างผลลัพธ์

```
New Product created: P001 (Notebook)
New Product created: D001 (E-Book Flutter)
New Product created: F001 (Milk)
ราคาไม่ถูกต้อง (ต้อง > 0) -> ไม่เปลี่ยนค่า
----------------
ID: P001
Name: Notebook
Price: 45.0
Stock: 50
----------------
ID: D001
Name: E-Book Flutter
Price: 199.0
Stock: ยังไม่ระบุสต็อก
Type: Digital
File Size: 120.5 MB
----------------
ID: F001
Name: Milk
Price: 25.0
Stock: 15
Type: Food
Expire Date: 2026-01-10
```

---

## วิธีรันโปรแกรม

ต้องติดตั้ง [Dart SDK](https://dart.dev/get-dart) ก่อน จากนั้นรันด้วยคำสั่ง:

```bash
dart product_inventory.dart
```
