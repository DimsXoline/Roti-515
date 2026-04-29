import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  List<Map<String, dynamic>> _orders = [];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  void _loadOrders() {
    // Data pesanan dari database (nanti connect ke API)
    // readyTime adalah jam yang sudah diatur admin
    _orders = [
      {
        'id': '#BRD-88291',
        'name': 'ROTI SOBEK + ROTI SISIR',
        'status': 'Selesai',
        'isProcess': false,
        'date': '26 Apr 2026, 14:30',
        'total': 92000,
        'progress': 100,
        'estimatedTime': '45 Menit',
        'readyTime': '15:30',  // ← Jam siap diambil dari admin
      },
      {
        'id': '#ORD-2841',
        'name': 'Roti Sourdough Klasik + Croissant Almond',
        'status': 'Sedang Dipanggang',
        'isProcess': true,
        'date': '27 Apr 2026, 13:00',
        'total': 85000,
        'progress': 60,
        'estimatedTime': '12 Menit',
        'readyTime': '15:30',  // ← Estimasi dari admin
      },
      {
        'id': '#ORD-2845',
        'name': 'Cupcake Vanilla Pink (6x)',
        'status': 'PERSIAPAN AKHIR',
        'isProcess': true,
        'date': '27 Apr 2026, 14:00',
        'total': 120000,
        'progress': 80,
        'estimatedTime': '4 Menit',
        'readyTime': '16:00',
      },
      {
        'id': '#ORD-7752',
        'name': 'ROTI SOBEK (3x)',
        'status': 'Selesai',
        'isProcess': false,
        'date': '25 Apr 2026, 10:30',
        'total': 45000,
        'progress': 100,
        'estimatedTime': 'Selesai',
        'readyTime': '11:00',
      },
    ];
  }

  String _formatPrice(int price) {
    return 'Rp ${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Riwayat Pesanan',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: _orders.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _orders.length,
              itemBuilder: (context, index) => _buildOrderCard(_orders[index]),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, size: 80, color: AppColors.textHint),
          const SizedBox(height: 16),
          Text('Belum ada pesanan', style: TextStyle(color: AppColors.textHint)),
          const SizedBox(height: 8),
          Text('Mulai pesan roti favoritmu!', style: TextStyle(color: AppColors.textHint, fontSize: 12)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Mulai Belanja'),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    final isProcess = order['isProcess'] ?? false;
    final progress = order['progress'] ?? 0;
    final estimatedTime = order['estimatedTime'] ?? '';
    final status = order['status'] ?? '';
    final name = order['name'] ?? '';
    final id = order['id'] ?? '';
    final date = order['date'] ?? '';
    final total = order['total'] ?? 0;
    final readyTime = order['readyTime'] ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (isProcess) {
              _showOrderDetailDialog(order);
            }
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isProcess ? Colors.orange.withOpacity(0.1) : Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          fontSize: 11,
                          color: isProcess ? Colors.orange : Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  id,
                  style: TextStyle(fontSize: 11, color: AppColors.textHint),
                ),
                const SizedBox(height: 8),
                if (isProcess) ...[
                  _buildProgressBar(progress),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.timer, size: 14, color: Colors.orange),
                          const SizedBox(width: 4),
                          Text('Estimasi Siap', style: TextStyle(fontSize: 11, color: AppColors.textHint)),
                        ],
                      ),
                      Text(
                        estimatedTime,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.orange),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.emoji_food_beverage, size: 18, color: Colors.orange),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Roti Anda sedang dipersiapkan dengan cermat.',
                            style: TextStyle(fontSize: 11, color: Colors.orange.shade800),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Divider(color: AppColors.toggleBg),
                const SizedBox(height: 8),
                // Tampilkan jam siap diambil jika ada
                if (readyTime.isNotEmpty && !isProcess)
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.access_time, size: 14, color: Colors.blue),
                        const SizedBox(width: 8),
                        const Text(
                          'Siap diambil pukul:',
                          style: TextStyle(fontSize: 11),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          readyTime,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('TOTAL BAYAR', style: TextStyle(fontSize: 10, color: AppColors.textHint)),
                        const SizedBox(height: 2),
                        Text(_formatPrice(total), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Text(
                      date,
                      style: TextStyle(fontSize: 10, color: AppColors.textHint),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar(int progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Kemajuan Panggangan', style: TextStyle(fontSize: 11)),
            Text('$progress%', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.orange)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress / 100,
            backgroundColor: AppColors.toggleBg,
            color: Colors.orange,
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  void _showOrderDetailDialog(Map<String, dynamic> order) {
    final progress = order['progress'] ?? 0;
    final estimatedTime = order['estimatedTime'] ?? '';
    final readyTime = order['readyTime'] ?? '';
    final id = order['id'] ?? '';
    final status = order['status'] ?? '';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(id, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 4),
            Text(status, style: const TextStyle(fontSize: 12, color: Colors.orange)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildProgressBar(progress),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.timer, color: Colors.orange, size: 24),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('ESTIMASI SIAP', style: TextStyle(fontSize: 10)),
                      Text(estimatedTime, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange)),
                    ],
                  ),
                ],
              ),
            ),
            if (readyTime.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.access_time, color: Colors.blue, size: 24),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('JAM AMBIL', style: TextStyle(fontSize: 10)),
                        Text(readyTime, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.toggleBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.emoji_food_beverage, color: Colors.brown),
                  const SizedBox(width: 12),
                  const Text('Aroma Fresh', style: TextStyle(fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}