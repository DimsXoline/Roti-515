class Product {
  final int? id;
  final String nama;
  final String? deskripsi; // nullable, karena database bisa null
  final double harga;
  final int stok;
  final String? gambar;
  final String? gambarUrl;
  final String? kategori;
  final String? badge;

  Product({
    this.id,
    required this.nama,
    this.deskripsi,
    required this.harga,
    this.stok = 0,
    this.gambar,
    this.gambarUrl,
    this.kategori,
    this.badge,
  });

  String get formattedPrice {
    return 'Rp ${harga.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  static List<Product> get defaults => [
    Product(
      id: 1,
      nama: 'MARIE WIJEN',
      deskripsi:
          'Satu loyang isi 6 potong. Tekstur empuk, isian penuh, dan manisnya pas.',
      harga: 28000,
      stok: 24,
      kategori: 'roti',
      badge: 'BEST SELLER',
    ),
    Product(
      id: 2,
      nama: 'ROTI BOLO KERING',
      deskripsi:
          'Teksturnya empuk dan mudah dilepas, sangat cocok jadi teman setia kopi atau teh Anda di pagi hari.',
      harga: 28000,
      stok: 4,
      kategori: 'roti',
    ),
    Product(
      id: 3,
      nama: 'ONDE ONDE KETAWA',
      deskripsi:
          'Inovasi roti kopi yang disajikan dingin dengan tekstur super lembut seperti salju.',
      harga: 28000,
      stok: 20,
      kategori: 'roti',
    ),
    Product(
      id: 4,
      nama: 'PIA KACANG',
      deskripsi:
          'Varian siap saji dengan isian cokelat klasik yang manis dan gurih.',
      harga: 28000,
      stok: 12,
      kategori: 'roti',
      badge: 'BEST SELLER',
    ),
  ];

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      nama: json['nama'] ?? '',
      deskripsi: json['deskripsi'], // biarkan null kalau memang null
      harga: double.tryParse(json['harga']?.toString() ?? '0') ?? 0,
      stok: int.tryParse(json['stok']?.toString() ?? '0') ?? 0,
      gambar: json['gambar'],
      gambarUrl: json['gambar_url'],
      kategori: json['kategori'],
      badge: json['badge'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nama': nama,
      'deskripsi': deskripsi ?? '',
      'harga': harga,
      'stok': stok,
      if (gambar != null) 'gambar': gambar,
      if (kategori != null) 'kategori': kategori,
      if (badge != null) 'badge': badge,
    };
  }
}
