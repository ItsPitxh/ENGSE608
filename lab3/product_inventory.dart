abstract class Product {
  final String _id; // Private field
  String name;
  double _price;
  int stock;
  Product({
    required String id,
    required this.name,
    required double price,
    this.stock = 0,
  })  : _id = id,
        _price = (price > 0) ? price : 0.0;
  // Getter สำหรับ _id
  String get id => _id;
  // Getter และ Setter สำหรับ _price พร้อมตรวจสอบเงื่อนไข
  double get price => _price;
  set price(double value) {
    if (value > 0) {
      _price = value;
    } else {
      print("ราคาไม่ถูกต้อง (ต้อง > 0) -> ไม่เปลี่ยนค่า");
    }
  }
  void applyDiscount(double percentage) {
    if (percentage > 0 && percentage <= 100) {
      _price -= (_price * percentage / 100);
    }
  }
  void restock(int amount) {
    stock += amount;
  }
  void showInfo() {
    print("----------------");
    print("ID: $_id");
    print("Name: $name");
    print("Price: $_price");
    print("Stock: $stock");
  }
}
// Class ลูก: DigitalProduct (สำหรับ E-Book)
class DigitalProduct extends Product {
  double fileSize;
  DigitalProduct({
    required String id,
    required String name,
    required double price,
    required this.fileSize,
  }) : super(id: id, name: name, price: price);
  @override
  void showInfo() {
    print("----------------");
    print("ID: $id");
    print("Name: $name");
    print("Price: $price");
    print("Stock: ยังไม่ระบุสต็อก");
    print("Type: Digital");
    print("File Size: $fileSize MB");
  }
}
// Class ลูก: FoodProduct (สำหรับของสด/อาหาร)
class FoodProduct extends Product {
  String expireDate;
  FoodProduct({
    required String id,
    required String name,
    required double price,
    required int stock,
    required this.expireDate,
  }) : super(id: id, name: name, price: price, stock: stock);
  @override
  void showInfo() {
    print("----------------");
    print("ID: $id");
    print("Name: $name");
    print("Price: $price");
    print("Stock: $stock");
    print("Type: Food");
    print("Expire Date: $expireDate");
  }
}
// Class ทั่วไป (สำหรับสินค้าทั่วไปที่ไม่มีคุณสมบัติพิเศษ)
class GeneralProduct extends Product {
  GeneralProduct({
    required String id,
    required String name,
    required double price,
    required int stock,
  }) : super(id: id, name: name, price: price, stock: stock);
}
void main() {
  // สร้างรายการสินค้า (Polymorphism โดยใช้ List<Product>)
  List<Product> inventory = [];
  // 1. เพิ่มสินค้า Notebook
  var p1 = GeneralProduct(id: "P001", name: "Notebook", price: 50, stock: 50);
  p1.applyDiscount(10); // ลด 10% จาก 50 เหลือ 45
  inventory.add(p1);
  print("New Product created: ${p1.id} (${p1.name})");
  // 2. เพิ่มสินค้า Digital Product
  var d1 = DigitalProduct(id: "D001", name: "E-Book Flutter", price: 199, fileSize: 120.5);
  inventory.add(d1);
  print("New Product created: ${d1.id} (${d1.name})");
  // 3. เพิ่มสินค้า Food Product
  var f1 = FoodProduct(id: "F001", name: "Milk", price: 25, stock: 15, expireDate: "2026-01-10");
  inventory.add(f1);
  print("New Product created: ${f1.id} (${f1.name})");
  // ทดสอบ Setter ป้องกันค่าผิด
  f1.price = -10;
  // แสดงผลข้อมูลสินค้าทั้งหมดโดยใช้ Polymorphism
  for (var item in inventory) {
    item.showInfo();
  }
}
