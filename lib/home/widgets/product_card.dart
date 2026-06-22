import 'package:flutter/material.dart';
import '../models/product_model.dart';

// =========================================================
// WIDGET 1: PROMO CARD (BANNER)
// =========================================================
class PromoCard extends StatelessWidget {
  final BannerItem banner;
  final BoxBorder? customBorder;

  const PromoCard({super.key, required this.banner, this.customBorder});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: customBorder ?? Border.all(color: Colors.grey.shade200, width: 2.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4.0), 
        child: Image.asset(banner.imagePath, fit: BoxFit.cover, width: double.infinity, height: double.infinity),
      ),
    );
  }
}

// =========================================================
// WIDGET 2: REGULAR PRODUCT CARD (PRODUK BIASA)
// =========================================================
class RegularProductCard extends StatelessWidget {
  final ProductItem product;
  const RegularProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade200, width: 2.0), 
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 6, 
            child: Stack(
              children: [
                SizedBox(width: double.infinity, height: double.infinity,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(4.0)),
                    child: Image.asset(product.imagePath, fit: BoxFit.cover),
                  ),
                ),
                if (product.discount.isNotEmpty)
                  Positioned(top: 0, right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                      decoration: const BoxDecoration(color: Color(0xFFFCE4EC), borderRadius: BorderRadius.only(bottomLeft: Radius.circular(6))),
                      child: Text(product.discount, style: const TextStyle(color: Color(0xFFE53935), fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                  ),
                if (product.isPromoXtra)
                  Positioned(bottom: 0, left: 0,
                    child: Container(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2), color: Colors.yellow,
                      child: const Text('PROMO\nXTRA', style: TextStyle(color: Colors.red, fontSize: 8, fontWeight: FontWeight.w900, height: 1.0)),
                    ),
                  ),
              ],
            ),
          ),
          Divider(height: 2.0, thickness: 2.0, color: Colors.grey.shade200),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RichText(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      children: [
                        if (product.isMallOri)
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Container(
                              margin: const EdgeInsets.only(right: 5, bottom: 2),
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1.5),
                              decoration: BoxDecoration(
                                color: const Color(0xFFD0011B), 
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: const Text(
                                'Mall | ORI',
                                style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        else if (product.isLive)
                          WidgetSpan(alignment: PlaceholderAlignment.middle,
                            child: Container(margin: const EdgeInsets.only(right: 5, bottom: 2), padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1.5), decoration: BoxDecoration(color: const Color(0xFFEE4D2D), borderRadius: BorderRadius.circular(3)),
                              child: Row(mainAxisSize: MainAxisSize.min, children: [
                                Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                                  Container(width: 1.5, height: 5, color: Colors.white), const SizedBox(width: 1),
                                  Container(width: 1.5, height: 7, color: Colors.white), const SizedBox(width: 1),
                                  Container(width: 1.5, height: 4, color: Colors.white),
                                ]),
                                const SizedBox(width: 3), const Text('LIVE', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                              ]),
                            ),
                          )
                        else if (product.isStar)
                          WidgetSpan(alignment: PlaceholderAlignment.middle,
                            child: Container(margin: const EdgeInsets.only(right: 5, bottom: 2), padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1), decoration: BoxDecoration(color: const Color(0xFFEE4D2D), borderRadius: BorderRadius.circular(3)),
                              child: const Text('Star', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        TextSpan(text: product.title, style: const TextStyle(fontSize: 11, color: Colors.black87, height: 1.2)),
                      ],
                    ),
                  ),
                  if (product.isFlashSale) _buildFlashSaleBar(product.flashSaleText, product.flashSaleProgress)
                  else if (product.rating.isNotEmpty)
                    Container(margin: const EdgeInsets.only(top: 2), padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1), decoration: BoxDecoration(color: Colors.amber.shade50, border: Border.all(color: Colors.amber.shade300, width: 0.8), borderRadius: BorderRadius.circular(3)),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.star, color: Colors.amber, size: 10), const SizedBox(width: 3), Text(product.rating, style: const TextStyle(fontSize: 10, color: Colors.black87))]),
                    ),
                  Row(
                    children: [
                      Text(product.price, style: const TextStyle(color: Color(0xFFEE4D2D), fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(width: 4),
                      // --- PERUBAHAN: Ikon Voucher 24x24 ---
                      Image.asset(
                        'assets/images/voucher_icon.png', 
                        width: 24, 
                        height: 24, 
                        fit: BoxFit.contain, 
                        errorBuilder: (c, e, s) => const Icon(Icons.local_activity_outlined, color: Color(0xFFEE4D2D), size: 16)
                      ),
                      const Spacer(), 
                      Text(product.terjual, style: const TextStyle(fontSize: 9, color: Colors.grey)),
                      if (product.showMoreOptions) ...[
                        const SizedBox(width: 4),
                        Icon(Icons.more_horiz, color: Colors.grey.shade500, size: 12),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlashSaleBar(String flashText, double progress) {
    return Container(height: 14, width: 85, margin: const EdgeInsets.only(top: 4, bottom: 2), decoration: BoxDecoration(border: Border.all(color: const Color(0xFFE53935), width: 0.8), borderRadius: BorderRadius.circular(3)),
      child: ClipRRect(borderRadius: BorderRadius.circular(2),
        child: Row(children: [
          Container(width: 16, color: Colors.white, alignment: Alignment.center, child: const Icon(Icons.flash_on, color: Color(0xFFE53935), size: 10)),
          Expanded(child: Stack(children: [
            Container(color: const Color(0xFFFFCDD2).withOpacity(0.7)),
            FractionallySizedBox(widthFactor: progress, child: Container(decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFFE53935), Color(0xFFFF9800)], begin: Alignment.centerLeft, end: Alignment.centerRight)))),
            Center(child: Text(flashText, style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold))),
          ])),
        ]),
      ),
    );
  }
}

// =========================================================
// WIDGET 3: SPECIAL PRODUCT CARD (TAMPILAN VIDEO FEED)
// =========================================================
class SpecialProductCard extends StatelessWidget {
  final ProductItem product;
  const SpecialProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade200, width: 2.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 7, 
            child: Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(4.0)),
                    child: Image.asset(product.imagePath, fit: BoxFit.cover),
                  ),
                ),
                if (product.videoViews.isNotEmpty)
                  Positioned(
                    top: 8, left: 8,
                    child: Row(
                      children: [
                        const Icon(Icons.play_arrow, color: Colors.white, size: 16),
                        const SizedBox(width: 2),
                        Text(
                          product.videoViews, 
                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600, shadows: [Shadow(color: Colors.black45, blurRadius: 2, offset: Offset(1, 1))]),
                        ),
                      ],
                    ),
                  ),
                if (product.priceOverlay.isNotEmpty)
                  Center(
                    child: Text(
                      product.priceOverlay,
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, shadows: [Shadow(color: Colors.black54, blurRadius: 4, offset: Offset(1, 1))]),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch, 
              children: [
                SizedBox(
                  width: 48, height: double.infinity, 
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(4)),
                    child: Image.asset(
                      product.thumbnailPath.isNotEmpty ? product.thumbnailPath : product.imagePath, 
                      fit: BoxFit.cover, 
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            children: [
                              if (product.isMallOri)
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 5, bottom: 2),
                                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1.5),
                                    decoration: BoxDecoration(color: const Color(0xFFD0011B), borderRadius: BorderRadius.circular(2)),
                                    child: const Text('Mall | ORI', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              TextSpan(text: product.title, style: const TextStyle(fontSize: 10, color: Colors.black87, height: 1.2)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(product.price, style: const TextStyle(color: Color(0xFFEE4D2D), fontWeight: FontWeight.bold, fontSize: 12)),
                            const SizedBox(width: 4),
                            // --- PERUBAHAN: Ikon Voucher 24x24 ---
                            Image.asset(
                              'assets/images/voucher_icon.png', 
                              width: 24, 
                              height: 24, 
                              fit: BoxFit.contain, 
                              errorBuilder: (c, e, s) => const Icon(Icons.local_activity_outlined, color: Color(0xFFEE4D2D), size: 16)
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =========================================================
// WIDGET 4: FOOD PRODUCT CARD (SHOPEEFOOD) - FINAL GAMBAR 2
// =========================================================
class MobileFoodCard extends StatelessWidget {
  final FoodItem food;
  const MobileFoodCard({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    const Color shopeeOrange = Color(0xFFEE4D2D);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade200, width: 1.5),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ==========================================
          // 1. GAMBAR PRODUK (Dibuat lebih besar - Flex 3)
          // ==========================================
          Expanded(
            flex: 3, 
            child: Stack(
              children: [
                SizedBox(
                  width: double.infinity, 
                  height: double.infinity,
                  child: Image.asset(
                    food.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => Container(
                      color: Colors.grey.shade100,
                      child: const Icon(Icons.fastfood, color: Colors.grey, size: 50),
                    ),
                  ),
                ),
                if (food.discountBadge.isNotEmpty)
                  Positioned(
                    top: 0, right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                      color: Colors.white,
                      child: Text(
                        food.discountBadge,
                        style: const TextStyle(color: shopeeOrange, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // ==========================================
          // 2. INFO & BEST DEALS (Dibuat lebih padat - Flex 2)
          // ==========================================
          Expanded(
            flex: 2, 
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 6.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Label ShopeeFood + Judul Menu
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 4, top: 1),
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                            decoration: BoxDecoration(color: shopeeOrange, borderRadius: BorderRadius.circular(2)),
                            child: const Text("ShopeeFood", style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                          ),
                          Expanded(
                            child: Text(
                              food.title, 
                              style: const TextStyle(fontSize: 12, color: Colors.black87, height: 1.1), 
                              maxLines: 1, 
                              overflow: TextOverflow.ellipsis
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 6), 

                      // Harga & Ikon Tiket Voucher
                      Row(
                        children: [
                          Text(
                            food.price, 
                            style: const TextStyle(color: shopeeOrange, fontSize: 17, fontWeight: FontWeight.bold)
                          ),
                          const SizedBox(width: 4),
                          // --- PERUBAHAN: Ikon Tiket dari Assets ukuran 24x24 ---
                          Image.asset(
                            'assets/images/voucher_icon.png', 
                            width: 24, 
                            height: 24, 
                            fit: BoxFit.contain,
                            errorBuilder: (c, e, s) => const Icon(Icons.local_activity_outlined, color: shopeeOrange, size: 16)
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const Spacer(), 

                // ==========================================
                // 3. BAGIAN BAWAH (BEST DEALS)
                // ==========================================
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter, 
                      end: Alignment.bottomCenter, 
                      colors: [Colors.white, Color(0xFFFFF0EC)]
                    ),
                  ),
                  child: Row(
                    children: [
                      // Ikon Best Deals dari Assets
                      Image.asset(
                        'assets/images/best_deals.png', 
                        width: 24, 
                        height: 24, 
                        fit: BoxFit.contain,
                        errorBuilder: (c, e, s) => const Icon(Icons.restaurant_menu, color: shopeeOrange, size: 18),
                      ),
                      
                      const SizedBox(width: 6),
                      
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Best Deals", 
                              style: TextStyle(color: shopeeOrange, fontSize: 12, fontWeight: FontWeight.bold, height: 1.1)
                            ),
                            const SizedBox(height: 1), 
                            Text(
                              "Cari Menu Favoritmu", 
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 9, height: 1.1), 
                              maxLines: 1, 
                              overflow: TextOverflow.ellipsis
                            ),
                          ],
                        ),
                      ),
                      
                      const Icon(Icons.arrow_forward_ios, size: 10, color: shopeeOrange),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}