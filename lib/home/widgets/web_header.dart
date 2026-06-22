import 'package:flutter/material.dart';

class WebHeader extends StatelessWidget {
  const WebHeader({super.key});

  @override
  Widget build(BuildContext context) {
    const Color headerOrange = Color(0xFFEE4D2D);

    return Container(
      color: headerOrange,
      child: Center(
        child: SizedBox(
          width: 1300, // Lebar disesuaikan 1300px agar proporsional dengan Top Bar
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20), 
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ========================================================
                // LOGO SHOPEE
                // ========================================================
                Row(
                  children: [
                    Image.asset(
                      'assets/images/shopee_logo.png', 
                      height: 48,
                      width: 48,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.shopping_bag, color: Colors.white, size: 45
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Shopee', 
                      style: TextStyle(
                        color: Colors.white, 
                        fontSize: 34, 
                        fontWeight: FontWeight.bold, 
                        letterSpacing: 1.0
                      )
                    ),
                  ],
                ),
                
                const SizedBox(width: 40), // Jarak dari Logo ke Kotak Pencarian
                
                // ========================================================
                // KOTAK PENCARIAN (SEARCH BAR)
                // ========================================================
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.white, 
                          borderRadius: BorderRadius.circular(2), 
                        ),
                        child: Row(
                          children: [
                            const Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(left: 12),
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Daftar & Dapat Voucher Gratis', 
                                    hintStyle: TextStyle(color: Colors.grey, fontSize: 13), 
                                    border: InputBorder.none, 
                                    isDense: true,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 60, 
                              height: 36, 
                              margin: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: headerOrange, 
                                borderRadius: BorderRadius.circular(2)
                              ),
                              child: const Icon(Icons.search, color: Colors.white, size: 20),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      
                      // Teks Sugesti di Bawah Search Bar
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _subSearchText('Celana Panjang Skena'),
                            _subSearchText('Baju Kemeja Korean Style'),
                            _subSearchText('1 Set Skincare Glad2glow'),
                            _subSearchText('Casing Lucu'),
                            _subSearchText('Jam Tangan HP Android Bisa Buat WA...'),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                
                const SizedBox(width: 30), // Jarak dari Kotak Pencarian ke Keranjang
                
                // ========================================================
                // IKON KERANJANG (Menggunakan Image Asset - Tanpa Tint Color)
                // ========================================================
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Image.asset(
                    'assets/images/cart.png', 
                    width: 30,
                    height: 30,
                    fit: BoxFit.contain,
                    // Properti color: Colors.white sengaja dihapus agar wujud asli gambar asset muncul sempurna
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.shopping_cart_outlined, color: Colors.white, size: 30
                    ),
                  ),
                ),
                
                // ========================================================
                // JARAK PENGAMAN UJUNG KANAN
                // Menahan posisi keranjang agar presisi di bawah tulisan "Daftar"
                // ========================================================
                const SizedBox(width: 60), 
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _subSearchText(String text) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 11)),
    );
  }
}