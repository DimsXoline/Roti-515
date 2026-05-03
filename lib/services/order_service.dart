import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/order_model.dart';

class OrderService {
  static const String _baseUrl = 'http://localhost/roti_515_api';

  // ========== GET ALL ORDERS (admin) ==========
  Future<Map<String, dynamic>> getAllOrders() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/orders.php'),
        headers: {'Content-Type': 'application/json'},
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Tidak dapat terhubung ke server'};
    }
  }

  // ========== GET ORDERS BY STATUS ==========
  Future<List<OrderModel>> getOrdersByStatus(String status) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/orders.php?status=$status'),
        headers: {'Content-Type': 'application/json'},
      );
      final data = jsonDecode(response.body);
      if (data['success'] == true && data['orders'] != null) {
        return (data['orders'] as List)
            .map((o) => OrderModel.fromJson(o))
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // ========== GET ORDERS BY USER ==========
  Future<List<OrderModel>> getOrdersByUser(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/orders.php?user_id=$userId'),
        headers: {'Content-Type': 'application/json'},
      );
      final data = jsonDecode(response.body);
      if (data['success'] == true && data['orders'] != null) {
        return (data['orders'] as List)
            .map((o) => OrderModel.fromJson(o))
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // ========== UPDATE ORDER STATUS ==========
  Future<Map<String, dynamic>> updateOrderStatus(
    int orderId,
    String status,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/update_order.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id': orderId, 'status': status}),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Tidak dapat terhubung ke server'};
    }
  }

  // ========== CREATE ORDER ==========
  Future<Map<String, dynamic>> createOrder(
    Map<String, dynamic> orderData,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/create_order.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(orderData),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Tidak dapat terhubung ke server'};
    }
  }
}
