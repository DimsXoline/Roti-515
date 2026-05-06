<?php
require_once 'db.php';

$nama      = $_POST['nama'] ?? '';
$harga     = $_POST['harga'] ?? 0;
$deskripsi = $_POST['deskripsi'] ?? '';
$kategori  = $_POST['kategori'] ?? '';
$stok      = $_POST['stok'] ?? 0;
$badge     = $_POST['badge'] ?? null;

if (empty($nama) || empty($harga)) {
    echo json_encode(['success' => false, 'message' => 'Nama dan harga wajib diisi']);
    exit;
}

$namaFile = null;

// Handle upload foto
if (isset($_FILES['gambar']) && $_FILES['gambar']['error'] === UPLOAD_ERR_OK) {
    $uploadDir = __DIR__ . '/uploads/';
    
    // Buat folder uploads kalau belum ada
    if (!is_dir($uploadDir)) {
        mkdir($uploadDir, 0755, true);
    }

    $ext      = pathinfo($_FILES['gambar']['name'], PATHINFO_EXTENSION);
    $allowed  = ['jpg', 'jpeg', 'png', 'webp'];

    if (!in_array(strtolower($ext), $allowed)) {
        echo json_encode(['success' => false, 'message' => 'Format gambar tidak didukung. Gunakan jpg, png, atau webp']);
        exit;
    }

    $namaFile = uniqid('produk_') . '.' . $ext;
    move_uploaded_file($_FILES['gambar']['tmp_name'], $uploadDir . $namaFile);
}

$stmt = $conn->prepare(
    "INSERT INTO products (nama, harga, deskripsi, gambar, kategori, badge, stok) VALUES (?, ?, ?, ?, ?, ?, ?)"
);
$stmt->bind_param("sdssssi", $nama, $harga, $deskripsi, $namaFile, $kategori, $badge, $stok);

if ($stmt->execute()) {
    $id = $conn->insert_id;
    echo json_encode([
        'success' => true,
        'message' => 'Produk berhasil ditambahkan',
        'product' => [
            'id'        => $id,
            'nama'      => $nama,
            'harga'     => $harga,
            'deskripsi' => $deskripsi,
            'gambar'    => $namaFile,
            'gambar_url'=> $namaFile ? 'http://localhost/roti-515/roti_515_api/uploads/' . $namaFile : null,
            'kategori'  => $kategori,
            'badge'     => $badge,
            'stok'      => $stok,
        ]
    ]);
} else {
    echo json_encode(['success' => false, 'message' => 'Gagal menyimpan produk']);
}
