import 'package:flutter/material.dart';

class BrandTerlarisWeb extends StatelessWidget {
  const BrandTerlarisWeb({super.key});

  @override
  Widget build(BuildContext context) {
    // Kombinasi warna persis seperti gambar
    const Color bgRed = Color(0xFFD2001A); // Merah background utama
    const Color cardBlue = Color(0xFF143360); // Biru dongker untuk kartu brand
    const Color textYellow = Color(0xFFFFD600); // Kuning untuk diskon
    const Color priceOrange = Color(0xFFEE4D2D); // Oranye khas harga Shopee

    return Container(
      width: double.infinity,
      color: bgRed,
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: SizedBox(
          width: 1200, // Lebar standar konten web Shopee
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ==========================================
              // 1. JUDUL "BRAND TERLARIS"
              // ==========================================
              const Text(
                "BRAND TERLARIS",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 30),

              // ==========================================
              // 2. GRID KARTU BRAND (2 Kolom)
              // ==========================================
              Wrap(
                spacing: 20, // Jarak horizontal antar kartu (Kiri - Kanan)
                runSpacing: 20, // Jarak vertikal antar kartu (Atas - Bawah)
                children: [
                  // --- Kartu 1: Maybelline ---
                  _buildBrandCard(
                    logo: 'assets/images/logo_maybelline.png',
                    brandName: 'Maybelline Indonesia Official S...',
                    discount: 'DISKON S/D 50%',
                    cardColor: cardBlue,
                    textYellow: textYellow,
                    priceOrange: priceOrange,
                    products: [
                      _ProductData(image: 'assets/images/maybelline1.png', price: 'Rp73.200'),
                      _ProductData(image: 'assets/images/maybelline4.png', price: 'Rp179.900'),
                      _ProductData(image: 'assets/images/maybelline3.png', price: 'Rp1.000.00...'),
                    ],
                  ),

                  // --- Kartu 2: Garnier ---
                  _buildBrandCard(
                    logo: 'assets/images/garnier_logo.png',
                    brandName: 'Garnier Indonesia Official Shop',
                    discount: 'DISKON S/D 60%',
                    cardColor: cardBlue,
                    textYellow: textYellow,
                    priceOrange: priceOrange,
                    products: [
                      _ProductData(image: 'assets/images/garnier1.png', price: 'Rp999.985...'),
                      _ProductData(image: 'assets/images/garnier2.png', price: 'Rp58.900'),
                      _ProductData(image: 'assets/images/garnier3.png', price: 'Rp98.900'),
                    ],
                  ),

                  // --- Kartu 3: Colgate ---
                  _buildBrandCard(
                    logo: 'assets/images/logo_colgate.png',
                    brandName: 'Colgate Palmolive Official Shop',
                    discount: 'DISKON S/D 50%',
                    cardColor: cardBlue,
                    textYellow: textYellow,
                    priceOrange: priceOrange,
                    products: [
                      _ProductData(image: 'assets/images/colgate1.png', price: 'Rp1.000.000'),
                      _ProductData(image: 'assets/images/colgate2.png', price: 'Rp93.100'),
                      _ProductData(image: 'assets/images/colgate3.png', price: 'Rp23.300'),
                    ],
                  ),

                  // --- Kartu 4: Fonterra ---
                  _buildBrandCard(
                    logo: 'assets/images/logo_fonterra.png',
                    brandName: 'Fonterra Official Store',
                    discount: 'DISKON S/D 50%',
                    cardColor: cardBlue,
                    textYellow: textYellow,
                    priceOrange: priceOrange,
                    products: [
                      _ProductData(image: 'assets/images/anlene1.png', price: 'Rp89.000'),
                      _ProductData(image: 'assets/images/anlene2.png', price: 'Rp78.200'),
                      _ProductData(image: 'assets/images/boneeto.png', price: 'Rp233.300'),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ========================================================
  // WIDGET HELPER: Membuat Kotak Brand Biru Tua
  // ========================================================
  Widget _buildBrandCard({
    required String logo,
    required String brandName,
    required String discount,
    required Color cardColor,
    required Color textYellow,
    required Color priceOrange,
    required List<_ProductData> products,
  }) {
    return Container(
      width: 590, // Setengah dari 1200px dikurangi spacing
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          // --- HEADER: Logo, Nama, Diskon, & Tombol Shop Now ---
          Row(
            children: [
              // Logo Lingkaran
              Container(
                width: 45,
                height: 45,
                decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                clipBehavior: Clip.hardEdge,
                child: Image.asset(
                  logo,
                  fit: BoxFit.contain,
                  errorBuilder: (c, e, s) => const Icon(Icons.store, color: Colors.grey),
                ),
              ),
              const SizedBox(width: 15),
              
              // Nama Brand & Diskon
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      brandName,
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      discount,
                      style: TextStyle(color: textYellow, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 10),
              
              // Tombol Shop Now Putih
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Shop Now", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    SizedBox(width: 6),
                    Icon(Icons.arrow_forward_ios, size: 12),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),

          // --- BODY: 3 Kotak Produk ---
          Row(
            children: products.map((prod) => _buildProductItem(prod, priceOrange)).toList(),
          ),
        ],
      ),
    );
  }

  // ========================================================
  // WIDGET HELPER: Membuat Kotak Putih Produk & Harga
  // ========================================================
  Widget _buildProductItem(_ProductData product, Color priceOrange) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5), // Jarak antar produk
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          children: [
            // Gambar Produk Persegi
            AspectRatio(
              aspectRatio: 1.0, 
              child: Image.asset(
                product.image,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => const Icon(Icons.image, color: Colors.grey, size: 40),
              ),
            ),
            
            // Teks Harga di bawah gambar
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
              child: Text(
                product.price,
                style: TextStyle(color: priceOrange, fontWeight: FontWeight.bold, fontSize: 16),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Model data sederhana untuk menyimpan URL gambar & harga
class _ProductData {
  final String image;
  final String price;

  _ProductData({required this.image, required this.price});
}