
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  int jumlahBuka = prefs.getInt('jumlah_buka') ?? 0;
  jumlahBuka++;
  await prefs.setInt('jumlah_buka', jumlahBuka);

  bool isDarkMode = prefs.getBool('dark_mode') ?? false;

  String? dataProfil = prefs.getString('data_profil');

  Map<String, dynamic> profil = dataProfil != null
      ? jsonDecode(dataProfil)
      : {
          'nama': 'Nama Mahasiswa',
          'nim': 'Masukkan NIM',
          'prodi': 'D-IV Teknik Informatika',
          'kampus': 'Politeknik Negeri Jember',
          'kota': 'Jember',
        };

  runApp(MyApp(
    jumlahBuka: jumlahBuka,
    isDarkMode: isDarkMode,
    profil: profil,
  ));
}

class MyApp extends StatefulWidget {
  final int jumlahBuka;
  final bool isDarkMode;
  final Map<String, dynamic> profil;

  const MyApp({
    super.key,
    required this.jumlahBuka,
    required this.isDarkMode,
    required this.profil,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool isDarkMode;
  late Map<String, dynamic> profil;

  @override
  void initState() {
    super.initState();
    isDarkMode = widget.isDarkMode;
    profil = Map<String, dynamic>.from(widget.profil);
  }

  Future<void> ubahTema(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', value);

    setState(() {
      isDarkMode = value;
    });
  }

  Future<void> simpanProfil(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('data_profil', jsonEncode(data));

    setState(() {
      profil = data;
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
        profil: profil,
        onThemeChanged: ubahTema,
        onSave: simpanProfil,
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  final int jumlahBuka;
  final bool isDarkMode;
  final Map<String, dynamic> profil;
  final ValueChanged<bool> onThemeChanged;
  final ValueChanged<Map<String, dynamic>> onSave;

  const ProfilePage({
    super.key,
    required this.jumlahBuka,
    required this.isDarkMode,
    required this.profil,
    required this.onThemeChanged,
    required this.onSave,
  });

  void bukaForm(BuildContext context) {
    final namaController = TextEditingController(text: profil['nama']);
    final nimController = TextEditingController(text: profil['nim']);
    final prodiController = TextEditingController(text: profil['prodi']);
    final kampusController = TextEditingController(text: profil['kampus']);
    final kotaController = TextEditingController(text: profil['kota']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profil'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: namaController,
                decoration: const InputDecoration(labelText: 'Nama'),
              ),
              TextField(
                controller: nimController,
                decoration: const InputDecoration(labelText: 'NIM'),
              ),
              TextField(
                controller: prodiController,
                decoration: const InputDecoration(labelText: 'Program Studi'),
              ),
              TextField(
                controller: kampusController,
                decoration: const InputDecoration(labelText: 'Perguruan Tinggi'),
              ),
              TextField(
                controller: kotaController,
                decoration: const InputDecoration(labelText: 'Kota'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              onSave({
                'nama': namaController.text,
                'nim': nimController.text,
                'prodi': prodiController.text,
                'kampus': kampusController.text,
                'kota': kotaController.text,
              });
              Navigator.pop(context);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

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
                  Text(
                    profil['nama'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('Mahasiswa Teknik Informatika'),
                  const SizedBox(height: 25),
                  const Divider(),
                  const SizedBox(height: 15),
                  ProfileInfo(
                    icon: Icons.badge_outlined,
                    label: 'NIM',
                    value: profil['nim'],
                  ),
                  const SizedBox(height: 18),
                  ProfileInfo(
                    icon: Icons.school_outlined,
                    label: 'Program Studi',
                    value: profil['prodi'],
                  ),
                  const SizedBox(height: 18),
                  ProfileInfo(
                    icon: Icons.account_balance_outlined,
                    label: 'Perguruan Tinggi',
                    value: profil['kampus'],
                  ),
                  const SizedBox(height: 18),
                  ProfileInfo(
                    icon: Icons.location_on_outlined,
                    label: 'Kota',
                    value: profil['kota'],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () => bukaForm(context),
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Profil'),
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
  