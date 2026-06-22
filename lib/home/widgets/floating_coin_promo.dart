import 'package:flutter/material.dart';

class FloatingCoinPromo extends StatefulWidget {
  const FloatingCoinPromo({super.key});

  @override
  State<FloatingCoinPromo> createState() => _FloatingCoinPromoState();
}

class _FloatingCoinPromoState extends State<FloatingCoinPromo> {
  // Variabel untuk melacak apakah gambar masih tampil atau sudah diclose
  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    // Jika _isVisible false (tombol X sudah ditekan), hilangkan widget
    if (!_isVisible) return const SizedBox.shrink();

    // Positioned ini mengatur posisi gambar melayang (di kanan bawah)
    return Positioned(
      bottom: 20, // Jarak dari bawah layar
      right: 15,  // Jarak dari kanan layar
      child: Stack(
        clipBehavior: Clip.none, // Agar tombol X yang menonjol keluar tidak terpotong
        children: [
          
          // ==========================================
          // 1. GAMBAR UTAMA PROMO
          // ==========================================
          GestureDetector(
            onTap: () {
              // Aksi ketika gambar promonya ditekan (misal: buka halaman promo)
            },
            child: Image.asset(
              'assets/images/100rb_koin.png', 
              width: 100, // Sesuaikan ukuran lebarnya
              fit: BoxFit.contain,
              // Fallback jika gambar belum ada
              errorBuilder: (c, e, s) => Container(
                width: 100, height: 100, 
                decoration: BoxDecoration(color: Colors.blue.shade900, borderRadius: BorderRadius.circular(50)),
                alignment: Alignment.center,
                child: const Text('100Rb\nKoin', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ),

          // ==========================================
          // 2. TOMBOL CLOSE (X) MERAH DI KANAN ATAS
          // ==========================================
          Positioned(
            top: -5,
            right: -5,
            child: GestureDetector(
              onTap: () {
                // Saat ditekan, ubah status menjadi tidak terlihat
                setState(() {
                  _isVisible = false;
                });
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFEE4D2D), // Warna merah Shopee
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(4),
                child: const Icon(Icons.close, color: Colors.white, size: 14),
              ),
            ),
          ),

          // ==========================================
          // 3. BADGE NOTIFIKASI (!) MERAH DI KIRI ATAS
          
        ],
      ),
    );
  }
}