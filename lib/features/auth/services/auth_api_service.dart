import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthApiService {
  // CATATAN PENTING:
  // - Jika run di Web Browser PC yang sama: pakai "http://localhost/api_shopee"
  // - Jika run di Emulator Android: pakai "http://10.0.2.2/api_shopee"
  // - Jika run di HP Asli: pakai IP WiFi laptop Anda (contoh: "http://192.168.1.10/api_shopee")
  static const String baseUrl = "http://localhost/api_shopee"; 

  // ==========================================================
  // 1. FUNGSI LOGIN USER (Mendukung Email, No. HP, atau Username)
  // ==========================================================
  static Future<Map<String, dynamic>> loginUser(String identifier, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login.php"),
        // PERBAIKAN: Key diubah menjadi "identifier" agar PHP bisa mencari di 3 kolom sekaligus
        body: {"identifier": identifier, "password": password},
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {"success": false, "message": "Koneksi ke server gagal: $e"};
    }
  }

  // ==========================================================
  // 2. FUNGSI KIRIM OTP (send_otp.php)
  // ==========================================================
  static Future<Map<String, dynamic>> sendOtp(String phoneNumber) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/send_otp.php"),
        body: {"phone_number": phoneNumber},
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {"success": false, "message": "Koneksi ke server gagal: $e"};
    }
  }

  // ==========================================================
  // 3. FUNGSI VERIFIKASI OTP (verify_otp.php)
  // ==========================================================
  static Future<Map<String, dynamic>> verifyOtp(String phoneNumber, String otpCode) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/verify_otp.php"),
        body: {"phone_number": phoneNumber, "otp_code": otpCode},
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {"success": false, "message": "Koneksi ke server gagal: $e"};
    }
  }

  // ==========================================================
  // 4. FUNGSI REGISTER AKHIR (register.php)
  // ==========================================================
static Future<Map<String, dynamic>> registerUser(String phoneNumber, String password) async {
  try {
    final response = await http.post(
      Uri.parse("$baseUrl/register.php"),
      headers: {"Content-Type": "application/json"}, // Flutter kasih tahu PHP: "Saya kirim data JSON"
      body: jsonEncode({
        "phone_number": phoneNumber,
        "password": password
      }),
    );
    
    print("RESPON DARI SERVER: ${response.body}"); // Pantau di terminal VS Code
    return jsonDecode(response.body);
  } catch (e) {
    return {"success": false, "message": "Koneksi ke server gagal: $e"};
  }
}
}