import 'package:flutter/material.dart';
import '../models/product_model.dart';
import 'product_card.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final List<GridItem> gridItems = [
      BannerItem(imagePath: 'assets/images/promo_grid.png'), 
      ProductItem(
        imagePath: 'assets/images/kemeja_putih.png', 
        title: 'kemeja polos puith lengan panjang bahan katun tayobo ...',
        price: 'Rp23.000',
        discount: '-25%',
        rating: '4.8', 
        terjual: '127 terjual', 
        isStar: true,
        isPromoXtra: true,
        isFlashSale: false, 
        flashSaleProgress: 0.4, 
        flashSaleText: '127 terjual',
        showMoreOptions: true, 
      ),
      ProductItem(
        imagePath: 'assets/images/kaos_kaki.png',
        title: 'Kaos kaki motif api skate style black flame & yellow premium',
        price: 'Rp0',
        discount: '>90% off',
        rating: '4.8',
        terjual: '10rb+ terjual',
        isStar: false,
        isLive: true,
        isPromoXtra: false,
        isFlashSale: false,
        flashSaleProgress: 0.9, 
        flashSaleText: '900 terjual',
        showMoreOptions: true,
      ),
      ProductItem(
        imagePath: 'assets/images/mykonos.png',
        title: 'Mykonos Decant Parfum o.5ml 1ml Original',
        price: 'Rp4.999',
        discount: '-67%',
        rating: '4.7',
        isLive: true,
        terjual: '10RB+ terj...',
        isStar: false,
        isPromoXtra: true,
        showMoreOptions: true,
      ),
      BannerItem(imagePath: 'assets/images/murah_mantap.png'),
      
      ProductItem(
        imagePath: 'assets/images/kemeja_hitam.png', 
        thumbnailPath: 'assets/images/hitam.png',
        title: 'Kemeja Casual Pria Bahan katun Lembut',
        price: 'Rp16.400',
        discount: '',
        rating: '',
        terjual: '',
        isStar: false,
        isPromoXtra: false,
        showMoreOptions: false,
        videoViews: '2,7RB', 
        priceOverlay: '15k', 
      ),

                  ProductItem(
        imagePath: 'assets/images/headset.png',
        title: 'Headset Bluetooth TWS Air31 LED Hifi Noise Canceling',
        price: 'Rp23.000',
        discount: '-60%',
        rating: '',
        isLive: false,
        terjual: '10RB+ te...',
        isStar: true,
        isPromoXtra: false,
        flashSaleProgress: 0.429, 
        isFlashSale: true,
        flashSaleText: '34 terjual',
        showMoreOptions: true,
      ),

      ProductItem(
        imagePath: 'assets/images/kemeja_ijo.png',
        title: 'Kemeja Pria Lengan Pendek Katun Toyobo Premiu...',
        price: 'Rp37.800',
        discount: '-62%',
        rating: '4.9',
        isLive: true,
        terjual: '2RB+ terj...',
        isStar: true,
        isPromoXtra: true,
        flashSaleProgress: 0.429, 
        isFlashSale: false,
        flashSaleText: '34 terjual',
        showMoreOptions: true,
      ),

            FoodItem(
        imagePath: 'assets/images/mie_gacoan.png',
        title: 'Mie Gacoan',
        price: 'Rp5.000',
        discountBadge: '-68%',
      ),

            ProductItem(
        imagePath: 'assets/images/voova.png',
        title: 'VOOVA Sandal Selop Wanita Empuk Anti Slip',
        price: 'Rp8.450',
        discount: '-62%',
        rating: '4.6',
        isLive: true,
        terjual: '10RB+ terj...',
        isStar: true,
        isPromoXtra: true,
        flashSaleProgress: 0.429, 
        isFlashSale: false,
        flashSaleText: '34 terjual',
        showMoreOptions: true,
      ),
    ];

    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: const EdgeInsets.all(6.0), 
        decoration: BoxDecoration(
          color: Colors.white, 
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: GridView.builder(
          shrinkWrap: true, 
          physics: const NeverScrollableScrollPhysics(), 
          itemCount: gridItems.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.58, 
            crossAxisSpacing: 4, 
            mainAxisSpacing: 4,  
          ),
          itemBuilder: (context, index) {
            final item = gridItems[index];
            final bool isRightColumn = index % 2 == 1;

            Widget currentCard;
            
            // --- LOGIKA PEMILIHAN WIDGET KARTU ---
            if (item is BannerItem) {
              currentCard = PromoCard(banner: item);
            } else if (item is FoodItem) {
              // Jika tipe datanya FoodItem, tampilkan MobileFoodCard
              currentCard = MobileFoodCard(food: item);
            } else if (item is ProductItem) {
              if (item.videoViews.isNotEmpty) {
                currentCard = SpecialProductCard(product: item);
              } else {
                currentCard = RegularProductCard(product: item);
              }
            } else {
              currentCard = const SizedBox.shrink();
            }

            // --- LOGIKA PADDING (ZIGZAG) ---
            double topPadding;
            double bottomPadding;

            if (index == 0) {
              topPadding = 0;
              bottomPadding = 0; 
            } else {
              topPadding = isRightColumn ? 0 : 8;    
              bottomPadding = isRightColumn ? 8 : 0; 
            }

            return Padding(
              padding: EdgeInsets.only(
                top: topPadding,
                bottom: bottomPadding,
              ),
              child: currentCard,
            );
          },
        ),
      ),
    );
  }
}