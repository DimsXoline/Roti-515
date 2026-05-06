<?php
require_once 'db.php';

$data = json_decode(file_get_contents('php://input'), true);
$id   = $data['id'] ?? '';

if (empty($id)) {
    echo json_encode(['success' => false, 'message' => 'ID produk wajib diisi']);
    exit;
}

// Ambil nama file gambar dulu sebelum dihapus
$stmt = $conn->prepare("SELECT gambar FROM products WHERE id = ?");
$stmt->bind_param("i", $id);
$stmt->execute();
$row = $stmt->get_result()->fetch_assoc();

// Hapus file gambar dari server kalau ada
if ($row && !empty($row['gambar'])) {
    $filePath = __DIR__ . '/uploads/' . $row['gambar'];
    if (file_exists($filePath)) {
        unlink($filePath);
    }
}

$stmt = $conn->prepare("DELETE FROM products WHERE id = ?");
$stmt->bind_param("i", $id);

if ($stmt->execute() && $stmt->affected_rows > 0) {
    echo json_encode(['success' => true, 'message' => 'Produk berhasil dihapus']);
} else {
    echo json_encode(['success' => false, 'message' => 'Produk tidak ditemukan']);
}
