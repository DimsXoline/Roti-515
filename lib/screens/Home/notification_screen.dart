import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notifikasi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4E342E)),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const NotificationScreen(),
    );
  }
}

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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                children: [
                  _buildPickupCard(),
                  const SizedBox(height: 10),
                  _buildReadyCard(),
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

  // ── Kartu 1: Pesanan Siap Diambil ──────────────────────────────────────────
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
                      'Silakan tunjukkan kode QR di bawah saat pengambilan.',
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
            onPressed: () {},
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

  // ── Kartu 2: Pesanan Sudah Siap ────────────────────────────────────────────
  Widget _buildReadyCard() {
    return _NotifCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Pesanan Sudah Siap',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              const Text(
                '2 menit lalu',
                style: TextStyle(fontSize: 11, color: Color(0xFF999999)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          RichText(
            text: const TextSpan(
              style: TextStyle(fontSize: 12, color: Color(0xFF555555)),
              children: [
                TextSpan(text: 'Batas waktu mengambil pesanan '),
                TextSpan(
                  text: '10:15 AM.',
                  style: TextStyle(
                    color: Color(0xFF1565C0),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Map preview
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              height: 120,
              child: Stack(
                children: [
                  _MapPreviewPainter(),
                  Positioned(bottom: 8, left: 8, child: _liveBadge()),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Track button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.my_location_rounded,
                size: 16,
                color: Colors.white,
              ),
              label: const Text(
                'Lacak Pesanan',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4E342E),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Kartu 3: Pembayaran Berhasil ───────────────────────────────────────────
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

  // ── Helpers ────────────────────────────────────────────────────────────────
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

  Widget _liveBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF1B5E20),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _PulsingDot(),
          const SizedBox(width: 4),
          const Text(
            'PELACAKAN AKTIF',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ],
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

// ── Reusable card wrapper ────────────────────────────────────────────────────
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

// ── Map preview painted widget ───────────────────────────────────────────────
class _MapPreviewPainter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 120),
      painter: _MapPainter(),
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFFB2DFDB);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final roadPaint = Paint()..color = const Color(0xFFE0F2F1);

    // Horizontal roads
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.25, size.width, 22),
      roadPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.62, size.width, 18),
      roadPaint,
    );

    // Vertical roads
    for (final x in [size.width * 0.18, size.width * 0.50, size.width * 0.80]) {
      canvas.drawRect(Rect.fromLTWH(x, 0, 20, size.height), roadPaint);
    }

    // Blocks
    final blockPaint = Paint()
      ..color = const Color(0xFF80CBC4).withOpacity(0.8);
    final blocks = [
      Rect.fromLTWH(6, 6, 36, 16),
      Rect.fromLTWH(size.width * 0.28, 8, 58, 14),
      Rect.fromLTWH(size.width * 0.58, 4, 50, 18),
      Rect.fromLTWH(6, size.height * 0.5, 28, 10),
      Rect.fromLTWH(size.width * 0.28, size.height * 0.47, 55, 13),
      Rect.fromLTWH(size.width * 0.58, size.height * 0.49, 44, 11),
      Rect.fromLTWH(6, size.height * 0.8, 30, 18),
      Rect.fromLTWH(size.width * 0.28, size.height * 0.82, 58, 16),
      Rect.fromLTWH(size.width * 0.58, size.height * 0.8, 48, 18),
    ];
    for (final b in blocks) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(b, const Radius.circular(2)),
        blockPaint,
      );
    }

    // Pin
    final cx = size.width / 2;
    final cy = size.height / 2 + 4;

    final outerCircle = Paint()..color = const Color(0xFFE53935);
    canvas.drawCircle(Offset(cx, cy), 8, outerCircle);
    final innerCircle = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(cx, cy), 4, innerCircle);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Pulsing dot for live badge ───────────────────────────────────────────────
class _PulsingDot extends StatefulWidget {
  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.3, end: 1.0).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _anim,
      child: Container(
        width: 7,
        height: 7,
        decoration: BoxDecoration(
          color: const Color(0xFF69F0AE),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
