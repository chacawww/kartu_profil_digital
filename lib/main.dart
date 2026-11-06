
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  int jumlahBuka = prefs.getInt('jumlah_buka') ?? 0;
  jumlahBuka++;
  await prefs.setInt('jumlah_buka', jumlahBuka);

  bool isDarkMode = prefs.getBool('dark_mode') ?? false;

  runApp(MyApp(
    jumlahBuka: jumlahBuka,
    isDarkMode: isDarkMode,
  ));
}

class MyApp extends StatefulWidget {
  final int jumlahBuka;
  final bool isDarkMode;

  const MyApp({
    super.key,
    required this.jumlahBuka,
    required this.isDarkMode,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
    isDarkMode = widget.isDarkMode;
  }

  Future<void> ubahTema(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', value);

    setState(() {
      isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kartu Profil Digital',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF91B7AE),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF91B7AE),
          brightness: Brightness.dark,
        ),
      ),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: ProfilePage(
        jumlahBuka: widget.jumlahBuka,
        isDarkMode: isDarkMode,
        onThemeChanged: ubahTema,
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  final int jumlahBuka;
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const ProfilePage({
    super.key,
    required this.jumlahBuka,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kartu Profil Digital',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            tooltip: 'Ganti Tema',
            onPressed: () => onThemeChanged(!isDarkMode),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircleAvatar(
                    radius: 55,
                    backgroundColor: Color(0xFFDCECE5),
                    child: Icon(
                      Icons.person,
                      size: 65,
                      color: Color(0xFF648F81),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Nama Mahasiswa',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('Mahasiswa Teknik Informatika'),
                  const SizedBox(height: 25),
                  const Divider(),
                  const SizedBox(height: 15),
                  const ProfileInfo(
                    icon: Icons.badge_outlined,
                    label: 'NIM',
                    value: 'Masukkan NIM',
                  ),
                  const SizedBox(height: 18),
                  const ProfileInfo(
                    icon: Icons.school_outlined,
                    label: 'Program Studi',
                    value: 'D-IV Teknik Informatika',
                  ),
                  const SizedBox(height: 18),
                  const ProfileInfo(
                    icon: Icons.account_balance_outlined,
                    label: 'Perguruan Tinggi',
                    value: 'Politeknik Negeri Jember',
                  ),
                  const SizedBox(height: 18),
                  const ProfileInfo(
                    icon: Icons.location_on_outlined,
                    label: 'Kota',
                    value: 'Jember',
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 12),
                  const Icon(Icons.visibility_outlined, size: 28),
                  const SizedBox(height: 6),
                  const Text('Jumlah Aplikasi Dibuka'),
                  const SizedBox(height: 4),
                  Text(
                    '$jumlahBuka kali',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ProfileInfo({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 25),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
