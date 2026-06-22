import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import package http
import 'dart:convert'; // Import untuk jsonDecode
import '../models/product_model.dart'; // Import model produk kamu

class ProductGrid extends StatefulWidget {
  @override
  _ProductGridState createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  // 1. Siapkan List kosong untuk menampung produk dari database
  List<ProductItem> productList = [];
  bool isLoading = true; // Untuk menampilkan loading indicator

  @override
  void initState() {
    super.initState();
    // 2. Panggil fungsi ambil data saat widget pertama kali dirender
    fetchProducts();
  }

  // 3. Fungsi untuk mengambil data dari PHP MySQL
  Future<void> fetchProducts() async {
    try {
      // Ganti URL dengan URL API localhost kamu.
      // Catatan: Jika pakai Emulator Android, gunakan 'http://10.0.2.2/api_shopee/get_products.php'
      // Jika pakai Web/Browser, gunakan 'http://localhost/api_shopee/get_products.php'
      final url = Uri.parse('http://localhost/api_shopee/get_products.php');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          // Ambil data array dan mapping ke List<ProductItem>
          List<dynamic> productsJson = data['data'];
          setState(() {
            productList = productsJson
                .map((json) => ProductItem.fromJson(json))
                .toList();
            isLoading = false; // Matikan loading
          });
        } else {
          setState(() => isLoading = false);
        }
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("Gagal mengambil data produk: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tampilkan animasi loading jika data masih diambil
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(color: Colors.orange), // Warna shopee
      );
    }

    // Jika data kosong
    if (productList.isEmpty) {
      return Center(child: Text("Belum ada produk."));
    }

    // 4. Render Grid pakai data yang sudah di-fetch (productList)
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: productList.length, // Gunakan panjang produk dari database
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Sesuaikan dengan UI kamu
        childAspectRatio: 0.7,
      ),
      itemBuilder: (context, index) {
        final product = productList[index];
        // Masukkan 'product' ke dalam kartu desain UI kamu, contohnya:
        // return ProductCardWidget(product: product);

        // Contoh simple UI sementara:
        return Card(
          child: Column(
            children: [
              Image.asset(product.imagePath, height: 100, fit: BoxFit.cover),
              Text(product.title),
              Text(product.price, style: TextStyle(color: Colors.orange)),
            ],
          ),
        );
      },
    );
  }
}
