import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import '../../utils/app_colors.dart';
import '../../models/product.dart';
import '../../services/product_service.dart';

class EditProductScreen extends StatefulWidget {
  final Product product;

  const EditProductScreen({super.key, required this.product});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  late TextEditingController _namaController;
  late TextEditingController _hargaController;
  late TextEditingController _stokController;
  late TextEditingController _deskripsiController;

  String _selectedKategori = 'roti';
  final List<String> _kategoriList = ['roti', 'pastri', 'cake', 'minuman'];
  
  String? _selectedBadge;
  final List<String> _badgeList = ['BEST SELLER', 'NEW'];

  File? _selectedImage;
  Uint8List? _webImageBytes;
  XFile? _pickedFile;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  bool _isImageChanged = false;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.product.nama);
    _hargaController = TextEditingController(text: widget.product.harga.toString());
    _stokController = TextEditingController(text: widget.product.stok.toString());
    _deskripsiController = TextEditingController(text: widget.product.deskripsi);
    _selectedKategori = widget.product.kategori?.toLowerCase() ?? 'roti';
    _selectedBadge = widget.product.badge;
  }

  @override
  void dispose() {
    _namaController.dispose();
    _hargaController.dispose();
    _stokController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null) {
      _pickedFile = image;
      _isImageChanged = true;
      if (kIsWeb) {
        final bytes = await image.readAsBytes();
        setState(() => _webImageBytes = bytes);
      } else {
        setState(() => _selectedImage = File(image.path));
      }
    }
  }

  Future<void> _updateProduct() async {
    // Validasi Nama
    if (_namaController.text.trim().isEmpty) {
      _showSnackBar('Nama produk wajib diisi', isError: true);
      return;
    }
    
    // Validasi Harga
    if (_hargaController.text.trim().isEmpty) {
      _showSnackBar('Harga wajib diisi', isError: true);
      return;
    }
    
    final harga = double.tryParse(_hargaController.text);
    if (harga == null) {
      _showSnackBar('Harga harus berupa angka', isError: true);
      return;
    }
    
    if (harga <= 0) {
      _showSnackBar('Harga harus lebih dari 0', isError: true);
      return;
    }

    // Validasi Stok
    if (_stokController.text.trim().isEmpty) {
      _showSnackBar('Stok wajib diisi', isError: true);
      return;
    }
    
    final stok = int.tryParse(_stokController.text);
    if (stok == null) {
      _showSnackBar('Stok harus berupa angka', isError: true);
      return;
    }
    
    if (stok < 0) {
      _showSnackBar('Stok tidak boleh negatif', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      late Map<String, dynamic> result;
      
      // Jika gambar diubah, upload gambar baru
      if (_isImageChanged && _hasImage) {
        result = await ProductService.updateProductImage(
          id: widget.product.id!,
          nama: _namaController.text.trim(),
          harga: harga,
          deskripsi: _deskripsiController.text.trim().isEmpty 
              ? 'Deskripsi produk' 
              : _deskripsiController.text.trim(),
          kategori: _selectedKategori,
          stok: stok,
          badge: _selectedBadge,
          gambar: kIsWeb ? null : _selectedImage,
          gambarBytes: kIsWeb ? _webImageBytes : null,
          gambarNama: _pickedFile?.name,
        );
      } else {
        // Update tanpa gambar
        result = await ProductService.updateProduct(
          id: widget.product.id!,
          nama: _namaController.text.trim(),
          harga: harga,
          deskripsi: _deskripsiController.text.trim().isEmpty 
              ? 'Deskripsi produk' 
              : _deskripsiController.text.trim(),
          kategori: _selectedKategori,
          stok: stok,
          badge: _selectedBadge,
        );
      }

      if (!mounted) return;

      if (result['success'] == true) {
        // Buat produk yang sudah diupdate
        final updatedProduct = Product(
          id: widget.product.id,
          nama: _namaController.text.trim(),
          deskripsi: _deskripsiController.text.trim().isEmpty 
              ? 'Deskripsi produk' 
              : _deskripsiController.text.trim(),
          harga: harga,
          stok: stok,
          kategori: _selectedKategori,
          badge: _selectedBadge,
          gambar: result['gambar'] ?? widget.product.gambar,
          gambarUrl: result['gambar_url'] ?? widget.product.gambarUrl,
        );

        Navigator.pop(context, updatedProduct);
        _showSnackBar('Produk berhasil diperbarui');
      } else {
        _showSnackBar(
          result['message'] ?? 'Gagal memperbarui produk',
          isError: true,
        );
      }
    } catch (e) {
      _showSnackBar('Terjadi kesalahan: $e', isError: true);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  bool get _hasImage {
    if (_isImageChanged) {
      return kIsWeb ? _webImageBytes != null : _selectedImage != null;
    }
    return widget.product.gambarUrl != null;
  }

  Widget _buildCurrentImage() {
    if (_isImageChanged) {
      if (kIsWeb && _webImageBytes != null) {
        return Image.memory(_webImageBytes!, fit: BoxFit.cover);
      } else if (_selectedImage != null) {
        return Image.file(_selectedImage!, fit: BoxFit.cover);
      }
    }
    
    if (widget.product.gambarUrl != null && widget.product.gambarUrl!.isNotEmpty) {
      return Image.network(
        widget.product.gambarUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(
          Icons.bakery_dining, 
          size: 50, 
          color: Color(0xFFB8952A),
        ),
        loadingBuilder: (_, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          );
        },
      );
    }
    
    return const Icon(
      Icons.bakery_dining, 
      size: 50, 
      color: Color(0xFFB8952A),
    );
  }

  String _getDisplayKategori(String kategori) {
    switch (kategori) {
      case 'roti': return 'ROTI';
      case 'pastri': return 'PASTRI';
      case 'cake': return 'CAKE';
      case 'minuman': return 'MINUMAN';
      default: return kategori.toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Edit Produk',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPhotoSection(),
            const SizedBox(height: 24),
            _buildFormSection(),
            const SizedBox(height: 32),
            _buildSaveButton(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoSection() {
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
            'Potret Produk',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Klik gambar untuk mengganti foto produk.',
            style: TextStyle(fontSize: 12, color: AppColors.textHint),
          ),
          const SizedBox(height: 4),
          Text(
            'Format: JPG, PNG, WEBP',
            style: TextStyle(fontSize: 11, color: AppColors.textHint),
          ),
          const SizedBox(height: 16),
          Center(
            child: GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: AppColors.toggleBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _hasImage 
                        ? AppColors.primary 
                        : AppColors.textHint.withValues(alpha: 0.3),
                    width: _hasImage ? 2 : 1,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _hasImage
                      ? Stack(
                          fit: StackFit.expand,
                          children: [
                            _buildCurrentImage(),
                            Positioned(
                              bottom: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 48,
                              color: AppColors.textHint,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Pilih Gambar',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'JPG, PNG, WEBP',
                              style: TextStyle(
                                color: AppColors.textHint,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection() {
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
          // NAMA PRODUK
          const Text(
            'NAMA PRODUK',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.textHint,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _namaController,
            decoration: InputDecoration(
              hintText: 'Contoh: Roti Sobek Special',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: AppColors.inputBg,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // KATEGORI
          const Text(
            'KATEGORI',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.textHint,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.inputBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedKategori,
                isExpanded: true,
                dropdownColor: Colors.white,
                items: _kategoriList.map((k) {
                  return DropdownMenuItem(
                    value: k,
                    child: Text(_getDisplayKategori(k)),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedKategori = value);
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 16),

          // HARGA
          const Text(
            'HARGA',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.textHint,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _hargaController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: '0',
              prefixText: 'Rp ',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: AppColors.inputBg,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // STOK
          const Text(
            'STOK',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.textHint,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _stokController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: '0',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: AppColors.inputBg,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // BADGE
          const Text(
            'BADGE',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.textHint,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.inputBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String?>(
                value: _selectedBadge,
                isExpanded: true,
                hint: const Text('Tidak ada badge'),
                dropdownColor: Colors.white,
                items: [
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Text('Tidak ada badge'),
                  ),
                  ..._badgeList.map((b) {
                    return DropdownMenuItem<String?>(
                      value: b,
                      child: Text(b),
                    );
                  }).toList(),
                ],
                onChanged: (value) {
                  setState(() => _selectedBadge = value);
                },
              ),
            ),
          ),
          const SizedBox(height: 16),

          // DESKRIPSI
          const Text(
            'DESKRIPSI',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.textHint,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _deskripsiController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Jelaskan profil rasa dan bahan-bahan utama...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: AppColors.inputBg,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _updateProduct,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'Simpan Perubahan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }
}