# Flutter Application 4 — Weather App

## ภาพรวม

แอปพยากรณ์อากาศที่ดึงข้อมูลจริงจาก **Open-Meteo API** เลือกสถานที่แบบลำดับชั้น 4 ระดับ และแสดงข้อมูลอากาศแบบ real-time, รายชั่วโมง และ 7 วัน

---

## โครงสร้างไฟล์

```
flutter_application_4/
└── lib/
    ├── main.dart               ← รวม Model, Service, Widget ทั้งหมดไว้ในไฟล์เดียว
    ├── models/
    │   └── weather_models.dart ← Data Models (แยกไว้แต่ไม่ได้ใช้ใน main)
    ├── services/
    │   └── weather_service.dart← WeatherService class (แยกไว้ แต่ main ใช้ version ของตัวเอง)
    ├── providers/
    │   └── weather_provider.dart
    └── data/
        └── th_cities.dart
```

> หมายเหตุ: โค้ดหลักทั้งหมด (Model, Service, UI) รวมอยู่ใน `main.dart` ไฟล์เดียว

---

## อธิบาย Code: `main.dart`

### Data Models (ในไฟล์ main.dart)

**`class WeatherData`** — เก็บข้อมูลอากาศทั้งหมดที่ได้จาก API

```dart
final double currentTemp;  // อุณหภูมิปัจจุบัน
final double wind;         // ความเร็วลม (km/h)
final int code;            // รหัสสภาพอากาศ (0=Clear, 3=Cloudy, 95=Thunderstorm ฯลฯ)
final List<Hourly> hourly; // ข้อมูลรายชั่วโมง (12 ชม.)
final List<Daily> daily;   // ข้อมูลรายวัน (7 วัน)
```

**`class Hourly`** — เก็บข้อมูล 1 ชั่วโมง: `time` และ `temp`

**`class Daily`** — เก็บข้อมูล 1 วัน: `date`, `max`, `min`

**`class LocationNode`** — โหนดข้อมูลสถานที่แบบ tree structure

```dart
final String name;
final List<LocationNode> children;  // ระดับถัดไป (ว่างถ้าเป็น leaf)
final double? lat;                  // latitude — มีเฉพาะระดับสุดท้าย
final double? lon;                  // longitude
bool get isLeaf => lat != null && lon != null;  // true ถ้าเป็นสถานที่จริง
```

ใช้โครงสร้าง tree เพื่อให้ dropdown 4 ระดับ: ประเทศ → จังหวัด → เขต → ตำบล

---

### `const List<LocationNode> locationTree`

ข้อมูลสถานที่แบบ hardcode ที่รองรับ Thailand (Bangkok, Chiang Mai, Phuket) และ Japan (Tokyo)
แต่ละ leaf node มีพิกัด `lat`/`lon` จริงสำหรับเรียก API

---

### `Future<WeatherData> fetchWeather({lat, lon, useCelsius})`

ฟังก์ชัน async ที่ดึงข้อมูลอากาศจาก Open-Meteo API

```dart
final uri = Uri.parse("https://api.open-meteo.com/v1/forecast").replace(
  queryParameters: {
    "latitude": lat.toString(),
    "longitude": lon.toString(),
    "current": "temperature_2m,wind_speed_10m,weather_code",
    "hourly": "temperature_2m",
    "daily": "temperature_2m_max,temperature_2m_min",
    "forecast_days": "7",
    "temperature_unit": useCelsius ? "celsius" : "fahrenheit",
  },
);
final res = await http.get(uri);
```

- สร้าง URL พร้อม query parameters แล้วยิง GET request
- parse JSON response แปลงเป็น `WeatherData`
- เลือกแค่ 12 ชั่วโมงแรกจาก hourly data: `final hourlyCount = times.length < 12 ? times.length : 12`

---

### `class WeatherApp extends StatefulWidget`

Widget รากที่เก็บ State `useCelsius` (สลับ °C/°F)
ส่งค่า `useCelsius` และ callback `onUnitChanged` ลงไปให้ `HomeScreen`

---

### `class HomeScreen extends StatefulWidget`

หน้าหลักที่มี 4 แท็บ

**State ที่สำคัญ**

```dart
late Future<WeatherData> future;  // Future ของข้อมูลอากาศปัจจุบัน
double lat, lon;                  // พิกัดที่เลือก
String title;                     // ชื่อสถานที่ที่แสดงบน AppBar
int iCountry, iProv, iDist, iSub; // index ของ dropdown แต่ละระดับ
```

**`initState()`** — เรียก `fetchWeather()` ครั้งแรกด้วยพิกัด Bangkok (default)

**`String codeToText(int code)`** — แปลง weather code ตัวเลขเป็นคำอ่านได้

```dart
if (code == 0) return 'Clear';
if (code >= 51 && code <= 67) return 'Rain';
if (code >= 95) return 'Thunderstorm';
```

**`void refresh()`** — สร้าง Future ใหม่ด้วยพิกัดและหน่วยปัจจุบัน ทำให้ `FutureBuilder` โหลดข้อมูลใหม่

**`void applyLeafSelection()`** — เมื่อเลือก dropdown ครบ 4 ระดับ อัปเดต `lat`, `lon`, `title` แล้วเรียก `refresh()`

**`Widget build`** — ครอบด้วย `DefaultTabController` แล้วสร้าง `TabBar` 4 แท็บ:
- แท็บ 1-3 ใช้ `FutureBuilder` แสดง Loading / Error / ข้อมูล
- แท็บ 4 (สถานที่) แสดงได้เลยโดยไม่รอ Future

---

### `class _LocationTab extends StatelessWidget`

UI ของแท็บเลือกสถานที่ ประกอบด้วย Dropdown 4 ระดับ

```dart
onChanged: (c, p, d, s) {
  setState(() { iCountry = c; iProv = p; iDist = d; iSub = s; });
  applyLeafSelection();  // refresh ทันทีเมื่อเลือกสถานที่ครบ
},
```

เมื่อเปลี่ยนระดับบน (เช่น จังหวัด) จะ reset ระดับล่างทั้งหมดเป็น 0 อัตโนมัติ

---

### `class _DropdownRow extends StatelessWidget`

Widget ย่อยสำหรับ 1 แถว dropdown ใช้ซ้ำ 4 ครั้ง รับ `label`, `value`, `items`, `onChanged`

---

## วิธีรัน

```bash
flutter pub get
flutter run
```
