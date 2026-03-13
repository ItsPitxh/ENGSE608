# Flutter SQLite Notes Demo

## ภาพรวม

แอปจดบันทึก (Notes) ที่เก็บข้อมูลในเครื่องด้วย **SQLite** รองรับ CRUD ครบถ้วน ใช้สถาปัตยกรรม Repository Pattern และ Provider สำหรับ State Management

---

## โครงสร้างไฟล์

```
flutter_sqlite_notes_demo/lib/
├── main.dart
├── data/
│   ├── db/
│   │   └── app_database.dart        ← สร้างและเปิด SQLite DB
│   ├── models/
│   │   └── note.dart                ← Data Model
│   └── repositories/
│       └── note_repository.dart     ← CRUD operations
└── ui/
    ├── home_page.dart               ← หน้าแสดงรายการโน้ต
    ├── note_form_page.dart          ← ฟอร์มเพิ่ม/แก้ไขโน้ต
    └── state/
        └── note_store.dart          ← State Management
```

---

## อธิบาย Code ทีละไฟล์

---

### `main.dart`

ลงทะเบียน `NoteRepository` และ `NoteStore` ด้วย `MultiProvider`

```dart
Provider<NoteRepository>(create: (_) => NoteRepository()),
ChangeNotifierProvider<NoteStore>(
  create: (context) => NoteStore(context.read<NoteRepository>()),
),
```

- `NoteRepository` ลงทะเบียนเป็น `Provider` ธรรมดา (ไม่มี State เปลี่ยน)
- `NoteStore` รับ `NoteRepository` ผ่าน `context.read<>()` ใน create (Dependency Injection)

---

### `data/models/note.dart`

**`class Note`** — Data Model ของโน้ต 1 รายการ

```dart
final int? id;          // null ถ้ายังไม่บันทึกลง DB (Auto ID)
final String title;
final String content;
final DateTime createdAt;
final DateTime updatedAt;
```

**`copyWith({...})`** — สร้าง Note object ใหม่โดยเปลี่ยนเฉพาะ field ที่ระบุ ที่เหลือคงเดิม

```dart
final updated = existing.copyWith(title: newTitle, updatedAt: DateTime.now());
```

**`toMap()`** — แปลง object เป็น `Map<String, Object?>` สำหรับเขียนลง SQLite

```dart
{'id': id, 'title': title, 'content': content,
 'created_at': createdAt.toIso8601String(), ...}
```

DateTime เก็บเป็น ISO 8601 String เพราะ SQLite ไม่มี native DateTime type

**`static Note fromMap(Map<String, Object?> map)`** — แปลง Map จาก SQLite กลับเป็น Note object

---

### `data/db/app_database.dart`

**`class AppDatabase`** — Singleton class จัดการ SQLite database instance

```dart
AppDatabase._();                                  // private constructor
static final AppDatabase instance = AppDatabase._(); // instance เดียวทั่วแอป
```

**Singleton Pattern** — ทำให้มี Database connection แค่ 1 ตัวตลอดชีวิตแอป ป้องกัน conflict

**`Future<Database> get database`** — lazy init: เปิด DB ครั้งแรก แล้ว cache ไว้ใน `_db`

```dart
if (_db != null) return _db!;    // ถ้ามีแล้วคืนค่าเดิมเลย
_db = await _openDb();           // ถ้ายังไม่มีค่อยเปิดใหม่
```

**`_openDb()`** — เปิด DB file ที่ `getDatabasesPath()/notes_app.db`

```dart
openDatabase(
  dbPath,
  version: 1,
  onCreate: (db, version) => _createTables(db),  // สร้าง table ครั้งแรก
  onUpgrade: (db, old, new) { ... },              // รองรับ schema migration ในอนาคต
  onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
)
```

**`_createTables(Database db)`** — สร้างตาราง `notes` และ index บน `updated_at`

```sql
CREATE TABLE notes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);
CREATE INDEX idx_notes_updated_at ON notes(updated_at);
```

Index ช่วยให้ query `ORDER BY updated_at DESC` เร็วขึ้น

---

### `data/repositories/note_repository.dart`

**`class NoteRepository`** — Layer ที่คั่นระหว่าง Business Logic กับ SQLite โดยตรง ทำให้เปลี่ยน data source ในอนาคตได้โดยไม่กระทบ UI

| Method | SQL | คำอธิบาย |
|---|---|---|
| `insertNote(note)` | INSERT | แทรกโน้ตใหม่ คืน `id` ที่ได้ |
| `getAllNotes()` | SELECT ORDER BY updated_at DESC | ดึงทั้งหมด เรียงล่าสุดก่อน |
| `getNoteById(id)` | SELECT WHERE id = ? LIMIT 1 | ดึงโน้ต 1 รายการ |
| `updateNote(note)` | UPDATE WHERE id = ? | อัปเดต (ไม่แก้ `created_at`) |
| `deleteNote(id)` | DELETE WHERE id = ? | ลบโน้ต 1 รายการ |
| `deleteAll()` | DELETE (ทั้งตาราง) | ลบทุกรายการ |

```dart
// ตัวอย่าง insertNote — ลบ id ออกเพื่อให้ DB auto generate
db.insert(table, note.toMap()..remove('id'), conflictAlgorithm: ConflictAlgorithm.replace)
```

```dart
// ตัวอย่าง updateNote — ไม่แก้ created_at
db.update(table, note.toMap()..remove('created_at'), where: 'id = ?', whereArgs: [note.id])
```

---

### `ui/state/note_store.dart`

**`class NoteStore extends ChangeNotifier`** — State Management ทั้งหมดของแอป

**State ที่สำคัญ**

```dart
bool _loading = false;  // กำลังโหลดอยู่ไหม
String? _error;         // ข้อความ error (null = ไม่มี error)
List<Note> _notes = []; // รายการโน้ตทั้งหมด
```

ใช้ getter ส่งออก ป้องกัน UI แก้ค่าตรง:

```dart
List<Note> get notes => List.unmodifiable(_notes); // คืน copy ที่แก้ไขไม่ได้
```

**`_setLoading(bool v)`** — helper ที่ตั้ง `_loading` แล้ว `notifyListeners()` ในที่เดียว

**`loadNotes()`** — โหลดรายการโน้ตทั้งหมดจาก repository

**`addNote({title, content})`** — สร้าง `Note` ใหม่พร้อม `createdAt`/`updatedAt` = ตอนนี้ แล้วส่ง repo บันทึก

**`editNote({id, title, content})`** — หา Note เดิมจาก DB ก่อน แล้วใช้ `copyWith()` สร้าง object ใหม่ที่อัปเดตแค่ title/content/updatedAt

**`removeNote(id)`** — ลบ 1 รายการ แล้ว reload list ใหม่

**`clearAll()`** — ลบทั้งหมด reset `_notes = []` โดยตรง ไม่ต้อง reload

---

### `ui/home_page.dart`

หน้าหลักแสดงรายการโน้ตทั้งหมด

**`initState()`** — ใช้ `addPostFrameCallback` เพื่อโหลดโน้ตหลัง Widget สร้างเสร็จแล้ว

**ListView.separated** — แสดงรายการโน้ตพร้อม `SizedBox(height: 10)` คั่นแต่ละรายการ

**ปุ่ม Delete (ไอคอน trash)** — เรียก `store.removeNote(n.id!)` ตรงๆ ไม่ถาม confirm

**ปุ่ม Delete All (AppBar)** — แสดง `AlertDialog` ยืนยันก่อน แล้วเรียก `store.clearAll()`

**`onTap`** — เปิด `NoteFormPage` พร้อมส่ง `noteId`, `initialTitle`, `initialContent` เพื่อแก้ไข

**FAB `+`** — เปิด `NoteFormPage` แบบไม่ส่งค่า = โหมดสร้างใหม่

---

### `ui/note_form_page.dart`

ฟอร์มเพิ่ม/แก้ไขโน้ต ใช้หน้าเดียวกันทั้ง 2 โหมด

```dart
final int? noteId;            // null = Add mode, มีค่า = Edit mode
final String? initialTitle;
final String? initialContent;

bool get _isEdit => widget.noteId != null;
```

**`initState()`** — pre-fill controller ด้วย `initialTitle`/`initialContent` ถ้าเป็น Edit mode

**Form Validation** — ตรวจทั้ง title และ content ห้ามว่าง

**ปุ่ม Save:**

```dart
if (_isEdit) {
  await store.editNote(id: widget.noteId!, title: title, content: content);
} else {
  await store.addNote(title: title, content: content);
}
if (context.mounted) Navigator.pop(context);
```

ตรวจ `context.mounted` ก่อน `Navigator.pop` เพื่อป้องกัน error ถ้า Widget ถูก dispose ไปแล้วระหว่างรอ async

---

## วิธีรัน

```bash
flutter pub get
flutter run
```
