import 'package:flutter/material.dart';
import 'dart:async'; // Wajib di-import untuk menggunakan Timer

// ==========================================================
// IMPORT MENGARAH KE GERBANG RESPONSIF UTAMA
// ==========================================================
import '../services/auth_api_service.dart';
import '../services/auth_session.dart';
import 'create_password_screen.dart'; 

class WebOtpScreen extends StatefulWidget {
  const WebOtpScreen({super.key});

  @override
  State<WebOtpScreen> createState() => _WebOtpScreenState();
}

class _WebOtpScreenState extends State<WebOtpScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isLoading = false;

  // --- State Hitung Mundur OTP ---
  Timer? _timer;
  int _secondsRemaining = 60; // Waktu hitung mundur (60 detik)
  bool _isResendAvailable = false; // Status apakah tombol kirim ulang aktif

  @override
  void initState() {
    super.initState();
    _startTimer(); // Otomatis jalankan hitung mundur saat layar dibuka
  }

  // --- Fungsi Memulai Hitung Mundur ---
  void _startTimer() {
    _secondsRemaining = 60;
    _isResendAvailable = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _isResendAvailable = true;
          _timer?.cancel(); // Hentikan timer jika sudah menyentuh angka 0
        }
      });
    });
  }

  // --- Fungsi Kirim Ulang OTP ---
  void _handleResendOtp() async {
    if (!_isResendAvailable) return;

    String phone = AuthSession.currentRegisterPhone;
    if (phone.isEmpty) phone = "(+62) 822 4800 8455"; // Fallback keamanan

    _showSnackBar("Mengirim ulang kode OTP ke $phone...");
    
    try {
      final res = await AuthApiService.sendOtp(phone);
      if (res['success'] == true) {
        _showSnackBar("Kode OTP baru berhasil dikirim!");
        _startTimer(); // Mulai ulang hitung mundur dari 60 detik
      } else {
        _showSnackBar(res['message'] ?? "Gagal mengirim ulang OTP");
      }
    } catch (e) {
      _showSnackBar("Terjadi kesalahan jaringan");
    }
  }

  // --- Fungsi Verifikasi OTP Web ke API Laragon ---
  void _handleVerifyOtp() async {
    String otpCode = _controllers.map((c) => c.text).join();
    if (otpCode.length < 6) {
      _showSnackBar("Silakan isi seluruh kode OTP");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final res = await AuthApiService.verifyOtp(
        AuthSession.currentRegisterPhone, 
        otpCode,
      );

      if (res['success'] == true) {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreatePasswordScreen()), 
          );
        }
      } else {
        _clearOtpFields();
        if (mounted) {
          _showSnackBar(res['message'] ?? "Kode OTP salah");
        }
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar("Terjadi kesalahan koneksi server");
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _clearOtpFields() {
    for (var c in _controllers) {
      c.clear();
    }
    _focusNodes[0].requestFocus(); 
  }

  // ---> FUNGSI SNACKBAR YANG SEBELUMNYA HILANG <---
  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void dispose() {
    _timer?.cancel(); // PENTING: Hentikan timer saat keluar halaman agar tidak bocor memori
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color shopeeOrange = Color(0xFFEE4D2D);
    const Color shopeeGreen = Color(0xFF63B931); 

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ==========================================
            // 1. TOP HEADER PUTIH
            // ==========================================
            _buildTopHeader(shopeeOrange),

            const SizedBox(height: 50),

            // ==========================================
            // 2. STEPPER (Langkah 1 Aktif)
            // ==========================================
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStepItem(step: "1", title: "Verifikasi no. handphone", isActive: true, color: shopeeGreen),
                _buildStepLine(),
                _buildStepItem(step: "2", title: "Buat password", isActive: false, color: shopeeGreen),
                _buildStepLine(),
                _buildStepItem(step: "✓", title: "Selesai", isActive: false, color: shopeeGreen, isCheck: true),
              ],
            ),

            const SizedBox(height: 40),

            // ==========================================
            // 3. KARTU KODE OTP
            // ==========================================
            Container(
              width: 480, 
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))
                ],
              ),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: InkWell(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.arrow_back, color: shopeeOrange, size: 24),
                        ),
                      ),
                      const Text(
                        "Masukkan Kode OTP",
                        style: TextStyle(fontSize: 18, color: Colors.black87),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 35),
                  
                  const Text("Kode OTP telah dikirim via WhatsApp ke", style: TextStyle(color: Colors.black87, fontSize: 14)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/whatsapp.png', 
                        width: 18, 
                        height: 18,
                        errorBuilder: (c, e, s) => const Icon(Icons.wechat, color: Color(0xFF25D366), size: 20),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        AuthSession.currentRegisterPhone.isNotEmpty 
                            ? AuthSession.currentRegisterPhone 
                            : "(+62) 822 4800 8455", 
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Membangun 6 Kotak Input OTP Berderet
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(6, (index) => _buildOtpField(index)),
                  ),

                  const SizedBox(height: 40),

                  // Teks Hitung Mundur Berubah secara Real-time Dinamis
                  Text(
                    _isResendAvailable 
                        ? "Kamu sekarang bisa mengirim ulang kode."
                        : "Mohon tunggu $_secondsRemaining detik untuk mengirim ulang.",
                    style: TextStyle(
                      color: _isResendAvailable ? shopeeGreen : Colors.grey.shade400, 
                      fontSize: 12,
                      fontWeight: _isResendAvailable ? FontWeight.bold : FontWeight.normal
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Tombol Kirim Ulang Kode yang Aktif/Nonaktif sesuai Waktu Timer
                  TextButton(
                    onPressed: _isResendAvailable ? _handleResendOtp : null,
                    child: Text(
                      "Kirim Ulang Kode",
                      style: TextStyle(
                        color: _isResendAvailable ? Colors.blue : Colors.grey.shade400,
                        fontWeight: FontWeight.bold,
                        fontSize: 14
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // TOMBOL LANJUT
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: shopeeOrange, 
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                      ),
                      onPressed: _isLoading ? null : _handleVerifyOtp, 
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text(
                              "LANJUT", 
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.0),
                            ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 80),

            // ==========================================
            // 4. FOOTER LENGKAP SHOPEE
            // ==========================================
            _buildWebFooter(),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // WIDGET HELPER UI
  // ==========================================================

  Widget _buildTopHeader(Color shopeeOrange) {
    return Container(
      height: 84,
      decoration: const BoxDecoration(
        color: Colors.white, 
        border: Border(bottom: BorderSide(color: Color(0xFFF5F5F5), width: 2))
      ),
      child: Center(
        child: SizedBox(
          width: 1040,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/images/shopee_logo2.png',
                    height: 45,
                    errorBuilder: (c, e, s) => Icon(Icons.shopping_bag, size: 45, color: shopeeOrange),
                  ),
                  const SizedBox(width: 10),
                  Text("Shopee", style: TextStyle(color: shopeeOrange, fontSize: 32, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 15),
                  const Text(
                    "Daftar",
                    style: TextStyle(color: Colors.black87, fontSize: 24),
                  ),
                ],
              ),
              InkWell(
                onTap: () {},
                child: Text("Butuh bantuan?", style: TextStyle(color: shopeeOrange, fontSize: 14)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepItem({required String step, required String title, required bool isActive, required Color color, bool isCheck = false}) {
    return Column(
      children: [
        Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            color: isActive ? color : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: isActive ? color : Colors.grey.shade300, width: 2),
          ),
          child: Center(
            child: isCheck
                ? Icon(Icons.check, color: Colors.grey.shade300, size: 20)
                : Text(
                    step,
                    style: TextStyle(color: isActive ? Colors.white : Colors.grey.shade400, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: TextStyle(color: isActive ? color : Colors.grey.shade400, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildStepLine() {
    return Container(
      width: 80,
      height: 1,
      margin: const EdgeInsets.only(top: 17, left: 10, right: 10), 
      color: Colors.grey.shade300,
    );
  }

  Widget _buildOtpField(int index) {
    return Container(
      width: 40,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1, 
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          counterText: "", 
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade400, width: 2)),
          focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black87, width: 2)),
        ),
        onChanged: (value) {
          if (value.length == 1) {
            if (index < 5) {
              _focusNodes[index + 1].requestFocus();
            } else {
              _focusNodes[index].unfocus(); 
              _handleVerifyOtp(); 
            }
          } else if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
        },
      ),
    );
  }

  Widget _buildWebFooter() {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF5F5F5), 
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
      child: Center(
        child: SizedBox(
          width: 1040, 
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: _buildFooterTextColumn("Layanan Pelanggan", [
                  "Bantuan", "Metode Pembayaran", "ShopeePay", "Koin Shopee",
                  "Lacak Pesanan Pembeli", "Lacak Pengiriman Penjual", "Gratis Ongkir",
                  "Pengembalian Barang & Dana", "Garansi Shopee"
                ]),
              ),
              Expanded(
                flex: 2,
                child: _buildFooterTextColumn("Jelajahi Shopee", [
                  "Tentang Kami", "Karir", "Kebijakan", "Kebijakan Privasi Shopee",
                  "Blog", "Shopee Mall", "Seller Centre", "Flash Sale", "Kontak Media"
                ]),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Pembayaran", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildAssetBox('assets/images/pay_alfamart.png', "Alfamart"),
                        _buildAssetBox('assets/images/pay_alfamidi.png', "Alfamidi"),
                        _buildAssetBox('assets/images/pay_bca.png', "BCA"),
                        _buildAssetBox('assets/images/pay_bni.png', "BNI"),
                        _buildAssetBox('assets/images/pay_bri.png', "BRI"),
                        _buildAssetBox('assets/images/pay_bsi.png', "BSI"),
                        _buildAssetBox('assets/images/pay_cimb.png', "CIMB"),
                        _buildAssetBox('assets/images/pay_mandiri.png', "Mandiri"),
                        _buildAssetBox('assets/images/pay_indomaret.png', "Indomaret"),
                        _buildAssetBox('assets/images/pay_jcb.png', "JCB"),
                        _buildAssetBox('assets/images/pay_mastercard.png', "MasterCard"),
                        _buildAssetBox('assets/images/pay_spay.png', "SPay"),
                        _buildAssetBox('assets/images/pay_visa.png', "Visa"),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Ikuti Kami", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
                    const SizedBox(height: 20),
                    _buildSocialLink('assets/images/soc_fb.png', "Facebook", Icons.facebook),
                    _buildSocialLink('assets/images/soc_ig.png', "Instagram", Icons.camera_alt),
                    _buildSocialLink('assets/images/soc_tw.png', "Twitter", Icons.flutter_dash),
                    _buildSocialLink('assets/images/soc_in.png', "LinkedIn", Icons.work),
                    _buildSocialLink('assets/images/soc_kampus.png', "Kampus Shopee", Icons.school),
                    
                    const SizedBox(height: 30),
                    const Text("Keamanan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
                    const SizedBox(height: 15),
                    Container(
                      height: 40,
                      width: 90,
                      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey.shade300)),
                      child: Image.asset(
                        'assets/images/sec_tuv.png',
                        fit: BoxFit.contain,
                        errorBuilder: (c, e, s) => const Center(child: Text("TÜV", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Download Aplikasi Shopee", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
                    const SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 90,
                          width: 90,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(2)),
                          child: Image.asset(
                            'assets/images/qr_download.png',
                            fit: BoxFit.contain,
                            errorBuilder: (c, e, s) => const Icon(Icons.qr_code_2, size: 70, color: Colors.black87),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            children: [
                              _buildAppStoreButton('assets/images/btn_appstore.png', "App Store"),
                              const SizedBox(height: 8),
                              _buildAppStoreButton('assets/images/btn_playstore.png', "Google Play"),
                              const SizedBox(height: 8),
                              _buildAppStoreButton('assets/images/btn_appgallery.png', "AppGallery"),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooterTextColumn(String title, List<String> links) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
        const SizedBox(height: 20),
        ...links.map((link) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () {},
            child: Text(link, style: const TextStyle(fontSize: 12, color: Colors.black54)),
          ),
        )).toList(),
      ],
    );
  }

  Widget _buildAssetBox(String imagePath, String fallbackText) {
    return Container(
      width: 60,
      height: 30,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(2),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))],
      ),
      child: Image.asset(
        imagePath,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => Center(
          child: Text(fallbackText, style: const TextStyle(fontSize: 8, color: Colors.black54, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildSocialLink(String imagePath, String title, IconData fallbackIcon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {},
        child: Row(
          children: [
            Image.asset(
              imagePath,
              width: 16,
              height: 16,
              fit: BoxFit.contain,
              errorBuilder: (c, e, s) => Icon(fallbackIcon, size: 16, color: Colors.black54),
            ),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontSize: 12, color: Colors.black54)),
          ],
        ),
      ),
    );
  }

  Widget _buildAppStoreButton(String imagePath, String fallbackText) {
    return Container(
      height: 24,
      width: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(2),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))],
      ),
      child: Image.asset(
        imagePath,
        fit: BoxFit.contain,
        errorBuilder: (c, e, s) => Center(child: Text(fallbackText, style: const TextStyle(fontSize: 8, color: Colors.black54))),
      ),
    );
  }
}