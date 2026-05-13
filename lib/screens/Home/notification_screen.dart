import 'package:flutter/material.dart';
import '../../services/url_launcher_service.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool _hasNew = true;

  void _markAllRead() {
    setState(() => _hasNew = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Notifikasi',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                children: [
                  _buildPickupCard(),
                  const SizedBox(height: 16),
                  _buildSectionLabel('KEMARIN'),
                  const SizedBox(height: 8),
                  _buildPaymentCard(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Notifikasi Terbaru',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          GestureDetector(
            onTap: _markAllRead,
            child: Text(
              'TANDAI DIBACA',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: _hasNew ? const Color(0xFF1565C0) : Colors.grey,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPickupCard() {
    return _NotifCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _iconCircle(Icons.storefront_outlined),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Pesanan Siap Diambil',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (_hasNew) _newBadge(),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Roti Sourdough dan 2 Croissant Anda sudah siap di kasir. '
                      'Silakan tunjukkan Bukti Pembelian.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF555555),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => UrlLauncherService.openMaps(context: context),
            icon: const Icon(Icons.near_me_outlined, size: 14),
            label: const Text('Petunjuk Jalan', style: TextStyle(fontSize: 12)),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF444444),
              side: const BorderSide(color: Color(0xFFCCCCCC)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard() {
    return _NotifCard(
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.check, size: 16, color: Color(0xFF999999)),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pembayaran Berhasil',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Terima kasih atas pesanan Anda #BAK10239.',
                  style: TextStyle(fontSize: 12, color: Color(0xFF888888)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconCircle(IconData icon) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Icon(icon, size: 18, color: const Color(0xFF666666)),
    );
  }

  Widget _newBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFE7F3E8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'NEW',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: Color(0xFF2E7D32),
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Color(0xFF999999),
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _NotifCard extends StatelessWidget {
  final Widget child;
  const _NotifCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEEEEEE), width: 0.5),
      ),
      child: child,
    );
  }
}