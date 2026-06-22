import 'package:flutter/material.dart';
import '../../../home/screens/home_screen.dart';
import '../../../core/widgets/responsive_layout.dart';
import 'web_home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const Center(child: Text('Live & Video Page')),
    const Center(child: Text('Notifikasi Page')),
    const Center(child: Text('Saya Page')),
  ];

  @override
  Widget build(BuildContext context) {
    // 1. Bungkus UI Mobile (Scaffold) Anda ke dalam sebuah variabel
    Widget mobileUI = Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: const Color(0xFFEE4D2D),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: [ 
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/home.png', width: 24, height: 24), 
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/live.png', width: 24, height: 24), 
            label: 'Live & Video',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/notification.png', width: 24, height: 24), 
            label: 'Notifikasi',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/profile.png', width: 24, height: 24), 
            label: 'Saya',
          ),
        ],
      ),
    );

    // 2. Kembalikan ResponsiveLayout. 
    // Flutter akan otomatis mengecek ukuran layar dan menampilkan tampilan yang sesuai!
    return ResponsiveLayout(
      mobileLayout: mobileUI, 
      webLayout: const WebHomeScreen(), 
    );
  }
}