import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductService {
  // Gunakan 10.0.2.2 untuk Android emulator, localhost untuk web/iOS
  static const String _baseUrl = 'http://10.0.2.2/roti_515_api';

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

      print('Add response: ${response.body}');
      return jsonDecode(response.body);
    } catch (e) {
      print('Error addProduct: $e');
      return {
        'success': false,
        'message': 'Tidak dapat terhubung ke server: $e',
      };
    }
  }

  // ========== UPDATE PRODUCT (TANPA GAMBAR) ==========
  static Future<Map<String, dynamic>> updateProduct({
    required int id,
    required String nama,
    required double harga,
    required String deskripsi,
    required String kategori,
    required int stok,
    String? badge,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/update_product.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id': id,
          'nama': nama,
          'harga': harga,
          'deskripsi': deskripsi,
          'kategori': kategori,
          'stok': stok,
          'badge': badge,
        }),
      );

      print('Update response: ${response.body}');
      return jsonDecode(response.body);
    } catch (e) {
      print('Error updateProduct: $e');
      return {
        'success': false,
        'message': 'Tidak dapat terhubung ke server: $e',
      };
    }
  }

  // ========== UPDATE PRODUCT + GAMBAR ==========
  static Future<Map<String, dynamic>> updateProductImage({
    required int id,
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
        Uri.parse('$_baseUrl/update_product_image.php'),
      );

      request.fields['id'] = id.toString();
      request.fields['nama'] = nama;
      request.fields['harga'] = harga.toString();
      request.fields['deskripsi'] = deskripsi;
      request.fields['kategori'] = kategori;
      request.fields['stok'] = stok.toString();
      if (badge != null) request.fields['badge'] = badge;

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

      print('Update product image response: ${response.body}');
      return jsonDecode(response.body);
    } catch (e) {
      print('Error updateProductImage: $e');
      return {
        'success': false,
        'message': 'Tidak dapat terhubung ke server: $e',
      };
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
