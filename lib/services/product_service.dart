import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductService {
  // PERBAIKAN: Pastikan baseUrl sesuai
  static const String _baseUrl = 'http://localhost/roti_515_api';

  // ========== GET ALL PRODUCTS ==========
  static Future<List<Product>> getProducts() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/products.php'));
      final data = jsonDecode(response.body);
      if (data['success'] == true && data['products'] != null) {
        return (data['products'] as List)
            .map((p) => Product.fromJson(p))
            .toList();
      }
      return [];
    } catch (e) {
      print('Error getProducts: $e');
      return [];
    }
  }

  // ========== ADD PRODUCT + UPLOAD FOTO ==========
  static Future<Map<String, dynamic>> addProduct({
    required String nama,
    required double harga,
    required String deskripsi,
    required String kategori,
    required int stok,
    String? badge,
    File? gambar,
    Uint8List? gambarBytes,
    String? gambarNama,
  }) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/upload_product.php'),
      );

      request.fields['nama'] = nama;
      request.fields['harga'] = harga.toString();
      request.fields['deskripsi'] = deskripsi;
      request.fields['kategori'] = kategori;
      request.fields['stok'] = stok.toString();
      if (badge != null) request.fields['badge'] = badge;

      // Upload gambar
      if (gambar != null) {
        request.files.add(
          await http.MultipartFile.fromPath('gambar', gambar.path),
        );
      } else if (gambarBytes != null && gambarNama != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'gambar',
            gambarBytes,
            filename: gambarNama,
          ),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      return jsonDecode(response.body);
    } catch (e) {
      print('Error addProduct: $e');
      return {'success': false, 'message': 'Tidak dapat terhubung ke server: $e'};
    }
  }

  // ========== DELETE PRODUCT ==========
  static Future<Map<String, dynamic>> deleteProduct(int id) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/delete_product.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id': id}),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Tidak dapat terhubung ke server'};
    }
  }
}