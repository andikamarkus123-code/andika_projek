import 'package:flutter/material.dart';
import '../models/product_model.dart';
import 'product_card.dart'; 

class WebPromoSection extends StatelessWidget {
  const WebPromoSection({super.key});

  @override
  Widget build(BuildContext context) {
    const Color shopeeRed = Color(0xFFD0011B);
    
    final List<ProductItem> webProducts = [
      ProductItem(
        imagePath: 'assets/images/sabun.png', title: '[BARU PUMP] Garnier Micellar Water...',
        price: 'Rp53.899', discount: '-50%', rating: '', terjual: '4RB+ terjual',
        isStar: false, isPromoXtra: false, showMoreOptions: false, isMallOri: true,
      ),
      ProductItem(
        imagePath: 'assets/images/sabun_men.png', title: 'GARNIER Men Facial Wash Kulit Bersih',
        price: 'Rp91.445', discount: '-22%', rating: '', terjual: '10RB+ terjual',
        isStar: false, isPromoXtra: false, showMoreOptions: false, isMallOri: true,
      ),
      ProductItem(
        imagePath: 'assets/images/micellar.png', title: 'Garnier Micellar Water ALL Varian',
        price: 'Rp53.900', discount: '-50%', rating: '', terjual: '10RB+ terjual',
        isStar: false, isPromoXtra: false, showMoreOptions: false, isMallOri: true,
      ),
      ProductItem(
        imagePath: 'assets/images/maybelline.png', title: '[SHOPEE BEAUTY AWARDS] Maybelline...',
        price: 'Rp83.900', discount: '-40%', rating: '', terjual: '10RB+ terjual',
        isStar: false, isPromoXtra: false, showMoreOptions: false, isMallOri: true,
      ),
      ProductItem(
        imagePath: 'assets/images/maybelline2.png', title: 'L\'Oreal Paris Elseve Extraordinary Oil',
        price: 'Rp144.790', discount: '-25%', rating: '', terjual: '10RB+ terjual',
        isStar: false, isPromoXtra: false, showMoreOptions: false, isMallOri: true,
      ),
      ProductItem(
        imagePath: 'assets/images/3.png', title: 'L\'Oreal Paris Elseve Extraordinary Oil',
        price: 'Rp144.790', discount: '-25%', rating: '', terjual: '10RB+ terjual',
        isStar: false, isPromoXtra: false, showMoreOptions: false, isMallOri: true,
      ),
    ];

    return Center(
      child: Container(
        width: 1000, 
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('DISKON S.D. 30%', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: shopeeRed)),
                Row(
                  children: [
                    Text('Lihat Semua', style: TextStyle(color: Colors.red.shade600, fontSize: 14)),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_forward_ios, color: Colors.red.shade600, size: 12),
                  ],
                )
              ],
            ),
            const SizedBox(height: 20),
            
            Stack(
              clipBehavior: Clip.none, 
              children: [
                SizedBox(
                  height: 250, // <-- UKURAN TINGGI DIPERKECIL
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: webProducts.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 170, // <-- UKURAN LEBAR KARTU DIPERKECIL
                        margin: const EdgeInsets.only(right: 15),
                        child: RegularProductCard(product: webProducts[index]), 
                      );
                    },
                  ),
                ),
                
                Positioned(
                  right: -15, 
                  top: 85, // <-- POSISI PANAH DISESUAIKAN
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
                        ],
                      ),
                      child: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}