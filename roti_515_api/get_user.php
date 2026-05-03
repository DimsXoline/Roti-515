<?php
require_once 'db.php';

$user_id = $_GET['id'] ?? '';

if (empty($user_id)) {
    echo json_encode(['success' => false, 'message' => 'ID user wajib diisi']);
    exit;
}

$stmt = $conn->prepare("SELECT id, nama, email, phone, role FROM users WHERE id = ?");
$stmt->bind_param("i", $user_id);
$stmt->execute();
$user = $stmt->get_result()->fetch_assoc();

if ($user) {
    echo json_encode(['success' => true, 'user' => $user]);
} else {
    echo json_encode(['success' => false, 'message' => 'User tidak ditemukan']);
}
