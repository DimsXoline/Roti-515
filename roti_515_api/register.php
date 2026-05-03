<?php
require_once 'db.php';

$data     = json_decode(file_get_contents('php://input'), true);
$nama     = $data['nama'] ?? '';
$email    = $data['email'] ?? '';
$phone    = $data['phone'] ?? '';
$password = $data['password'] ?? '';

if (empty($nama) || empty($email) || empty($password)) {
    echo json_encode(['success' => false, 'message' => 'Nama, email, dan password wajib diisi']);
    exit;
}

// Cek email sudah terdaftar
$stmt = $conn->prepare("SELECT id FROM users WHERE email = ?");
$stmt->bind_param("s", $email);
$stmt->execute();
$stmt->get_result()->fetch_assoc() && die(json_encode(['success' => false, 'message' => 'Email sudah terdaftar']));

$hashed = password_hash($password, PASSWORD_BCRYPT);
$stmt = $conn->prepare("INSERT INTO users (nama, email, phone, password, role) VALUES (?, ?, ?, ?, 'pelanggan')");
$stmt->bind_param("ssss", $nama, $email, $phone, $hashed);

if ($stmt->execute()) {
    $id = $conn->insert_id;
    echo json_encode([
        'success' => true,
        'message' => 'Registrasi berhasil',
        'user'    => ['id' => $id, 'nama' => $nama, 'email' => $email, 'phone' => $phone, 'role' => 'pelanggan']
    ]);
} else {
    echo json_encode(['success' => false, 'message' => 'Registrasi gagal']);
}
