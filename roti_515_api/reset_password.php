<?php
require_once 'db.php';

$data         = json_decode(file_get_contents('php://input'), true);
$email        = $data['email'] ?? '';
$new_password = $data['new_password'] ?? '';

if (empty($email) || empty($new_password)) {
    echo json_encode(['success' => false, 'message' => 'Email dan password baru wajib diisi']);
    exit;
}

$hashed = password_hash($new_password, PASSWORD_BCRYPT);
$stmt = $conn->prepare("UPDATE users SET password = ? WHERE email = ?");
$stmt->bind_param("ss", $hashed, $email);

if ($stmt->execute() && $stmt->affected_rows > 0) {
    echo json_encode(['success' => true, 'message' => 'Password berhasil direset']);
} else {
    echo json_encode(['success' => false, 'message' => 'Email tidak ditemukan atau gagal update']);
}
