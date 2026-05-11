class OrderModel {
  final int id;
  final String orderNumber;
  final int userId;
  final String customerName;
  final String customerEmail;
  final int totalAmount;
  final String status;
  final String estimatedTime;
  final String paymentMethod;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.userId,
    required this.customerName,
    required this.customerEmail,
    required this.totalAmount,
    required this.status,
    required this.estimatedTime,
    required this.paymentMethod,
    required this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      orderNumber: json['order_number'],
      userId: json['user_id'],
      customerName: json['customer_name'],
      customerEmail: json['customer_email'],
      totalAmount: json['total_amount'],
      status: json['status'],
      estimatedTime: json['estimated_time'] ?? 'Belum ditentukan',
      paymentMethod: json['payment_method'] ?? 'Tunai',
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
