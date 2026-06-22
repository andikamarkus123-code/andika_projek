import 'package:flutter/material.dart';

// Import semua file widget dari folder widgets
import '../widgets/home_header.dart';
import '../widgets/wallet_section.dart';
import '../widgets/menu_section.dart';
import '../widgets/banner_section.dart';
import '../widgets/product_grid.dart';
import '../widgets/floating_coin_promo.dart'; // Pastikan Anda sudah membuat file ini

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color shopeeOrange = Color(0xFFEE4D2D); // Warna oranye khas Shopee

    return Scaffold(
      body: SafeArea(
        // ==========================================
        // STACK: Digunakan agar promo melayang di atas konten
        // ==========================================
        child: Stack(
          children: [
            
            // ------------------------------------------
            // LAPISAN 1: KONTEN UTAMA (YANG BISA DI-SCROLL)
            // ------------------------------------------
            CustomScrollView(
              slivers: [
                // 1. Header dengan Background Pattern & Efek Pudar Kanan-Kiri
                SliverAppBar(
                  floating: true,
                  pinned: true,
                  backgroundColor: shopeeOrange,
                  toolbarHeight: 75.0, // Tinggi header agar motif lebih kelihatan
                  
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      // 1a. Bagian ini untuk menggambar motif batik berulang
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/motif_batik.png'),
                          repeat: ImageRepeat.repeat,
                          scale: 3.5, 
                        ),
                      ),
                      // 1b. Bagian ini untuk memberikan efek pudar (Gradient) di atas motif
                      foregroundDecoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,  // Dimulai dari kiri
                          end: Alignment.centerRight,    // Menuju ke kanan
                          colors: [
                            shopeeOrange,        // Solid oranye di paling kiri (0%)
                            Colors.transparent,  // Memudar jadi transparan
                            Colors.transparent,  // Tetap transparan
                            shopeeOrange,        // Kembali menjadi solid oranye di paling kanan (100%)
                          ],
                          stops: [0.0, 0.30, 0.70, 1.0], 
                        ),
                      ),
                    ),
                  ),

                  title: const HomeHeader(), // Menampilkan search bar
                  
                  // Ikon Actions diubah menggunakan Assets
                  actions: [
                    // --- Ikon Keranjang dari Assets ---
                    IconButton(
                      icon: Image.asset(
                        'assets/images/cart3.png', // Sesuaikan nama file keranjang Anda
                        width: 24,
                        height: 24,
                        errorBuilder: (c, e, s) => const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                      ),
                      onPressed: () {},
                    ),
                    
                    // --- Ikon Chat dari Assets ---
                    IconButton(
                      icon: Image.asset(
                        'assets/images/message1.png', // Sesuaikan nama file chat Anda
                        width: 24,
                        height: 24,
                        errorBuilder: (c, e, s) => const Icon(Icons.chat_outlined, color: Colors.white),
                      ),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 8), // Sedikit jarak ke tepi kanan layar
                  ],
                ),

                // 2. Konten Utama Tengah (Scrollable)
                SliverToBoxAdapter(
                  child: Column(
                    children: const [
                      WalletSection(), // ShopeePay, Koin, SPayLater
                      SizedBox(height: 10),
                      MenuSection(),   // Menu ikon lingkaran
                      SizedBox(height: 10),
                      BannerSection(), // Slider banner promo
                      SizedBox(height: 10),
                    ],
                  ),
                ),

                // 3. Grid Produk (2 Kolom)
                const ProductGrid(), 
              ],
            ),

            // ------------------------------------------
            // LAPISAN 2: WIDGET MELAYANG (PROMO KOIN)
            // ------------------------------------------
            const FloatingCoinPromo(),
            
          ],
        ),
      ),
    );
  }
}