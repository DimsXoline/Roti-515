import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseService {
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // Inisialisasi Firebase
  static Future<void> initialize() async {
    await Firebase.initializeApp();
    
    // Setup local notifikasi
    await _setupLocalNotifications();
    
    // Dapatkan token FCM
    await _getToken();
    
    // Setup handlers
    _setupMessageHandlers();
  }

  // Setup local notifikasi
  static Future<void> _setupLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();
    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    await _localNotifications.initialize(settings);
  }

  // Dapatkan token FCM (kirim ke backend)
  static Future<void> _getToken() async {
    String? token = await _fcm.getToken();
    print('FCM Token: $token');
    // TODO: Kirim token ke backend Anda
    // await _sendTokenToBackend(token);
  }

  // Setup message handlers
  static void _setupMessageHandlers() {
    // Tangani notifikasi saat aplikasi terbuka
    FirebaseMessaging.onMessage.listen(_handleMessage);
    
    // Tangani notifikasi saat aplikasi di background
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  // Handle message saat aplikasi aktif
  static void _handleMessage(RemoteMessage message) {
    print('Received message: ${message.messageId}');
    _showNotification(
      message.notification?.title ?? 'Notifikasi',
      message.notification?.body ?? '',
    );
  }

  // Tampilkan notifikasi lokal
  static void _showNotification(String title, String body) {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'order_channel',
      'Order Updates',
      importance: Importance.high,
      priority: Priority.high,
    );
    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );
    _localNotifications.show(0, title, body, details);
  }
}

// Handler untuk background message (harus di luar class)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling background message: ${message.messageId}');
}