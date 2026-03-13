# Flutter Application 4 — Weather App

## ภาพรวม

แอปพยากรณ์อากาศที่ดึงข้อมูลจริงจาก **Open-Meteo API** (ฟรี ไม่ต้อง API Key) สามารถเลือกสถานที่ได้แบบลำดับชั้น (ประเทศ → จังหวัด → เขต → ตำบล) และแสดงข้อมูลอากาศทั้งแบบ real-time, รายชั่วโมง และ 7 วัน

---

## โครงสร้างไฟล์

```
flutter_application_4/
└── lib/
    ├── main.dart
    ├── models/
    │   └── weather_models.dart
    ├── services/
    │   └── weather_service.dart
    ├── providers/
    │   └── weather_provider.dart
    └── data/
        └── th_cities.dart
```

---

## ฟีเจอร์หลัก

- **แท็บ "ตอนนี้"** — อุณหภูมิ, ความเร็วลม, สถานะอากาศ (Clear, Rain, Thunderstorm ฯลฯ)
- **แท็บ "รายชั่วโมง"** — อุณหภูมิ 12 ชั่วโมงแรก
- **แท็บ "7 วัน"** — อุณหภูมิสูงสุด/ต่ำสุดรายวัน
- **แท็บ "สถานที่"** — Dropdown 4 ระดับ (ประเทศ → จังหวัด → เขต/อำเภอ → ตำบล/ย่าน)
- สลับหน่วยอุณหภูมิ **°C / °F** ได้จากหน้า Settings

---

## สถานที่ที่รองรับ

| ประเทศ | จังหวัด/เมือง |
|---|---|
| Thailand | Bangkok, Chiang Mai, Phuket |
| Japan | Tokyo (Shinjuku) |

---

## แนวคิดที่ฝึก

| แนวคิด | รายละเอียด |
|---|---|
| **HTTP / REST API** | ดึงข้อมูลอากาศจาก Open-Meteo |
| **FutureBuilder** | แสดง Loading / Error / Data อัตโนมัติ |
| **TabBar / TabBarView** | นำทางระหว่าง 4 แท็บ |
| **StatefulWidget** | จัดการ State ของ tab index และพิกัดสถานที่ |
| **Model Class** | แยก Data Model ออกจาก UI |

---

## Dependencies

```yaml
dependencies:
  http: ^1.x.x
```

---

## วิธีรัน

```bash
flutter pub get
flutter run
```
