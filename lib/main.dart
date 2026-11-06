
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  int jumlahBuka = prefs.getInt('jumlah_buka') ?? 0;
  jumlahBuka++;

  await prefs.setInt('jumlah_buka', jumlahBuka);

  runApp(MyApp(jumlahBuka: jumlahBuka));
}

class MyApp extends StatelessWidget {
  final int jumlahBuka;

  const MyApp({super.key, required this.jumlahBuka});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kartu Profil Digital',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF91B7AE),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F7F4),
      ),
      home: ProfilePage(jumlahBuka: jumlahBuka),
    );
  }
}

class ProfilePage extends StatelessWidget {
  final int jumlahBuka;

  const ProfilePage({super.key, required this.jumlahBuka});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kartu Profil Digital',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFF5F7F4),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            color: Colors.white,
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
                      color: Color(0xFF344C43),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Mahasiswa Teknik Informatika',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
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
                  const Icon(
                    Icons.visibility_outlined,
                    color: Color(0xFF648F81),
                    size: 28,
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Jumlah Aplikasi Dibuka',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$jumlahBuka kali',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF344C43),
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
        Icon(icon, color: const Color(0xFF648F81), size: 25),
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
