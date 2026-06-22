abstract class GridItem {}

class ProductItem extends GridItem {
  final String imagePath;
  final String title;
  final String price;
  final String discount;
  final String rating;
  final String terjual;
  final bool isStar;
  final bool isLive;
  final bool isPromoXtra;
  final bool isFlashSale;
  final double flashSaleProgress;
  final String flashSaleText;
  final bool showMoreOptions;
  final String videoViews;
  final String priceOverlay;
  final String thumbnailPath;
  final bool isMallOri;

  ProductItem({
    required this.imagePath,
    required this.title,
    required this.price,
    required this.discount,
    required this.rating,
    required this.terjual,
    required this.isStar,
    this.isLive = false,
    required this.isPromoXtra,
    this.isFlashSale = false,
    this.flashSaleProgress = 0.5,
    this.flashSaleText = '',
    this.showMoreOptions = true,
    this.videoViews = '',
    this.priceOverlay = '',
    this.thumbnailPath = '',
    this.isMallOri = false,
  });

  factory ProductItem.fromJson(Map<String, dynamic> json) {
    return ProductItem(
      imagePath: json['imagePath'] ?? '',
      title: json['title'] ?? '',
      price: json['price'] ?? '',
      discount: json['discount'] ?? '',
      rating: json['rating'] ?? '',
      terjual: json['terjual'] ?? '',
      // Konversi integer/boolean dari MySQL ke bool Dart
      isStar: json['isStar'] == 1 || json['isStar'] == true,
      isLive: json['isLive'] == 1 || json['isLive'] == true,
      isPromoXtra: json['isPromoXtra'] == 1 || json['isPromoXtra'] == true,
      isFlashSale: json['isFlashSale'] == 1 || json['isFlashSale'] == true,
      flashSaleProgress: json['flashSaleProgress'] != null
          ? double.parse(json['flashSaleProgress'].toString())
          : 0.5,
      flashSaleText: json['flashSaleText'] ?? '',
      showMoreOptions:
          json['showMoreOptions'] == 1 || json['showMoreOptions'] == true,
      videoViews: json['videoViews'] ?? '',
      priceOverlay: json['priceOverlay'] ?? '',
      thumbnailPath: json['thumbnailPath'] ?? '',
      isMallOri: json['isMallOri'] == 1 || json['isMallOri'] == true,
    );
  }
}

class BannerItem extends GridItem {
  final String imagePath;
  BannerItem({required this.imagePath});
}

// ==========================================
// TAMBAHAN: MODEL UNTUK KARTU SHOPEEFOOD
// ==========================================
class FoodItem extends GridItem {
  final String imagePath;
  final String title;
  final String price;
  final String discountBadge;

  FoodItem({
    required this.imagePath,
    required this.title,
    required this.price,
    required this.discountBadge,
  });
}
