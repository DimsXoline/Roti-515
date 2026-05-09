import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import '../../utils/app_colors.dart';
import '../../models/product.dart';
import '../../services/product_service.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  final TextEditingController _stokController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();

  // PERBAIKAN: Gunakan huruf kecil agar konsisten dengan database
  String _selectedKategori = 'roti';
  final List<String> _kategoriList = ['roti', 'pastri', 'cake', 'minuman'];

  File? _selectedImage;
  Uint8List? _webImageBytes;
  XFile? _pickedFile;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

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
      if (kIsWeb) {
        final bytes = await image.readAsBytes();
        setState(() => _webImageBytes = bytes);
      } else {
        setState(() => _selectedImage = File(image.path));
      }
    }
  }

  Future<void> _saveProduct() async {
    if (_namaController.text.isEmpty) {
      _showSnackBar('Nama produk wajib diisi', isError: true);
      return;
    }
    if (_hargaController.text.isEmpty) {
      _showSnackBar('Harga wajib diisi', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    final result = await ProductService.addProduct(
      nama: _namaController.text,
      harga: double.tryParse(_hargaController.text) ?? 0,
      deskripsi: _deskripsiController.text.isEmpty
          ? 'Deskripsi produk'
          : _deskripsiController.text,
      kategori: _selectedKategori,
      stok: int.tryParse(_stokController.text) ?? 0,
      gambar: kIsWeb ? null : _selectedImage,
      gambarBytes: kIsWeb ? _webImageBytes : null,
      gambarNama: _pickedFile?.name,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result['success'] == true) {
      final newProduct = result['product'] != null
          ? Product.fromJson(result['product'])
          : Product(
              nama: _namaController.text,
              deskripsi: _deskripsiController.text,
              harga: double.tryParse(_hargaController.text) ?? 0,
              stok: int.tryParse(_stokController.text) ?? 0,
              kategori: _selectedKategori,
            );

      Navigator.pop(context, newProduct);
      _showSnackBar('Produk berhasil ditambahkan');
    } else {
      _showSnackBar(
        result['message'] ?? 'Gagal menyimpan produk',
        isError: true,
      );
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  bool get _hasImage =>
      kIsWeb ? _webImageBytes != null : _selectedImage != null;

  // Fungsi untuk menampilkan kategori dalam huruf besar
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
          'Tambah Produk Baru',
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
            'Abadikan kerak keemasan dan tekstur lembutnya.',
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
                height: 180,
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
                child: _hasImage
                    ? Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: kIsWeb
                                ? Image.memory(
                                    _webImageBytes!,
                                    width: 150,
                                    height: 180,
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    _selectedImage!,
                                    width: 150,
                                    height: 180,
                                    fit: BoxFit.cover,
                                  ),
                          ),
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
          _buildLabel('NAMA PRODUK'),
          const SizedBox(height: 6),
          _buildTextField(_namaController, 'Roti Sobek, Sisir, Kopi...'),
          const SizedBox(height: 16),

          _buildLabel('KATEGORI'),
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
                items: _kategoriList.map((k) {
                  return DropdownMenuItem(
                    value: k,
                    child: Text(_getDisplayKategori(k)),
                  );
                }).toList(),
                onChanged: (value) =>
                    setState(() => _selectedKategori = value!),
              ),
            ),
          ),
          const SizedBox(height: 16),

          _buildLabel('HARGA'),
          const SizedBox(height: 6),
          _buildTextField(
            _hargaController,
            '0',
            keyboardType: TextInputType.number,
            prefixText: 'Rp ',
          ),
          const SizedBox(height: 16),

          _buildLabel('STOK'),
          const SizedBox(height: 6),
          _buildTextField(
            _stokController,
            '0',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),

          _buildLabel('DESKRIPSI'),
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

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        color: AppColors.textHint,
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    TextInputType keyboardType = TextInputType.text,
    String? prefixText,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        prefixText: prefixText,
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
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _saveProduct,
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
                'Simpan Produk',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }
}