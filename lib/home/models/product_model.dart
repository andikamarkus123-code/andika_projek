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
    this.isMallOri = false
  });
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