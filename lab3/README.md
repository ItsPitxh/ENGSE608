# Lab 3 - Product Inventory (Dart OOP)

## ภาพรวม

โปรเจกต์นี้เป็นตัวอย่างการเขียนโปรแกรมเชิงวัตถุ (OOP) ด้วยภาษา Dart โดยจำลองระบบจัดการสินค้าคงคลัง ประกอบด้วย Abstract Class, Inheritance, Encapsulation และ Polymorphism

---

## โครงสร้างไฟล์

```
lab3/
└── product_inventory.dart
```

---

## แนวคิด OOP ที่ใช้

| แนวคิด | รายละเอียด |
|---|---|
| **Abstraction** | `Product` เป็น abstract class สร้าง instance โดยตรงไม่ได้ |
| **Encapsulation** | `_id` และ `_price` เป็น private field มี getter/setter ป้องกันค่าผิด |
| **Inheritance** | 3 คลาสลูกสืบทอดจาก `Product` |
| **Polymorphism** | `List<Product>` เก็บสินค้าต่างชนิด และเรียก `showInfo()` แตกต่างกันตามชนิดจริง |

---

## อธิบาย Code ทีละส่วน

### `abstract class Product`

คลาสแม่ที่เป็นแม่แบบของสินค้าทุกประเภท ไม่สามารถ `new Product()` ได้โดยตรง

```dart
final String _id;   // private — กำหนดครั้งเดียวตอนสร้าง ห้ามแก้ไขทีหลัง
String name;        // public — แก้ไขได้อิสระ
double _price;      // private — แก้ไขผ่าน setter เท่านั้น
int stock;          // public — จำนวนสต็อก
```

**Constructor**

```dart
Product({required String id, required this.name, required double price, this.stock = 0})
  : _id = id,
    _price = (price > 0) ? price : 0.0;
```

- รับ `id` มาเก็บใน `_id` ผ่าน initializer list (`:`)
- ถ้า `price <= 0` จะตั้งราคาเป็น `0.0` อัตโนมัติ
- `stock` มีค่าเริ่มต้นเป็น `0` ถ้าไม่ส่งมา

**Getter/Setter สำหรับ `_price`**

```dart
double get price => _price;           // อ่านค่าได้

set price(double value) {
  if (value > 0) {
    _price = value;                   // ยอมรับเฉพาะค่ามากกว่า 0
  } else {
    print("ราคาไม่ถูกต้อง ...");     // ปฏิเสธค่าไม่ถูกต้อง
  }
}
```

**`applyDiscount(double percentage)`**

ลดราคาตามเปอร์เซ็นต์ที่กำหนด เช่น `applyDiscount(10)` ลด 10%

```dart
_price -= (_price * percentage / 100);
```

ตรวจว่า `0 < percentage <= 100` ก่อนทุกครั้ง

**`restock(int amount)`**

เพิ่มสต็อกสินค้าโดยบวกค่า `amount` เข้า `stock` ตรงๆ

**`showInfo()`**

แสดงข้อมูลสินค้าพื้นฐาน — ID, ชื่อ, ราคา, สต็อก คลาสลูกจะ `@override` ฟังก์ชันนี้เพื่อแสดงข้อมูลเพิ่มเติมของตนเอง

---

### `class GeneralProduct extends Product`

สินค้าทั่วไปที่ไม่มีคุณสมบัติพิเศษเพิ่มเติม เช่น สมุด, ปากกา

ไม่มี field หรือ method เพิ่มเลย แค่เรียก `super(...)` ส่งต่อ constructor ให้ `Product` จัดการ ใช้ `showInfo()` จาก `Product` ได้เลย

---

### `class DigitalProduct extends Product`

สินค้าดิจิทัล เช่น E-Book, ซอฟต์แวร์

**Field เพิ่มเติม**

```dart
double fileSize;   // ขนาดไฟล์ (MB)
```

**`@override showInfo()`**

แสดงข้อมูลเพิ่มเติมคือ `Type: Digital` และ `File Size: ... MB`
ไม่แสดง Stock เพราะสินค้าดิจิทัลไม่มีสต็อก จะแสดงว่า `"ยังไม่ระบุสต็อก"` แทน

---

### `class FoodProduct extends Product`

สินค้าประเภทอาหารหรือของสด

**Field เพิ่มเติม**

```dart
String expireDate;   // วันหมดอายุ เช่น "2026-01-10"
```

**`@override showInfo()`**

แสดงข้อมูลเพิ่มเติมคือ `Type: Food` และ `Expire Date: ...`

---

### `void main()`

ฟังก์ชันหลักที่รันเมื่อเริ่มโปรแกรม

**สร้างสินค้าและเพิ่มเข้า inventory**

```dart
List<Product> inventory = [];
```

ใช้ `List<Product>` เก็บสินค้าต่างชนิดรวมกัน — นี่คือ Polymorphism ที่ทำให้ `GeneralProduct`, `DigitalProduct`, `FoodProduct` อยู่ใน list เดียวกันได้

```dart
var p1 = GeneralProduct(id: "P001", name: "Notebook", price: 50, stock: 50);
p1.applyDiscount(10);   // ราคา 50 → 45
inventory.add(p1);
```

```dart
var d1 = DigitalProduct(id: "D001", name: "E-Book Flutter", price: 199, fileSize: 120.5);
inventory.add(d1);
```

```dart
var f1 = FoodProduct(id: "F001", name: "Milk", price: 25, stock: 15, expireDate: "2026-01-10");
inventory.add(f1);
```

**ทดสอบ Setter ป้องกันค่าผิด**

```dart
f1.price = -10;
// → พิมพ์: "ราคาไม่ถูกต้อง (ต้อง > 0) -> ไม่เปลี่ยนค่า"
// ราคาของ f1 ยังคงเป็น 25 เหมือนเดิม
```

**วนแสดงข้อมูลด้วย Polymorphism**

```dart
for (var item in inventory) {
  item.showInfo();   // เรียก showInfo() ของแต่ละ class จริงๆ ไม่ใช่ของ Product
}
```

เมื่อ `item` จริงๆ เป็น `DigitalProduct` → เรียก `DigitalProduct.showInfo()`
เมื่อ `item` จริงๆ เป็น `FoodProduct` → เรียก `FoodProduct.showInfo()`

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

## วิธีรัน

```bash
dart product_inventory.dart
```
