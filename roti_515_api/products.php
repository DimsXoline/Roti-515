<?php
require_once 'db.php';

$stmt = $conn->prepare("SELECT * FROM products ORDER BY created_at DESC");
$stmt->execute();
$result = $stmt->get_result();
$products = [];

while ($row = $result->fetch_assoc()) {
    // Tambahkan full URL gambar kalau ada
    if (!empty($row['gambar'])) {
        $row['gambar_url'] = 'http://localhost/roti-515/roti_515_api/uploads/' . $row['gambar'];
    } else {
        $row['gambar_url'] = null;
    }
    $products[] = $row;
}

echo json_encode(['success' => true, 'products' => $products]);
