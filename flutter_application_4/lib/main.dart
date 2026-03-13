import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const WeatherApp());

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});
  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  bool useCelsius = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: HomeScreen(
        useCelsius: useCelsius,
        onUnitChanged: (v) => setState(() => useCelsius = v),
      ),
    );
  }
}

/// ===============================
/// MODELS
/// ===============================

class WeatherData {
  final double currentTemp;
  final double wind;
  final int code;
  final List<Hourly> hourly;
  final List<Daily> daily;

  WeatherData({
    required this.currentTemp,
    required this.wind,
    required this.code,
    required this.hourly,
    required this.daily,
  });
}

class Hourly {
  final DateTime time;
  final double temp;
  Hourly(this.time, this.temp);
}

class Daily {
  final DateTime date;
  final double max;
  final double min;
  Daily(this.date, this.max, this.min);
}

/// โหนดสถานที่ (ประเทศ -> จังหวัด/รัฐ -> เขต/อำเภอ -> ตำบล/ย่าน)
class LocationNode {
  final String name;
  final List<LocationNode> children;
  final double? lat;
  final double? lon;

  const LocationNode({
    required this.name,
    this.children = const [],
    this.lat,
    this.lon,
  });

  bool get isLeaf => lat != null && lon != null;
}

/// ===============================
/// SAMPLE LOCATION DATA (POC)
/// ===============================
/// หมายเหตุ: ในงานจริงให้ดึงจากไฟล์/ฐานข้อมูล/Geo API ได้ แต่ตอนนี้เป็น POC
const List<LocationNode> locationTree = [
  LocationNode(
    name: 'Thailand',
    children: [
      LocationNode(
        name: 'Bangkok',
        children: [
          LocationNode(
            name: 'Pathum Wan (เขตปทุมวัน)',
            children: [
              LocationNode(name: 'Lumphini', lat: 13.7309, lon: 100.5410),
              LocationNode(name: 'Wang Mai', lat: 13.7339, lon: 100.5267),
            ],
          ),
          LocationNode(
            name: 'Phra Nakhon (เขตพระนคร)',
            children: [
              LocationNode(name: 'Bowon Niwet', lat: 13.7586, lon: 100.5019),
              LocationNode(name: 'Chana Songkhram', lat: 13.7625, lon: 100.4949),
            ],
          ),
        ],
      ),
      LocationNode(
        name: 'Chiang Mai',
        children: [
          LocationNode(
            name: 'Mueang Chiang Mai (อำเภอเมือง)',
            children: [
              LocationNode(name: 'Si Phum', lat: 18.7883, lon: 98.9853),
              LocationNode(name: 'Suthep', lat: 18.7891, lon: 98.9539),
            ],
          ),
        ],
      ),
      LocationNode(
        name: 'Phuket',
        children: [
          LocationNode(
            name: 'Mueang Phuket (อำเภอเมือง)',
            children: [
              LocationNode(name: 'Talat Yai', lat: 7.8841, lon: 98.3923),
              LocationNode(name: 'Wichit', lat: 7.8894, lon: 98.3727),
            ],
          ),
        ],
      ),
    ],
  ),
  LocationNode(
    name: 'Japan',
    children: [
      LocationNode(
        name: 'Tokyo',
        children: [
          LocationNode(
            name: 'Shinjuku',
            children: [
              LocationNode(name: 'Kabukicho', lat: 35.6950, lon: 139.7035),
              LocationNode(name: 'Nishi-Shinjuku', lat: 35.6900, lon: 139.6920),
            ],
          ),
        ],
      ),
    ],
  ),
];

/// ===============================
/// SERVICE (Open-Meteo)
/// ===============================

Future<WeatherData> fetchWeather({
  required double lat,
  required double lon,
  required bool useCelsius,
}) async {
  final uri = Uri.parse("https://api.open-meteo.com/v1/forecast").replace(
    queryParameters: {
      "latitude": lat.toString(),
      "longitude": lon.toString(),
      "current": "temperature_2m,wind_speed_10m,weather_code",
      "hourly": "temperature_2m",
      "daily": "temperature_2m_max,temperature_2m_min",
      "forecast_days": "7",
      "timezone": "Asia/Bangkok",
      "temperature_unit": useCelsius ? "celsius" : "fahrenheit",
      "wind_speed_unit": "kmh",
    },
  );

  final res = await http.get(uri);
  if (res.statusCode != 200) {
    throw Exception("HTTP ${res.statusCode}: ${res.body}");
  }

  final json = jsonDecode(res.body) as Map<String, dynamic>;

  final current = json["current"] as Map<String, dynamic>;
  final hourly = json["hourly"] as Map<String, dynamic>;
  final daily = json["daily"] as Map<String, dynamic>;

  final times = (hourly["time"] as List).cast<String>();
  final temps = (hourly["temperature_2m"] as List).cast<num>();

  final hourlyCount = times.length < 12 ? times.length : 12;
  final hourlyList = List.generate(hourlyCount, (i) {
    return Hourly(
      DateTime.parse(times[i]),
      temps[i].toDouble(),
    );
  });

  final dTimes = (daily["time"] as List).cast<String>();
  final tMax = (daily["temperature_2m_max"] as List).cast<num>();
  final tMin = (daily["temperature_2m_min"] as List).cast<num>();

  final dailyList = List.generate(dTimes.length, (i) {
    return Daily(
      DateTime.parse(dTimes[i]),
      tMax[i].toDouble(),
      tMin[i].toDouble(),
    );
  });

  return WeatherData(
    currentTemp: (current["temperature_2m"] as num).toDouble(),
    wind: (current["wind_speed_10m"] as num).toDouble(),
    code: (current["weather_code"] as num).toInt(),
    hourly: hourlyList,
    daily: dailyList,
  );
}

/// ===============================
/// HOME (4 TABS)
/// ===============================

class HomeScreen extends StatefulWidget {
  final bool useCelsius;
  final ValueChanged<bool> onUnitChanged;

  const HomeScreen({
    super.key,
    required this.useCelsius,
    required this.onUnitChanged,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<WeatherData> future;

  // ค่าเริ่มต้น (Bangkok)
  double lat = 13.7309;
  double lon = 100.5410;
  String title = "Thailand • Bangkok • Pathum Wan • Lumphini";

  // selection index สำหรับ 4 ระดับ
  int iCountry = 0;
  int iProv = 0;
  int iDist = 0;
  int iSub = 0;

  @override
  void initState() {
    super.initState();
    future = fetchWeather(lat: lat, lon: lon, useCelsius: widget.useCelsius);
  }

  String unit() => widget.useCelsius ? "°C" : "°F";

  String codeToText(int code) {
    if (code == 0) return 'Clear';
    if (code == 1 || code == 2) return 'Partly cloudy';
    if (code == 3) return 'Cloudy';
    if (code >= 51 && code <= 67) return 'Rain';
    if (code >= 71 && code <= 77) return 'Snow';
    if (code >= 95) return 'Thunderstorm';
    return 'Code $code';
  }

  void refresh() {
    setState(() {
      future = fetchWeather(lat: lat, lon: lon, useCelsius: widget.useCelsius);
    });
  }

  LocationNode get country => locationTree[iCountry];
  LocationNode get prov => country.children[iProv];
  LocationNode get dist => prov.children[iDist];
  LocationNode get sub => dist.children[iSub];

  void applyLeafSelection() {
    if (!sub.isLeaf) return;

    lat = sub.lat!;
    lon = sub.lon!;
    title = "${country.name} • ${prov.name} • ${dist.name} • ${sub.name}";
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          bottom: const TabBar(
            tabs: [
              Tab(text: "ตอนนี้"),
              Tab(text: "รายชั่วโมง"),
              Tab(text: "7 วัน"),
              Tab(text: "สถานที่"),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: refresh,
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Settings"),
                    content: SwitchListTile(
                      title: const Text("Use Celsius"),
                      value: widget.useCelsius,
                      onChanged: (v) {
                        widget.onUnitChanged(v);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                );
                refresh();
              },
            ),
          ],
        ),

        // 3 แท็บแรกใช้ข้อมูลอากาศจาก FutureBuilder
        body: FutureBuilder<WeatherData>(
          future: future,
          builder: (context, snap) {
            final weatherTab = () {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snap.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text("Error: ${snap.error}"),
                  ),
                );
              }
              final data = snap.data!;
              return TabBarView(
                children: [
                  // TAB 1: ตอนนี้
                  Center(
                    child: Card(
                      margin: const EdgeInsets.all(16),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "${data.currentTemp.toStringAsFixed(1)} ${unit()}",
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(codeToText(data.code)),
                            const SizedBox(height: 8),
                            Text("Wind ${data.wind.toStringAsFixed(1)} km/h"),
                            const SizedBox(height: 12),
                            Text("lat: ${lat.toStringAsFixed(4)}, lon: ${lon.toStringAsFixed(4)}",
                                style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // TAB 2: รายชั่วโมง (12 ชม.)
                  ListView(
                    children: data.hourly.map((h) {
                      final hh = h.time.hour.toString().padLeft(2, '0');
                      final mm = h.time.minute.toString().padLeft(2, '0');
                      return ListTile(
                        leading: const Icon(Icons.schedule),
                        title: Text("$hh:$mm"),
                        trailing: Text("${h.temp.toStringAsFixed(1)} ${unit()}"),
                      );
                    }).toList(),
                  ),

                  // TAB 3: 7 วัน
                  ListView(
                    children: data.daily.map((d) {
                      return ListTile(
                        leading: const Icon(Icons.calendar_today),
                        title: Text("${d.date.day}/${d.date.month}"),
                        subtitle: Text(
                          "Max ${d.max.toStringAsFixed(1)} / Min ${d.min.toStringAsFixed(1)} ${unit()}",
                        ),
                      );
                    }).toList(),
                  ),

                  // TAB 4: สถานที่ (ไม่พึ่ง snap)
                  _LocationTab(
                    countryIndex: iCountry,
                    provIndex: iProv,
                    distIndex: iDist,
                    subIndex: iSub,
                    onChanged: (c, p, d, s) {
                      setState(() {
                        iCountry = c;
                        iProv = p;
                        iDist = d;
                        iSub = s;
                      });
                      applyLeafSelection();
                    },
                  ),
                ],
              );
            };

            // ต้องคืน TabBarView เสมอ (รวมแท็บสถานที่ด้วย)
            // ถ้า snap ยังไม่พร้อม แท็บสถานที่จะยังใช้งานได้อยู่
            if (snap.connectionState == ConnectionState.waiting && snap.data == null) {
              return TabBarView(
                children: [
                  const Center(child: CircularProgressIndicator()),
                  const Center(child: CircularProgressIndicator()),
                  const Center(child: CircularProgressIndicator()),
                  _LocationTab(
                    countryIndex: iCountry,
                    provIndex: iProv,
                    distIndex: iDist,
                    subIndex: iSub,
                    onChanged: (c, p, d, s) {
                      setState(() {
                        iCountry = c;
                        iProv = p;
                        iDist = d;
                        iSub = s;
                      });
                      applyLeafSelection();
                    },
                  ),
                ],
              );
            }

            return weatherTab();
          },
        ),
      ),
    );
  }
}

/// ===============================
/// LOCATION TAB WIDGET
/// ===============================

class _LocationTab extends StatelessWidget {
  final int countryIndex;
  final int provIndex;
  final int distIndex;
  final int subIndex;

  final void Function(int c, int p, int d, int s) onChanged;

  const _LocationTab({
    required this.countryIndex,
    required this.provIndex,
    required this.distIndex,
    required this.subIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final countries = locationTree;
    final country = countries[countryIndex];

    final provs = country.children;
    final safeProvIndex = provIndex.clamp(0, provs.isEmpty ? 0 : provs.length - 1);
    final prov = provs.isEmpty ? null : provs[safeProvIndex];

    final dists = prov?.children ?? const <LocationNode>[];
    final safeDistIndex = distIndex.clamp(0, dists.isEmpty ? 0 : dists.length - 1);
    final dist = dists.isEmpty ? null : dists[safeDistIndex];

    final subs = dist?.children ?? const <LocationNode>[];
    final safeSubIndex = subIndex.clamp(0, subs.isEmpty ? 0 : subs.length - 1);
    final sub = subs.isEmpty ? null : subs[safeSubIndex];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text("เลือกสถานที่", style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),

        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                // ประเทศ
                _DropdownRow(
                  label: "ประเทศ",
                  value: countryIndex,
                  items: List.generate(countries.length, (i) => countries[i].name),
                  onChanged: (v) {
                    // เปลี่ยนประเทศ -> reset ระดับถัดไปเป็น 0
                    onChanged(v, 0, 0, 0);
                  },
                ),
                const Divider(),

                // จังหวัด/รัฐ
                _DropdownRow(
                  label: "จังหวัด/รัฐ",
                  value: safeProvIndex,
                  items: List.generate(provs.length, (i) => provs[i].name),
                  onChanged: (v) {
                    onChanged(countryIndex, v, 0, 0);
                  },
                ),
                const Divider(),

                // เขต/อำเภอ
                _DropdownRow(
                  label: "เขต/อำเภอ",
                  value: safeDistIndex,
                  items: List.generate(dists.length, (i) => dists[i].name),
                  onChanged: (v) {
                    onChanged(countryIndex, safeProvIndex, v, 0);
                  },
                ),
                const Divider(),

                // ตำบล/ย่าน
                _DropdownRow(
                  label: "ตำบล/ย่าน",
                  value: safeSubIndex,
                  items: List.generate(subs.length, (i) => subs[i].name),
                  onChanged: (v) {
                    onChanged(countryIndex, safeProvIndex, safeDistIndex, v);
                  },
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              sub == null
                  ? "ยังไม่มีข้อมูลตำบล/ย่าน"
                  : (sub.isLeaf
                      ? "พิกัดที่เลือก:\nlat: ${sub.lat}, lon: ${sub.lon}\n\n*เปลี่ยนแล้วระบบจะ refresh ให้อัตโนมัติ"
                      : "โปรดเลือกจนถึงระดับสุดท้าย"),
            ),
          ),
        ),
      ],
    );
  }
}

class _DropdownRow extends StatelessWidget {
  final String label;
  final int value;
  final List<String> items;
  final ValueChanged<int> onChanged;

  const _DropdownRow({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 90, child: Text(label)),
        const SizedBox(width: 8),
        Expanded(
          child: DropdownButton<int>(
            isExpanded: true,
            value: items.isEmpty ? null : value,
            hint: const Text("ไม่มีข้อมูล"),
            items: List.generate(items.length, (i) {
              return DropdownMenuItem<int>(
                value: i,
                child: Text(items[i]),
              );
            }),
            onChanged: items.isEmpty ? null : (v) => onChanged(v ?? 0),
          ),
        ),
      ],
    );
  }
}