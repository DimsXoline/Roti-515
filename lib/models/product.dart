class Product {
  final int? id;
  final String nama;
  final String deskripsi;
  final double harga;
  final int stok;
  final String? imageUrl;
  final String? kategori;

  Product({
    this.id,
    required this.nama,
    required this.deskripsi,
    required this.harga,
    this.stok = 0,
    this.imageUrl,
    this.kategori,
  });

  String get formattedPrice {
    return 'Rp ${harga.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  static List<Product> get defaults => [
    Product(
      id: 1,
      nama: 'Roti Sobek Original',
      deskripsi: 'Roti sobek lembut dengan isian vanilla klasik',
      harga: 25000,
      stok: 24,
      kategori: 'ROTI',
    ),
    Product(
      id: 2,
      nama: 'Croissant Butter',
      deskripsi: 'Croissant renyah dengan lapisan mentega pilihan',
      harga: 18000,
      stok: 4,
      kategori: 'PASTRI',
    ),
    Product(
      id: 3,
      nama: 'Chiffon Cake Pandan',
      deskripsi: 'Kue chiffon ringan dengan aroma pandan segar',
      harga: 45000,
      stok: 20,
      kategori: 'CAKE',
    ),
    Product(
      id: 4,
      nama: 'Milk Bun',
      deskripsi: 'Roti susu Jepang yang super lembut dan fluffy',
      harga: 20000,
      stok: 12,
      kategori: 'ROTI',
    ),
  ];

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      nama: json['nama'] ?? json['name'] ?? '',
      deskripsi: json['deskripsi'] ?? json['description'] ?? '',
      harga:
          double.tryParse(
            json['harga']?.toString() ?? json['price']?.toString() ?? '0',
          ) ??
          0,
      stok:
          int.tryParse(
            json['stok']?.toString() ?? json['stock']?.toString() ?? '0',
          ) ??
          0,
      imageUrl: json['image_url'] ?? json['gambar'],
      kategori: json['kategori'] ?? json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nama': nama,
      'deskripsi': deskripsi,
      'harga': harga,
      'stok': stok,
      if (imageUrl != null) 'image_url': imageUrl,
      if (kategori != null) 'kategori': kategori,
    };
  }
}
