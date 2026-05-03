<?php
require_once 'db.php';

$data  = json_decode(file_get_contents('php://input'), true);
$email = $data['email'] ?? '';

if (empty($email)) {
    echo json_encode(['success' => false, 'message' => 'Email wajib diisi']);
    exit;
}

$stmt = $conn->prepare("SELECT id FROM users WHERE email = ?");
$stmt->bind_param("s", $email);
$stmt->execute();
$user = $stmt->get_result()->fetch_assoc();

if ($user) {
    echo json_encode(['success' => true, 'message' => 'Email ditemukan']);
} else {
    echo json_encode(['success' => false, 'message' => 'Email tidak terdaftar']);
}
