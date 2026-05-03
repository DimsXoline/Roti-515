<?php
require_once 'db.php';

$data = json_decode(file_get_contents('php://input'), true);
$id   = $data['id'] ?? '';

if (empty($id)) {
    echo json_encode(['success' => false, 'message' => 'ID user wajib diisi']);
    exit;
}

$stmt = $conn->prepare("DELETE FROM users WHERE id = ?");
$stmt->bind_param("i", $id);

if ($stmt->execute() && $stmt->affected_rows > 0) {
    echo json_encode(['success' => true, 'message' => 'User berhasil dihapus']);
} else {
    echo json_encode(['success' => false, 'message' => 'User tidak ditemukan']);
}
