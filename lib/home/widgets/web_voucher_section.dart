import 'package:flutter/material.dart';

class WebVoucherSection extends StatelessWidget {
  const WebVoucherSection({super.key});

  @override
  Widget build(BuildContext context) {
    const Color buttonRed = Color(0xFFD0011B); 
    const Color buttonOrange = Color(0xFFEE4D2D); 
    const Color buttonGrey = Color(0xFFEAEAEA); 
    const Color textGrey = Color(0xFFAFAFAF); 

    final List<Map<String, dynamic>> vouchers = [
      {
        'logo': 'assets/images/garnier_logo.png',
        'brand': 'Garnier Indonesia Official...',
        'title': 'Diskon 15%',
        'min_spend': 'Min. Blj Rp250RB',
        'is_mall': true,
        'expiry': '31 Mei',
        'status': 'active', 
      },
      {
        'logo': 'assets/images/fonterra_logo.png',
        'brand': 'Fonterra Official Store',
        'title': 'Diskon Rp10RB',
        'min_spend': 'Min. Blj Rp100RB',
        'is_mall': true,
        'expiry': '08 Mei',
        'status': 'empty',
      },
      {
        'logo': 'assets/images/garnier_logo.png',
        'brand': 'Garnier Indonesia Official...',
        'title': 'Diskon 10%',
        'min_spend': 'Min. Blj Rp150RB',
        'is_mall': true,
        'expiry': '31 Mei',
        'status': 'active',
      },
    ];

    return Column(
      children: [
        const Text(
          'VOUCHER HARI INI',
          style: TextStyle(
            color: Colors.white, 
            fontSize: 42, 
            fontWeight: FontWeight.w900, 
            letterSpacing: 1.5
          ),
        ),
        const SizedBox(height: 15),
        const Text(
          'VOUCHER BRAND',
          style: TextStyle(
            color: Colors.white, 
            fontSize: 18, 
            fontWeight: FontWeight.bold
          ),
        ),
        const SizedBox(height: 30), 

        Center(
          child: Container(
            width: 1000, 
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
            ),
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    SizedBox(
                      height: 170, 
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: vouchers.length,
                        separatorBuilder: (context, index) => const SizedBox(width: 15),
                        itemBuilder: (context, index) {
                          return _buildTicketCard(
                            data: vouchers[index],
                            colorOrange: buttonOrange,
                            colorGreyBg: buttonGrey,
                            colorGreyText: textGrey,
                          );
                        },
                      ),
                    ),
                    
                    Positioned(
                      right: -15, 
                      top: 60, 
                      child: InkWell(
                        onTap: () {},
                        child: Container(
                          width: 45,
                          height: 45,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
                          ),
                          child: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black87),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 30), 
                
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonRed,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      elevation: 0,
                    ),
                    onPressed: () {},
                    child: const Text(
                      'Klaim Semua (1)',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTicketCard({
    required Map<String, dynamic> data,
    required Color colorOrange,
    required Color colorGreyBg,
    required Color colorGreyText,
  }) {
    final bool isActive = data['status'] == 'active';

    return SizedBox(
      width: 310, 
      child: CustomPaint(
        painter: TicketPainter(
          bgColor: Colors.white,
          borderColor: Colors.grey.shade300,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch, 
          children: [
            SizedBox(
              width: 95, 
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 50, 
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade200, width: 1),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          data['logo'],
                          fit: BoxFit.contain,
                          errorBuilder: (c, e, s) => const Icon(Icons.image, color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      data['brand'],
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 11, color: Colors.black87, height: 1.2),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Flex(
                direction: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(22, (_) { 
                  return Container(
                    width: 1.5,
                    height: 4,
                    color: Colors.grey.shade300,
                  );
                }),
              ),
            ),

            // ======================================================
            // PERBAIKAN SISI KANAN SESUAI GAMBAR BARU
            // ======================================================
            Expanded(
              child: Padding(
                // Margin dalam disesuaikan agar pas
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 10), 
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Diskon 15% (Agak besar & tebal)
                    Text(
                      data['title'],
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87), 
                    ),
                    const SizedBox(height: 3),
                    
                    // Min. Blj Rp250RB
                    Text(
                      data['min_spend'],
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 6),
                    
                    // Badge Mall (Garis tipis, padding pas)
                    if (data['is_mall'])
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          border: Border.all(color: colorOrange, width: 0.8), // Garis lebih tipis
                          borderRadius: BorderRadius.circular(3), // Radius sedikit membulat
                        ),
                        child: Text(
                          'Mall',
                          style: TextStyle(color: colorOrange, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                      
                    const SizedBox(height: 6),
                    
                    // Berlaku Hingga: 31 Mei (Bisa turun ke bawah jika layar sempit, mirip gambar)
                    Text(
                      'Berlaku Hingga: ${data['expiry']}',
                      maxLines: 2,
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade500, height: 1.2), // Height mengatur spasi antar baris teks
                    ),
                    
                    const Spacer(), 
                    
                    // Tombol Lihat Toko (Lebih Pipih)
                    SizedBox(
                      width: double.infinity, 
                      height: 28, // Diubah menjadi 28 agar lebih pipih sesuai gambar
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isActive ? colorOrange : colorGreyBg,
                          elevation: 0,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        ),
                        onPressed: () {},
                        child: Text(
                          isActive ? 'Lihat Toko' : 'Habis',
                          style: TextStyle(
                            color: isActive ? Colors.white : colorGreyText, 
                            fontWeight: FontWeight.bold, 
                            fontSize: 12
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 4), // Jarak tipis ke S&K
                    
                    // Teks S&K Rata Kanan Bawah
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {},
                        child: const Text(
                          'S&K', 
                          style: TextStyle(color: Colors.blue, fontSize: 11, fontWeight: FontWeight.bold)
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TicketPainter extends CustomPainter {
  final Color borderColor;
  final Color bgColor;

  TicketPainter({required this.borderColor, required this.bgColor});

  @override
  void paint(Canvas canvas, Size size) {
    if (size.height.isInfinite || size.width.isInfinite || size.height <= 0) return;

    final paint = Paint()
      ..color = bgColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final path = Path();
    final double radius = 6.0; 
    final double holeRadius = 4.0; 
    final double holeSpacing = 3.0; 

    path.moveTo(radius, 0);
    path.lineTo(size.width - radius, 0);
    path.arcToPoint(Offset(size.width, radius), radius: Radius.circular(radius));
    path.lineTo(size.width, size.height - radius);
    path.arcToPoint(Offset(size.width - radius, size.height), radius: Radius.circular(radius));
    path.lineTo(radius, size.height);
    path.arcToPoint(Offset(0, size.height - radius), radius: Radius.circular(radius));

    double currentY = size.height - radius;
    while (currentY > radius) {
      if (currentY - holeRadius * 2 < radius) {
        path.lineTo(0, radius);
        break;
      }
      path.lineTo(0, currentY - holeSpacing);
      path.arcToPoint(
        Offset(0, currentY - holeSpacing - holeRadius * 2),
        radius: Radius.circular(holeRadius),
        clockwise: false, 
      );
      currentY -= (holeSpacing + holeRadius * 2);
    }

    path.lineTo(0, radius);
    path.arcToPoint(Offset(radius, 0), radius: Radius.circular(radius));

    path.close();

    canvas.drawShadow(path, const Color(0x1A000000), 2.0, false);
    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}