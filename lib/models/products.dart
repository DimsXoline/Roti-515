class Product {
  final int id;
  final String nama;
  final String deskripsi;
  final double harga;
  final String? badge;

  Product({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.harga,
    this.badge,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: int.parse(json['id'].toString()),
      nama: json['nama'],
      deskripsi: json['deskripsi'] ?? '',
      harga: double.parse(json['harga'].toString()),
      badge: json['badge'],
    );
  }

  // Data default
  static List<Product> get defaults => [
    Product(id: 1, nama: 'ROTI SOBEK', 
        deskripsi: 'Satu loyang isi 6 potong. Tekstur empuk, isian penuh, dan manisnya pas.',
        harga: 15000, badge: 'BEST SELLER'),
    Product(id: 2, nama: 'ROTI SISIR',
        deskripsi: 'Teksturnya empuk dan mudah dilepas, sangat cocok jadi teman setia kopi atau teh Anda di pagi hari.',
        harga: 15000),
    Product(id: 3, nama: 'ROTI KOPI',
        deskripsi: 'Inovasi roti kopi yang disajikan dingin dengan tekstur super lembut seperti salju.',
        harga: 10000),
    Product(id: 4, nama: 'ROTI BAKAR BANDUNG',
        deskripsi: 'Varian siap saji dengan isian cokelat klasik yang manis dan gurih.',
        harga: 15000, badge: 'BEST SELLER'),
  ];

  String get formattedPrice => 'Rp ${harga.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
}