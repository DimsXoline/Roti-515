<?php
require_once 'db.php';

$data = json_decode(file_get_contents('php://input'), true);
$email    = $data['email'] ?? '';
$password = $data['password'] ?? '';

if (empty($email) || empty($password)) {
    echo json_encode(['success' => false, 'message' => 'Email dan password wajib diisi']);
    exit;
}

$stmt = $conn->prepare("SELECT * FROM users WHERE email = ?");
$stmt->bind_param("s", $email);
$stmt->execute();
$result = $stmt->get_result();
$user = $result->fetch_assoc();

if (!$user) {
    echo json_encode(['success' => false, 'message' => 'Email tidak ditemukan']);
    exit;
}

if (!password_verify($password, $user['password'])) {
    echo json_encode(['success' => false, 'message' => 'Password salah']);
    exit;
}

echo json_encode([
    'success' => true,
    'token'   => bin2hex(random_bytes(16)),
    'user'    => [
        'id'    => $user['id'],
        'nama'  => $user['nama'],
        'email' => $user['email'],
        'phone' => $user['phone'],
        'role'  => $user['role'],
    ]
]);
