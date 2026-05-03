<?php
require_once 'db.php';

$user_id = $_GET['user_id'] ?? '';
$status  = $_GET['status'] ?? '';

if (!empty($user_id)) {
    // Get orders by user
    $stmt = $conn->prepare("SELECT * FROM orders WHERE user_id = ? ORDER BY created_at DESC");
    $stmt->bind_param("i", $user_id);
} elseif (!empty($status)) {
    // Get orders by status (untuk admin)
    $stmt = $conn->prepare("SELECT * FROM orders WHERE status = ? ORDER BY created_at DESC");
    $stmt->bind_param("s", $status);
} else {
    // Get all orders (untuk admin)
    $stmt = $conn->prepare("SELECT * FROM orders ORDER BY created_at DESC");
}

$stmt->execute();
$result = $stmt->get_result();
$orders = [];

while ($row = $result->fetch_assoc()) {
    $orders[] = $row;
}

echo json_encode(['success' => true, 'orders' => $orders]);
