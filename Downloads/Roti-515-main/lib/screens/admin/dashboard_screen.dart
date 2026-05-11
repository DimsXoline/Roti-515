import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../utils/app_colors.dart';
import 'products_screen.dart';
import 'orders_screen.dart';
import 'profile_screen.dart';

// ══════════════════════════════════════════════════════════════
// KONFIGURASI — sesuaikan jika nama folder berbeda
// ══════════════════════════════════════════════════════════════
const String _apiBase = 'http://localhost/roti_515_api';

// ══════════════════════════════════════════════════════════════
// ADMIN DASHBOARD SCREEN  (shell + bottom nav)
// ══════════════════════════════════════════════════════════════
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _currentIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      DashboardHomeScreen(
        onSeeAllOrders: () => setState(() => _currentIndex = 2),
      ),
      const ProductsScreen(),
      const AdminOrdersScreen(),
      const AdminProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'ROTI 515 Admin',
          style: TextStyle(
            color: AppColors.primaryDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: false,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textHint,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Produk'),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Order',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// DASHBOARD HOME SCREEN  (konten + fetch API)
// ══════════════════════════════════════════════════════════════
class DashboardHomeScreen extends StatefulWidget {
  final VoidCallback? onSeeAllOrders;
  const DashboardHomeScreen({super.key, this.onSeeAllOrders});

  @override
  State<DashboardHomeScreen> createState() => _DashboardHomeScreenState();
}

class _DashboardHomeScreenState extends State<DashboardHomeScreen> {
  // ── state ────────────────────────────────────────────────
  bool _isLoading = true;
  String? _errorMsg;
  double _todayRevenue = 0;
  double _revenueChange = 0;
  int _processingOrders = 0;
  int _restockNeeded = 0;
  int _activeProducts = 0;
  List _weeklyStats = [];
  List _recentOrders = [];

  @override
  void initState() {
    super.initState();
    _fetchDashboard();
  }

  // ── fetch data dari dashboard.php ────────────────────────
  Future<void> _fetchDashboard() async {
    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });
    try {
      final res = await http
          .get(Uri.parse('$_apiBase/dashboard.php'))
          .timeout(const Duration(seconds: 10));

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        if (body['success'] == true) {
          final d = body['data'];
          setState(() {
            _todayRevenue = (d['revenue']['today'] as num).toDouble();
            _revenueChange = (d['revenue']['change_percent'] as num).toDouble();
            _processingOrders = d['processing_orders'] as int;
            _restockNeeded = d['restock_needed'] as int;
            _activeProducts = d['active_products'] as int;
            _weeklyStats = d['weekly_stats'] as List;
            _recentOrders = d['recent_orders'] as List;
            _isLoading = false;
          });
          return;
        }
        throw Exception(body['message'] ?? 'Gagal memuat data');
      }
      throw Exception('HTTP ${res.statusCode}');
    } catch (e) {
      setState(() {
        _errorMsg = e.toString();
        _isLoading = false;
      });
    }
  }

  // ── helper format Rupiah ─────────────────────────────────
  String _rupiah(double amount) {
    final s = amount.toStringAsFixed(0);
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
      buf.write(s[i]);
    }
    return 'Rp ${buf.toString()}';
  }

  // ── warna status ─────────────────────────────────────────
  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'diproses':
        return Colors.blue;
      case 'menunggu':
        return Colors.orange;
      case 'selesai':
        return Colors.green;
      case 'cancelled':
      case 'dibatalkan':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // ══════════════════════════════════════════════════════════
  // BUILD
  // ══════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMsg != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off, size: 56, color: Colors.grey),
              const SizedBox(height: 12),
              Text(
                'Gagal memuat data\n$_errorMsg',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _fetchDashboard,
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Lagi'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final isPositive = _revenueChange >= 0;

    return RefreshIndicator(
      onRefresh: _fetchDashboard,
      color: AppColors.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Greeting ─────────────────────────────────
            const Text(
              'Selamat Datang, Admin',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Kelola toko roti Anda dengan mudah',
              style: TextStyle(fontSize: 14, color: AppColors.textHint),
            ),
            const SizedBox(height: 24),

            // ── Row 1: Revenue + Pesanan Aktif ───────────
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: 'Kinerja Harian',
                    value: _rupiah(_todayRevenue),
                    subtitle:
                        '${isPositive ? '+' : ''}$_revenueChange% dari kemarin',
                    icon: Icons.trending_up,
                    iconColor: Colors.green,
                    trendLabel: '${isPositive ? '+' : ''}$_revenueChange%',
                    trendPositive: isPositive,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    title: 'Pesanan Aktif',
                    value: _processingOrders.toString().padLeft(2, '0'),
                    subtitle: 'Sedang diproses',
                    icon: Icons.receipt_long,
                    iconColor: Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ── Row 2: Stok Menipis + Total Produk ───────
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: 'Stok Menipis',
                    value: _restockNeeded.toString().padLeft(2, '0'),
                    subtitle: 'Segera restock',
                    icon: Icons.warning,
                    iconColor: Colors.red,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    title: 'Total Produk',
                    value: _activeProducts.toString().padLeft(2, '0'),
                    subtitle: 'Produk aktif',
                    icon: Icons.inventory,
                    iconColor: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ── Grafik Statistik ──────────────────────────
            _buildChartSection(),
            const SizedBox(height: 24),

            // ── Pesanan Terbaru ───────────────────────────
            _buildRecentOrdersSection(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════
  // WIDGET HELPERS
  // ══════════════════════════════════════════════════════════

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    String? trendLabel,
    bool trendPositive = true,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 22, color: iconColor),
              ),
              if (trendLabel != null)
                Text(
                  trendLabel,
                  style: TextStyle(
                    fontSize: 11,
                    color: trendPositive ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: TextStyle(fontSize: 12, color: AppColors.textHint),
          ),
        ],
      ),
    );
  }

  // ── Bar chart dari data API ───────────────────────────────
  Widget _buildChartSection() {
    // Fallback ke dummy jika data kosong
    final stats = _weeklyStats.isNotEmpty
        ? _weeklyStats
        : List.generate(7, (i) {
            const days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
            return {'day': days[i], 'total_orders': 0};
          });

    final maxVal = stats
        .map((s) => (s['total_orders'] as int))
        .fold(1, (a, b) => a > b ? a : b); // minimal 1 agar tidak ÷0

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Statistik Pesanan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: stats.map<Widget>((stat) {
                final count = stat['total_orders'] as int;
                final barH = (count / maxVal) * 80 + (count > 0 ? 4 : 2);
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (count > 0)
                        Text(
                          '$count',
                          style: TextStyle(
                            fontSize: 9,
                            color: AppColors.textHint,
                          ),
                        ),
                      const SizedBox(height: 2),
                      Container(
                        width: 25,
                        height: barH,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        stat['day'] as String,
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ── Daftar pesanan terbaru dari API ───────────────────────
  Widget _buildRecentOrdersSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pesanan Terbaru',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),

          // ── list atau empty state ──
          if (_recentOrders.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text(
                  'Belum ada pesanan',
                  style: TextStyle(color: AppColors.textHint),
                ),
              ),
            )
          else
            ..._recentOrders.map((order) {
              final status = order['status'] as String? ?? '-';
              final orderCode =
                  order['order_code'] as String? ?? '#${order['id']}';
              final customer = order['customer_name'] as String? ?? 'Unknown';
              final price = (order['total_price'] as num).toDouble();

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    // ikon
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: AppColors.toggleBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.receipt,
                        size: 22,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // order id + customer
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            orderCode,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            customer,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textHint,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // harga
                    Text(
                      _rupiah(price),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // badge status
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _statusColor(status).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          fontSize: 10,
                          color: _statusColor(status),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),

          const SizedBox(height: 8),
          Center(
            child: TextButton(
              onPressed: widget.onSeeAllOrders,
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
              child: const Text('Lihat Semua Pesanan'),
            ),
          ),
        ],
      ),
    );
  }
}
