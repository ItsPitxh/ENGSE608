# FakeStore 061 — Flutter E-Commerce App

## ภาพรวม

แอป Flutter ที่เชื่อมต่อกับ **FakeStore API** จำลองระบบร้านค้าออนไลน์ มีระบบ Login พร้อมแยกสิทธิ์ Admin/User จัดการสินค้าและผู้ใช้ผ่าน REST API

---

## โครงสร้างไฟล์

```
fakestore_061/lib/
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

## อธิบาย Code ทีละไฟล์

---

### `main.dart`

จุดเริ่มต้นของแอป ลงทะเบียน Provider 3 ตัวพร้อมกันด้วย `MultiProvider`

```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => UserProvider()),
    ChangeNotifierProvider(create: (_) => ProductProvider()),
  ],
  child: MaterialApp(home: const LoginScreen()),
)
```

- **`MultiProvider`** — ทำให้ Provider หลายตัวใช้งานร่วมกันได้ทั่วทั้งแอป
- แอปเริ่มที่ `LoginScreen` เสมอ

---

### `models/product_model.dart`

**`class ProductModel`** — Data Model สำหรับสินค้า 1 ชิ้น

```dart
final int id;
final String title, description, category, image;
final double price;
```

**`factory ProductModel.fromJson(Map<String, dynamic> json)`** — Static constructor ที่แปลง JSON map เป็น object

```dart
ProductModel.fromJson(json) => ProductModel(
  id: (json['id'] as num).toInt(),
  price: (json['price'] as num?)?.toDouble() ?? 0.0,
  // ...
)
```

ใช้ `as num` แล้วแปลงอีกครั้งเพื่อรองรับทั้ง `int` และ `double` จาก JSON

---

### `models/user_model.dart`

**`class UserModel`** — Data Model สำหรับผู้ใช้ มีโครงสร้างซ้อนกัน

```
UserModel
├── NameModel (firstname, lastname)
└── AddressModel (city, street, number, zipcode)
    └── GeoLocationModel (lat, long)
```

แต่ละ nested class มี `fromJson()` และ `toJson()` เป็นของตัวเอง ทำให้ parse และ serialize ข้อมูลได้ง่าย

**`toJson()`** — แปลง object กลับเป็น JSON Map สำหรับส่งไปยัง API (POST/PUT)

```dart
Map<String, dynamic> toJson() {
  return {
    if (id != null) 'id': id,   // ใส่ id เฉพาะถ้ามีค่า (ไม่ใส่ตอนสร้างใหม่)
    'email': email,
    'name': name.toJson(),
    'address': address.toJson(),
    // ...
  };
}
```

---

### `services/product_api_service.dart`

**`class ProductApiService`** — จัดการ HTTP request สำหรับสินค้า

**`fetchProducts()`** — GET `/products` แล้ว parse list ทั้งหมด

```dart
final List data = jsonDecode(res.body);
return data.map((e) => ProductModel.fromJson(e)).toList();
```

---

### `services/user_api_service.dart`

**`class UserApiService`** — จัดการ HTTP request สำหรับผู้ใช้ รองรับ CRUD ครบ

| Method | Endpoint | คำอธิบาย |
|---|---|---|
| `fetchUsers()` | GET `/users` | ดึงรายชื่อทั้งหมด |
| `fetchUserById(id)` | GET `/users/:id` | ดึงผู้ใช้คนเดียว |
| `createUser(user)` | POST `/users` | สร้างผู้ใช้ใหม่ |
| `updateUser(id, user)` | PUT `/users/:id` | แก้ไขผู้ใช้ |
| `deleteUser(id)` | DELETE `/users/:id` | ลบผู้ใช้ |

---

### `providers/auth_provider.dart`

**`enum AppRole { admin, user }`** — กำหนด Role 2 ประเภท

**`class AuthProvider extends ChangeNotifier`** — จัดการ State การ Login

**`Future<void> login({username, password})`**

ขั้นตอนการทำงาน:
1. ตั้ง `isLoading = true` แล้ว `notifyListeners()` เพื่อแสดง loading spinner
2. ดึง users ทั้งหมดจาก `UserApiService.fetchUsers()`
3. วนหา user ที่ username และ password ตรงกัน
4. ถ้าไม่พบ → ตั้ง `error` message
5. ถ้าพบ → ตั้ง `_isLoggedIn = true` และกำหนด role (`johnd` = admin, อื่นๆ = user)
6. ตั้ง `isLoading = false` แล้ว `notifyListeners()` เพื่ออัปเดต UI

**`void logout()`** — reset state ทั้งหมดกลับเป็นค่าเริ่มต้น

---

### `providers/product_provider.dart`

**`class ProductProvider extends ChangeNotifier`** — จัดการ State ของรายการสินค้า

**`loadProducts()`** — ดึงข้อมูลจาก API แล้วเก็บใน `products` list เรียก `notifyListeners()` หลังโหลดเสร็จหรือ error

---

### `providers/user_provider.dart`

**`class UserProvider extends ChangeNotifier`** — จัดการ State ของรายการผู้ใช้

| Method | คำอธิบาย |
|---|---|
| `loadUsers()` | โหลดรายชื่อทั้งหมดจาก API |
| `addUser(newUser)` | สร้าง User ใหม่ในหน่วยความจำ (simulate API delay 1 วินาที) |
| `editUser(id, updatedUser)` | หา index ใน list แล้วอัปเดตค่า |
| `removeUser(id)` | เรียก API ลบ แล้วเอาออกจาก list |

> `addUser` และ `editUser` ใช้ `Future.delayed` เพื่อจำลอง delay เหมือนรอ API จริง

---

### `screens/login_screen.dart`

หน้า Login พร้อม Form Validation

**หลักการทำงาน:**
1. ผู้ใช้กรอก username/password
2. กด Login → เรียก `context.read<AuthProvider>().login(...)`
3. รอ AuthProvider → ถ้าสำเร็จ redirect ตาม role:
   - Admin → `UserListScreen`
   - User → `ProductListScreen`
4. ถ้า error → แสดงข้อความสีแดง

```dart
if (a.role == AppRole.admin) {
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => UserListScreen()));
} else {
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ProductListScreen()));
}
```

---

### `screens/product_list_screen.dart`

หน้าแสดงสินค้าสำหรับ User ทั่วไป

**`initState()`** — ใช้ `WidgetsBinding.instance.addPostFrameCallback` เพื่อโหลดสินค้าหลัง Widget build เสร็จแล้ว (ป้องกัน setState ระหว่าง build)

**Search bar** — กรองสินค้าด้วย `String search` ผ่าน `.where()`:

```dart
final products = p.products.where((e) {
  return e.title.toLowerCase().contains(search.toLowerCase());
}).toList();
```

**`_productCard(product)`** — Widget การ์ดสินค้าแสดงรูป, ชื่อ, category badge, ราคา และ rating ดาว

---

### `screens/user_list_screen.dart`

หน้าจัดการผู้ใช้สำหรับ Admin

- แสดงรายชื่อผู้ใช้ใน `ListView.separated`
- ปุ่ม Edit → ไปหน้า `UserFormScreen(editUser: u)`
- ปุ่ม Delete → แสดง `AlertDialog` ยืนยันก่อน แล้วเรียก `provider.removeUser(u.id!)`
- FAB `+` → ไปหน้า `UserFormScreen()` เพื่อสร้างผู้ใช้ใหม่

---

### `screens/user_form_screen.dart`

ฟอร์มเพิ่ม/แก้ไขผู้ใช้ ใช้ Modal ร่วมกัน 2 โหมด

**`final UserModel? editUser`** — ถ้าส่งมา = Edit mode, ถ้าไม่ส่ง = Add mode

```dart
bool get isEdit => widget.editUser != null;
```

**`initState()`** — ถ้าเป็น Edit mode จะ pre-fill ค่าในทุก `TextEditingController`

**`_buildUser()`** — รวมค่าจาก controller ทั้งหมดสร้างเป็น `UserModel` object ก่อน submit

**`dispose()`** — คืนหน่วยความจำของทุก Controller เมื่อออกจากหน้า (สำคัญมากเพื่อป้องกัน memory leak)

**`_textField()`** — helper Widget ที่สร้าง `TextFormField` พร้อม style สม่ำเสมอ ใช้ซ้ำแทนที่จะเขียน decoration ทุกครั้ง

---

## วิธีรัน

```bash
flutter pub get
flutter run
```

> **Tip:** ใช้ username `johnd` เพื่อเข้าในฐานะ Admin
