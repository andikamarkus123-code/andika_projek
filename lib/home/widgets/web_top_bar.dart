import 'package:flutter/material.dart';

// ==========================================================
// IMPORT HALAMAN REGISTER DAN LOGIN DI SINI
// Pastikan path (folder) ini sesuai dengan struktur proyek Anda
// ==========================================================
import '../../features/auth/screens/register_screen.dart';
import '../../features/auth/screens/login_screen.dart';


class WebTopBar extends StatelessWidget {
  const WebTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    // Warna Top Bar Shopee biasanya sedikit lebih gelap/merah dari Header utama
    const Color topBarColor = Color(0xFFF53D2D); 

    return Container(
      color: topBarColor,
      height: 34,
      child: Center(
        child: SizedBox(
          width: 1300, // Lebar disamakan dengan WebHeader (1300px)
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ==================================================
              // BAGIAN KIRI: Seller Centre, Mulai Jual, Download
              // ==================================================
              Row(
  children: [
    _topBarText('Seller Centre'),
    _divider(),
    _topBarText('Mulai Jual'),
    _divider(),
    _topBarText('Download'),
    _divider(),
    _topBarText('Ikuti kami di'),
    const SizedBox(width: 6),
    
    // --- Ikon Facebook ---
    Image.asset(
      'assets/images/facebook.png', // Pastikan nama file ini ada di folder assets Anda
      width: 16,
      height: 16,
    ),
    
    const SizedBox(width: 8), // Jarak antar ikon
    
    // --- Ikon Instagram ---
    Image.asset(
      'assets/images/instagram2.png', // Pastikan nama file ini ada di folder assets Anda
      width: 16,
      height: 16,
      errorBuilder: (c, e, s) => const Icon(Icons.camera_alt, color: Colors.white, size: 16), 
    ),
    
    const SizedBox(width: 8), // Jarak antar ikon
    
    // --- Ikon Twitter / X ---
    Image.asset(
      'assets/images/twitter2.png', // Pastikan nama file ini ada di folder assets Anda
      width: 16,
      height: 16,
      errorBuilder: (c, e, s) => const Icon(Icons.flutter_dash, color: Colors.white, size: 16),
    ),
  ],
),
              
              // ==================================================
              // BAGIAN KANAN: Notifikasi, Bantuan, DAFTAR & LOGIN
              // ==================================================
              Row(
                children: [
                  const Icon(Icons.notifications_none, color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  _topBarText('Notifikasi'),
                  _divider(),
                  const Icon(Icons.help_outline, color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  _topBarText('Bantuan'),
                  _divider(),
                  const Icon(Icons.language, color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  _topBarText('Bahasa Indonesia'),
                  const SizedBox(width: 10),
                  
                  // --------------------------------------------------
                  // TOMBOL DAFTAR (MENGARAH KE REGISTER SCREEN)
                  // --------------------------------------------------
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Daftar',
                      style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ),
                  
                  _divider(),
                  
                  // --------------------------------------------------
                  // TOMBOL LOG IN (MENGARAH KE LOGIN SCREEN)
                  // --------------------------------------------------
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Log In',
                      style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widget Helper untuk Teks biasa di Top Bar ---
  Widget _topBarText(String text) {
    return InkWell(
      onTap: () {}, // Berikan efek bisa diklik walau belum ada fungsinya
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 13),
      ),
    );
  }

  // --- Widget Helper untuk Garis Pemisah ( | ) ---
  Widget _divider() {
    return Container(
      height: 12,
      width: 1,
      color: Colors.white54,
      margin: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}