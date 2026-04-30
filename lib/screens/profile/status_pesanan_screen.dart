import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../services/auth_service.dart';

class StatusPesananScreen extends StatefulWidget {
  const StatusPesananScreen({super.key});

  @override
  State<StatusPesananScreen> createState() => _StatusPesananScreenState();
}

class _StatusPesananScreenState extends State<StatusPesananScreen> {
  List<Map<String, dynamic>> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() => _isLoading = true);

    final userId = await AuthService.getUserId();

    if (userId != null) {
      final result = await AuthService.getOrders(userId: userId);
      if (result['success'] == true) {
        final allOrders = List<Map<String, dynamic>>.from(result['orders']);
        // Filter hanya pesanan yang BELUM selesai
        setState(() {
          _orders = allOrders
              .where((order) => order['status'] != 'Selesai')
              .toList();
          _isLoading = false;
        });
        return;
      }
    }

    // Data dummy
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _orders = [
        {
          'id': '#BRD-88291',
          'order_number': '#BRD-88291',
          'status': 'Sedang Dipanggang',
          'estimated_time': '45 Menit',
          'progress': 60,
        },
        {
          'id': '#ORD-2841',
          'order_number': '#ORD-2841',
          'status': 'Diproses',
          'estimated_time': '30 Menit',
          'progress': 30,
        },
        {
          'id': '#ORD-2845',
          'order_number': '#ORD-2845',
          'status': 'Menunggu',
          'estimated_time': 'Belum ditentukan',
          'progress': 0,
        },
      ];
      _isLoading = false;
    });
  }

  String _getStatusMessage(String status) {
    switch (status) {
      case 'Sedang Dipanggang':
        return 'Roti Anda sedang dalam oven. Kami memastikan gurih sempurna!';
      case 'Diproses':
        return 'Pesanan Anda sedang dipersiapkan dengan bahan-bahan terbaik.';
      case 'Menunggu':
        return 'Pesanan Anda akan segera diproses. Terima kasih telah menunggu.';
      case 'Siap Diambil':
        return 'Pesanan Anda sudah siap! Segera ambil di toko.';
      default:
        return 'Pesanan Anda sedang diproses.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Status Pesanan',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _orders.isEmpty
          ? _buildEmptyState()
          : RefreshIndicator(
              onRefresh: _loadOrders,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _orders.length,
                itemBuilder: (context, index) {
                  final order = _orders[index];
                  return _buildOrderCard(order);
                },
              ),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 80,
            color: AppColors.textHint,
          ),
          const SizedBox(height: 16),
          Text(
            'Tidak ada pesanan aktif',
            style: TextStyle(color: AppColors.textHint, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            'Belum ada pesanan yang sedang diproses',
            style: TextStyle(color: AppColors.textHint, fontSize: 12),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Kembali'),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    final status = order['status'] ?? 'Menunggu';
    final estimatedTime = order['estimated_time'] ?? 'Belum ditentukan';
    final progress = (order['progress'] ?? 0).toDouble();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ID PESANAN ${order['order_number'] ?? order['id']}',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textHint,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: status == 'Sedang Dipanggang'
                      ? Colors.orange.withOpacity(0.1)
                      : status == 'Diproses'
                      ? Colors.blue.withOpacity(0.1)
                      : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 11,
                    color: status == 'Sedang Dipanggang'
                        ? Colors.orange
                        : status == 'Diproses'
                        ? Colors.blue
                        : Colors.orange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ESTIMASI SIAP
          const Text(
            'ESTIMASI SIAP',
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textHint,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            estimatedTime,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          const SizedBox(height: 16),

          // Progress Bar
          if (progress > 0) ...[
            const Text(
              'Kemajuan Panggangan',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress / 100,
                      backgroundColor: AppColors.toggleBg,
                      color: Colors.orange,
                      minHeight: 8,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${progress.toInt()}%',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],

          // Status Message
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.emoji_food_beverage,
                  size: 18,
                  color: Colors.orange,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _getStatusMessage(status),
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.orange.shade800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
