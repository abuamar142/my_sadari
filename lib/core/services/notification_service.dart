import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

/// NotificationService for SADARI reminder notifications
///
/// Current configuration uses default system sounds.
class NotificationService extends GetxService {
  static final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static const String _channelId = 'sadari_reminder_channel';
  static const String _channelName = 'SADARI Reminder';
  static const String _channelDescription =
      'Pengingat untuk melakukan pemeriksaan SADARI';

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initializeNotifications();
    await _initializeTimezone();
  }

  Future<void> _initializeTimezone() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));
  }

  Future<void> _initializeNotifications() async {
    // Android settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS settings
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channel for Android
    if (Platform.isAndroid) {
      await _createNotificationChannel();
    }

    // Request permissions
    await _requestPermissions();
  }

  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.high,
      // Removed custom sound, using default system sound
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  Future<void> _requestPermissions() async {
    if (Platform.isAndroid) {
      // Request notification permission for Android 13+
      final permissionStatus = await Permission.notification.request();
      if (permissionStatus.isDenied) {
        if (kDebugMode) {
          print('Notification permission denied');
        }
        _showPermissionDialog();
      }

      // Request exact alarm permission for Android 12+
      await _requestExactAlarmPermission();
    } else if (Platform.isIOS) {
      // Request iOS permissions
      final result = await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);

      if (result == false) {
        _showPermissionDialog();
      }
    }
  }

  Future<void> _requestExactAlarmPermission() async {
    try {
      final exactAlarmStatus = await Permission.scheduleExactAlarm.status;

      if (exactAlarmStatus.isDenied) {
        // Show explanation dialog before requesting
        await _showExactAlarmExplanationDialog();

        // Request permission
        final result = await Permission.scheduleExactAlarm.request();

        if (result.isDenied) {
          if (kDebugMode) {
            print(
              'Exact alarm permission denied - will use inexact scheduling',
            );
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error requesting exact alarm permission: $e');
      }
    }
  }

  void _onNotificationTapped(NotificationResponse notificationResponse) {
    final String? payload = notificationResponse.payload;
    if (payload != null) {
      // Handle notification tap
      // Navigate to appropriate screen based on payload
      Get.toNamed('/schedule');
    }
  }

  // Schedule SADARI reminder notifications
  Future<void> scheduleSadariReminders({
    required String scheduleId,
    required List<DateTime> reminderDates,
    String? notes,
  }) async {
    try {
      // Check and request permission first
      final hasPermission = await ensureNotificationPermission();

      if (!hasPermission) {
        Get.snackbar(
          'Izin Diperlukan',
          'Notifikasi tidak dapat diatur tanpa izin. Anda dapat mengaktifkannya di pengaturan.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: Duration(seconds: 4),
          mainButton: TextButton(
            onPressed: () {
              openNotificationSettings();
            },
            child: Text('Pengaturan', style: TextStyle(color: Colors.white)),
          ),
        );
        return;
      }

      // Cancel any existing notifications for this schedule
      await cancelScheduleNotifications(scheduleId);

      for (int i = 0; i < reminderDates.length; i++) {
        final reminderDate = reminderDates[i];
        final notificationId = _generateNotificationId(scheduleId, i);

        // Only schedule future notifications
        if (reminderDate.isAfter(DateTime.now())) {
          await _scheduleNotification(
            notificationId: notificationId,
            scheduledDate: reminderDate,
            dayNumber: i + 7, // Day 7, 8, 9, 10
            notes: notes,
          );
        }
      }

      // Show success message
      Get.snackbar(
        'Berhasil',
        'Pengingat SADARI telah diatur untuk ${reminderDates.length} hari',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );

      if (kDebugMode) {
        print(
          'Scheduled ${reminderDates.length} SADARI reminders for schedule: $scheduleId',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error scheduling SADARI reminders: $e');
      }
      Get.snackbar(
        'Error',
        'Gagal mengatur reminder: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _scheduleNotification({
    required int notificationId,
    required DateTime scheduledDate,
    required int dayNumber,
    String? notes,
  }) async {
    // Schedule for 9:00 AM
    final scheduledTime = DateTime(
      scheduledDate.year,
      scheduledDate.month,
      scheduledDate.day,
      9, // 9 AM
      0, // 0 minutes
    );

    final tz.TZDateTime tzScheduledTime = tz.TZDateTime.from(
      scheduledTime,
      tz.local,
    );

    // Only schedule if the time is in the future
    if (tzScheduledTime.isAfter(tz.TZDateTime.now(tz.local))) {
      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          // Removed custom sound, using default system sound
          enableVibration: true,
          playSound: true,
        ),
        iOS: DarwinNotificationDetails(
          sound: 'default',
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

      final String title = _getNotificationTitle(dayNumber);
      final String body = _getNotificationBody(dayNumber, notes);

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        notificationId,
        title,
        body,
        tzScheduledTime,
        notificationDetails,
        androidScheduleMode: await _getScheduleMode(),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'sadari_reminder_$dayNumber',
      );

      if (kDebugMode) {
        print(
          'Scheduled notification $notificationId for ${tzScheduledTime.toString()}',
        );
      }
    }
  }

  String _getNotificationTitle(int dayNumber) {
    switch (dayNumber) {
      case 7:
        return '🌸 SADARI - Hari ke-7';
      case 8:
        return '🌸 SADARI - Hari ke-8';
      case 9:
        return '🌸 SADARI - Hari ke-9';
      case 10:
        return '🌸 SADARI - Hari ke-10';
      default:
        return '🌸 Reminder SADARI';
    }
  }

  String _getNotificationBody(int dayNumber, String? notes) {
    String baseMessage =
        'Hari ini adalah waktu yang tepat untuk melakukan pemeriksaan SADARI. ';

    switch (dayNumber) {
      case 7:
        baseMessage =
            'Periode SADARI dimulai hari ini! Lakukan pemeriksaan payudara sendiri untuk kesehatan Anda. ';
        break;
      case 8:
        baseMessage =
            'Hari kedua periode SADARI. Tetap rutin melakukan pemeriksaan ya! ';
        break;
      case 9:
        baseMessage =
            'Hari ketiga periode SADARI. Jangan lewatkan pemeriksaan hari ini. ';
        break;
      case 10:
        baseMessage =
            'Hari terakhir periode SADARI. Selesaikan pemeriksaan dengan baik! ';
        break;
    }

    if (notes != null && notes.isNotEmpty) {
      baseMessage += '\n\nCatatan: $notes';
    }

    return '$baseMessage\n\nTap untuk membuka panduan SADARI.';
  }

  int _generateNotificationId(String scheduleId, int dayIndex) {
    // Generate unique notification ID based on schedule ID and day index
    return (scheduleId.hashCode + dayIndex).abs() % 2147483647;
  }

  // Cancel all notifications for a specific schedule
  Future<void> cancelScheduleNotifications(String scheduleId) async {
    try {
      for (int i = 0; i < 4; i++) {
        // 4 reminder days (7-10)
        final notificationId = _generateNotificationId(scheduleId, i);
        await _flutterLocalNotificationsPlugin.cancel(notificationId);
      }

      if (kDebugMode) {
        print('Cancelled notifications for schedule: $scheduleId');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error cancelling notifications: $e');
      }
    }
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    try {
      await _flutterLocalNotificationsPlugin.cancelAll();
      if (kDebugMode) {
        print('Cancelled all notifications');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error cancelling all notifications: $e');
      }
    }
  }

  /// Permission Management Methods
  
  // Get current permission status
  Future<Map<String, dynamic>> getPermissionStatus() async {
    try {
      final notificationStatus = await Permission.notification.status;
      final exactAlarmStatus = await Permission.scheduleExactAlarm.status;
      
      return {
        'isEnabled': notificationStatus.isGranted,
        'hasExactAlarm': exactAlarmStatus.isGranted,
        'scheduleMode': exactAlarmStatus.isGranted ? 'Tepat Waktu' : 'Perkiraan',
        'notificationPermission': notificationStatus.name,
        'exactAlarmPermission': exactAlarmStatus.name,
      };
    } catch (e) {
      if (kDebugMode) {
        print('Error getting permission status: $e');
      }
      return {
        'isEnabled': false,
        'hasExactAlarm': false,
        'scheduleMode': 'Tidak Diketahui',
        'notificationPermission': 'unknown',
        'exactAlarmPermission': 'unknown',
      };
    }
  }

  // Ensure notification permission is granted
  Future<bool> ensureNotificationPermission() async {
    try {
      final notificationStatus = await Permission.notification.status;
      
      if (notificationStatus.isGranted) {
        return true;
      }
      
      if (notificationStatus.isDenied) {
        final result = await Permission.notification.request();
        return result.isGranted;
      }
      
      if (notificationStatus.isPermanentlyDenied) {
        _showPermissionDialog();
        return false;
      }
      
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Error ensuring notification permission: $e');
      }
      return false;
    }
  }

  // Open notification settings
  Future<void> openNotificationSettings() async {
    try {
      await openAppSettings();
    } catch (e) {
      if (kDebugMode) {
        print('Error opening notification settings: $e');
      }
      Get.snackbar(
        'Error',
        'Tidak dapat membuka pengaturan',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Test notification with permission check
  Future<void> testNotificationWithPermission() async {
    final hasPermission = await ensureNotificationPermission();
    
    if (hasPermission) {
      await showTestNotification();
      Get.snackbar(
        'Test Berhasil',
        'Test notification berhasil dikirim',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'Permission Required',
        'Izin notifikasi diperlukan untuk testing',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }

  // Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    try {
      return await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting pending notifications: $e');
      }
      return [];
    }
  }

  /// Helper Methods
  
  // Get schedule mode based on exact alarm permission
  Future<AndroidScheduleMode> _getScheduleMode() async {
    try {
      final exactAlarmStatus = await Permission.scheduleExactAlarm.status;
      return exactAlarmStatus.isGranted
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexactAllowWhileIdle;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting schedule mode: $e');
      }
      return AndroidScheduleMode.inexactAllowWhileIdle;
    }
  }

  // Show permission dialog
  void _showPermissionDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Izin Notifikasi Diperlukan'),
        content: Text(
          'Aplikasi memerlukan izin notifikasi untuk mengirim pengingat SADARI. '
          'Silakan aktifkan di pengaturan aplikasi.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Nanti'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              openNotificationSettings();
            },
            child: Text('Buka Pengaturan'),
          ),
        ],
      ),
    );
  }

  // Show exact alarm explanation dialog
  Future<void> _showExactAlarmExplanationDialog() async {
    await Get.dialog(
      AlertDialog(
        title: Text('Izin Alarm Tepat Waktu'),
        content: Text(
          'Untuk memastikan pengingat SADARI dikirim tepat waktu, aplikasi memerlukan izin "Schedule exact alarms". '
          'Tanpa izin ini, pengingat mungkin tertunda.\n\n'
          'Apakah Anda ingin mengaktifkannya?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Tidak'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(),
            child: Text('Ya, Aktifkan'),
          ),
        ],
      ),
    );
  }

  /// Testing Methods for Development
  /// These methods help you test notifications without waiting for actual schedule

  // Test immediate notification (for basic functionality test)
  Future<void> showTestNotification() async {
    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      '🌸 Test SADARI Reminder',
      'Ini adalah test notification untuk reminder SADARI. Tap untuk membuka aplikasi.',
      notificationDetails,
      payload: 'test_notification',
    );
  }

  // Schedule a test notification for immediate delivery (1-2 seconds)
  Future<void> scheduleTestNotificationNow() async {
    try {
      final hasPermission = await ensureNotificationPermission();
      if (!hasPermission) {
        Get.snackbar(
          'Permission Required',
          'Notification permission is needed for testing',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      // Schedule for 2 seconds from now
      final scheduledTime = tz.TZDateTime.now(tz.local).add(Duration(seconds: 2));
      final scheduleMode = await _getScheduleMode();

      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          enableVibration: true,
          playSound: true,
        ),
        iOS: DarwinNotificationDetails(
          sound: 'default',
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        999, // Special ID for test
        '🌸 Test SADARI - Hari ke-7',
        'Test: Periode SADARI dimulai hari ini! Lakukan pemeriksaan payudara sendiri untuk kesehatan Anda.\n\nTap untuk membuka panduan SADARI.',
        scheduledTime,
        notificationDetails,
        androidScheduleMode: scheduleMode,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'test_sadari_reminder',
      );

      Get.snackbar(
        'Test Scheduled',
        'Test notification akan muncul dalam 2 detik',
        backgroundColor: Colors.blue,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );

      if (kDebugMode) {
        print('Test notification scheduled for: ${scheduledTime.toString()}');
      }
    } catch (e) {
      Get.snackbar(
        'Test Failed',
        'Error scheduling test: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      if (kDebugMode) {
        print('Error scheduling test notification: $e');
      }
    }
  }

  // Schedule test notifications for different SADARI days (for next few minutes)
  Future<void> scheduleTestSadariSequence() async {
    try {
      final hasPermission = await ensureNotificationPermission();
      if (!hasPermission) {
        Get.snackbar(
          'Permission Required',
          'Notification permission is needed for testing',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      final scheduleMode = await _getScheduleMode();
      
      // Schedule notifications for next 4 minutes (representing day 7, 8, 9, 10)
      for (int i = 0; i < 4; i++) {
        final dayNumber = i + 7; // Day 7, 8, 9, 10
        final scheduledTime = tz.TZDateTime.now(tz.local).add(Duration(minutes: i + 1));
        
        const NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            _channelName,
            channelDescription: _channelDescription,
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
            enableVibration: true,
            playSound: true,
          ),
          iOS: DarwinNotificationDetails(
            sound: 'default',
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        );

        await _flutterLocalNotificationsPlugin.zonedSchedule(
          990 + i, // Special IDs for test sequence
          _getNotificationTitle(dayNumber),
          'TEST: ${_getNotificationBody(dayNumber, 'Ini adalah test notification untuk development')}',
          scheduledTime,
          notificationDetails,
          androidScheduleMode: scheduleMode,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          payload: 'test_sadari_day_$dayNumber',
        );
      }

      Get.snackbar(
        'Test Sequence Scheduled',
        'Test notifications akan muncul dalam 1-4 menit berikutnya',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 5),
      );

      if (kDebugMode) {
        print('Test sequence scheduled for next 4 minutes');
      }
    } catch (e) {
      Get.snackbar(
        'Test Failed',
        'Error scheduling test sequence: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      if (kDebugMode) {
        print('Error scheduling test sequence: $e');
      }
    }
  }

  // Cancel all test notifications
  Future<void> cancelTestNotifications() async {
    try {
      // Cancel immediate test
      await _flutterLocalNotificationsPlugin.cancel(999);
      
      // Cancel test sequence
      for (int i = 0; i < 4; i++) {
        await _flutterLocalNotificationsPlugin.cancel(990 + i);
      }

      Get.snackbar(
        'Tests Cancelled',
        'Semua test notifications telah dibatalkan',
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error cancelling test notifications: $e');
      }
    }
  }

  // Debug: Show all pending notifications
  Future<void> showPendingNotifications() async {
    try {
      final pendingNotifications = await getPendingNotifications();
      
      if (pendingNotifications.isEmpty) {
        Get.snackbar(
          'No Pending Notifications',
          'Tidak ada notifikasi yang terjadwal',
          backgroundColor: Colors.grey,
          colorText: Colors.white,
        );
        return;
      }

      String notificationsList = 'Pending notifications:\n';
      for (var notification in pendingNotifications) {
        notificationsList += '• ID: ${notification.id} - ${notification.title}\n';
      }

      Get.dialog(
        AlertDialog(
          title: Text('Pending Notifications (${pendingNotifications.length})'),
          content: SingleChildScrollView(
            child: Text(notificationsList),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text('Tutup'),
            ),
            ElevatedButton(
              onPressed: () {
                Get.back();
                cancelAllNotifications();
              },
              child: Text('Cancel All'),
            ),
          ],
        ),
      );

      if (kDebugMode) {
        print('Pending notifications: ${pendingNotifications.length}');
        for (var notification in pendingNotifications) {
          print('- ID: ${notification.id}, Title: ${notification.title}');
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to get pending notifications: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
