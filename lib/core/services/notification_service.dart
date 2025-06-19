import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService extends GetxService {
  static const String _channelKey = 'sadari_reminder_channel';
  static const String _channelName = 'SADARI Reminder';
  static const String _channelDescription =
      'Pengingat untuk melakukan pemeriksaan SADARI';

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    await AwesomeNotifications().initialize(
      null, // Use default app icon
      [
        NotificationChannel(
          channelKey: _channelKey,
          channelName: _channelName,
          channelDescription: _channelDescription,
          defaultColor: const Color(0xFFE91E63), // Pink color for SADARI
          ledColor: Colors.white,
          importance:
              NotificationImportance.High, // Changed back to High (not Max)
          channelShowBadge: true,
          enableVibration: true,
          enableLights: true,
          playSound: true,
          criticalAlerts: false, // Changed to false for normal behavior
          defaultRingtoneType: DefaultRingtoneType.Notification,
          onlyAlertOnce: false, // Allow repeated notifications
          locked: false, // Allow user to dismiss notifications
          defaultPrivacy: NotificationPrivacy.Public, // Show on lock screen
        ),
      ],
      debug: kDebugMode,
      languageCode: 'id', // Indonesian language
    );

    // Set up listeners
    _setListeners();

    // Don't automatically request permissions on initialization
    // Permissions will be requested only when user explicitly allows them
  }

  void _setListeners() {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: _onActionReceivedMethod,
      onNotificationCreatedMethod: _onNotificationCreatedMethod,
      onNotificationDisplayedMethod: _onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: _onDismissActionReceivedMethod,
    );
  }

  @pragma("vm:entry-point")
  static Future<void> _onActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    // Handle action buttons
    if (receivedAction.buttonKeyPressed == 'MARK_DONE') {
      // User marked SADARI as done - just dismiss notification
      if (kDebugMode) {
        print('🎯 User marked SADARI as done - notification dismissed');
      }
      // Notification will be automatically dismissed
      return;
    }

    if (receivedAction.buttonKeyPressed == 'OPEN_APP') {
      // User wants to open app
      if (kDebugMode) {
        print('📱 User wants to open app from notification');
      }
      // Navigate to schedule page
      final String? payload = receivedAction.payload?['route'];
      if (payload != null) {
        Get.toNamed(payload);
      } else {
        Get.toNamed('/schedule');
      }
      return;
    }

    // Handle normal tap (tapping notification body)
    if (receivedAction.actionType == ActionType.Default) {
      final String? payload = receivedAction.payload?['route'];
      if (payload != null) {
        // Navigate to specific route
        Get.toNamed(payload);
      } else {
        // Default navigation to schedule page
        Get.toNamed('/schedule');
      }
    }

    if (kDebugMode) {
      print('🔔 Notification action received: ${receivedAction.actionType}');
      print('   📱 Button pressed: ${receivedAction.buttonKeyPressed}');
      print('   📱 Payload: ${receivedAction.payload}');
    }
  }

  @pragma("vm:entry-point")
  static Future<void> _onNotificationCreatedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    if (kDebugMode) {
      print('🔔 Notification created: ${receivedNotification.title}');
    }
  }

  @pragma("vm:entry-point")
  static Future<void> _onNotificationDisplayedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    if (kDebugMode) {
      print('🔔 Notification displayed: ${receivedNotification.title}');
    }
  }

  @pragma("vm:entry-point")
  static Future<void> _onDismissActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    if (kDebugMode) {
      print('🔔 Notification dismissed: ${receivedAction.id}');
    }
  }

  // Method untuk user secara eksplisit memberikan permission
  Future<bool> requestNotificationPermissions() async {
    try {
      bool permissionGranted = false;

      // Check if notification is already allowed
      bool isAllowed = await AwesomeNotifications().isNotificationAllowed();

      if (!isAllowed) {
        // Request basic notification permission
        permissionGranted =
            await AwesomeNotifications().requestPermissionToSendNotifications();
      } else {
        permissionGranted = true;
      }

      // If basic permission granted, request advanced permissions
      if (permissionGranted) {
        await AwesomeNotifications().requestPermissionToSendNotifications(
          channelKey: _channelKey,
          permissions: [
            NotificationPermission.Alert,
            NotificationPermission.Sound,
            NotificationPermission.Badge,
            NotificationPermission.Vibration,
            NotificationPermission.PreciseAlarms,
            NotificationPermission.CriticalAlert,
            NotificationPermission.OverrideDnD,
          ],
        );
      }

      if (kDebugMode) {
        print('🔔 Notification permission request result: $permissionGranted');
      }

      return permissionGranted;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error requesting notification permissions: $e');
      }
      return false;
    }
  }

  // Method untuk user secara eksplisit request battery optimization exemption
  Future<bool> requestBatteryOptimizationExemption() async {
    try {
      final Permission batteryOptimization =
          Permission.ignoreBatteryOptimizations;
      final PermissionStatus status = await batteryOptimization.status;

      if (status != PermissionStatus.granted) {
        final PermissionStatus result = await batteryOptimization.request();
        if (kDebugMode) {
          print('🔋 Battery optimization exemption: $result');
        }
        return result == PermissionStatus.granted;
      }

      return true; // Already granted
    } catch (e) {
      if (kDebugMode) {
        print('🔋 Error requesting battery optimization exemption: $e');
      }
      return false;
    }
  }

  Future<Map<String, dynamic>> getPermissionStatus() async {
    try {
      final isNotificationAllowed =
          await AwesomeNotifications().isNotificationAllowed();

      List<NotificationPermission> grantedPermissions = [];
      List<NotificationPermission> deniedPermissions = [];

      try {
        grantedPermissions = await AwesomeNotifications().checkPermissionList(
          channelKey: _channelKey,
          permissions: [
            NotificationPermission.Alert,
            NotificationPermission.Sound,
            NotificationPermission.Badge,
            NotificationPermission.Vibration,
            NotificationPermission.PreciseAlarms,
          ],
        );

        deniedPermissions =
            [
                  NotificationPermission.Alert,
                  NotificationPermission.Sound,
                  NotificationPermission.Badge,
                  NotificationPermission.Vibration,
                  NotificationPermission.PreciseAlarms,
                ]
                .where((permission) => !grantedPermissions.contains(permission))
                .toList();
      } catch (e) {
        if (kDebugMode) print('Error checking permissions: $e');
      }

      final hasPreciseAlarms = grantedPermissions.contains(
        NotificationPermission.PreciseAlarms,
      );

      return {
        'isEnabled': isNotificationAllowed,
        'hasExactAlarm': hasPreciseAlarms,
        'scheduleMode': hasPreciseAlarms ? 'Tepat Waktu' : 'Perkiraan',
        'grantedPermissions':
            grantedPermissions.map((p) => p.toString()).toList(),
        'deniedPermissions':
            deniedPermissions.map((p) => p.toString()).toList(),
      };
    } catch (e) {
      if (kDebugMode) print('Error getting permission status: $e');
      return {
        'isEnabled': false,
        'hasExactAlarm': false,
        'scheduleMode': 'Tidak Diketahui',
        'grantedPermissions': [],
        'deniedPermissions': [],
      };
    }
  }

  // Check notification permission status without requesting
  Future<bool> isNotificationPermissionGranted() async {
    try {
      return await AwesomeNotifications().isNotificationAllowed();
    } catch (e) {
      if (kDebugMode) print('Error checking notification permission: $e');
      return false;
    }
  }

  // Legacy method - now only requests permission when explicitly called
  Future<bool> ensureNotificationPermission() async {
    try {
      final isAllowed = await AwesomeNotifications().isNotificationAllowed();
      if (isAllowed) return true;

      // Now this only checks, doesn't auto-request
      // Permission request should be done via requestNotificationPermissions()
      return false;
    } catch (e) {
      if (kDebugMode) print('Error checking notification permission: $e');
      return false;
    }
  }

  Future<void> openNotificationSettings() async {
    try {
      await openAppSettings();
    } catch (e) {
      if (kDebugMode) print('Error opening notification settings: $e');
      Get.snackbar(
        'Error',
        'Tidak dapat membuka pengaturan',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> showTestNotification() async {
    try {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 0,
          channelKey: _channelKey,
          title: '🩺 Test SADARI Reminder',
          body:
              'Ini adalah test notification untuk reminder SADARI. Tap untuk membuka aplikasi.',
          category: NotificationCategory.Reminder,
          wakeUpScreen: true,
          payload: {'route': '/schedule', 'type': 'test'},
        ),
      );

      if (kDebugMode) print('✅ Test notification sent successfully');
    } catch (e) {
      if (kDebugMode) print('❌ Error sending test notification: $e');
      rethrow;
    }
  }

  Future<void> scheduleTestNotificationNow() async {
    try {
      final hasPermission = await isNotificationPermissionGranted();
      if (!hasPermission) {
        Get.snackbar(
          'Izin Notifikasi Diperlukan',
          'Silakan aktifkan notifikasi terlebih dahulu di pengaturan aplikasi',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
          mainButton: TextButton(
            onPressed: () async {
              Get.back(); // Close snackbar
              final granted = await requestNotificationPermissions();
              if (granted) {
                scheduleTestNotificationNow(); // Retry after permission granted
              }
            },
            child: const Text(
              'Aktifkan',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
        return;
      }

      final scheduledTime = DateTime.now().add(const Duration(seconds: 2));
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 999,
          channelKey: _channelKey,
          title: '🩺 Test SADARI - Hari ke-7',
          body:
              'Test: Periode SADARI dimulai hari ini! Lakukan pemeriksaan payudara sendiri untuk kesehatan Anda.\n\nTap untuk membuka panduan SADARI.',
          category: NotificationCategory.Reminder,
          wakeUpScreen: false, // Don't force wake
          fullScreenIntent: false, // Don't force full screen
          criticalAlert: false, // Normal notification
          autoDismissible: true, // Allow dismiss
          showWhen: true,
          payload: {'route': '/schedule', 'type': 'test_scheduled'},
          locked: false, // Allow swipe to dismiss
          displayOnForeground: true,
          displayOnBackground: true,
        ),
        schedule: NotificationCalendar.fromDate(
          date: scheduledTime,
          preciseAlarm: true,
          allowWhileIdle: true,
        ),
      );

      Get.snackbar(
        'Test Scheduled',
        'Test notification akan muncul dalam 2 detik',
        backgroundColor: Colors.blue,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      if (kDebugMode)
        print('✅ Test notification scheduled for: ${scheduledTime.toString()}');
    } catch (e) {
      Get.snackbar(
        'Test Failed',
        'Error scheduling test: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      if (kDebugMode) print('❌ Error scheduling test notification: $e');
    }
  }

  Future<void> scheduleTestSadariSequence() async {
    try {
      final hasPermission = await isNotificationPermissionGranted();
      if (!hasPermission) {
        Get.snackbar(
          'Izin Notifikasi Diperlukan',
          'Silakan aktifkan notifikasi terlebih dahulu untuk testing',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
          mainButton: TextButton(
            onPressed: () async {
              Get.back(); // Close snackbar
              final granted = await requestNotificationPermissions();
              if (granted) {
                scheduleTestSadariSequence(); // Retry after permission granted
              }
            },
            child: const Text(
              'Aktifkan',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
        return;
      }

      for (int i = 0; i < 4; i++) {
        final dayNumber = i + 7;
        final scheduledTime = DateTime.now().add(Duration(minutes: i + 1));
        await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: 990 + i,
            channelKey: _channelKey,
            title: '🩺 SADARI - Hari ke-$dayNumber',
            body:
                'TEST: Periode SADARI hari ke-$dayNumber! Lakukan pemeriksaan payudara sendiri untuk kesehatan Anda.',
            category: NotificationCategory.Reminder,
            wakeUpScreen: false,
            fullScreenIntent: false,
            criticalAlert: false,
            autoDismissible: true,
            showWhen: true,
            payload: {
              'route': '/schedule',
              'type': 'test_sequence',
              'day': dayNumber.toString(),
            },
            locked: false,
            displayOnForeground: true,
            displayOnBackground: true,
          ),
          schedule: NotificationCalendar.fromDate(
            date: scheduledTime,
            preciseAlarm: true,
            allowWhileIdle: true,
          ),
        );
      }

      Get.snackbar(
        'Test Sequence Scheduled',
        'Test notifications akan muncul dalam 1-4 menit berikutnya',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );

      if (kDebugMode) print('✅ Test sequence scheduled for next 4 minutes');
    } catch (e) {
      Get.snackbar(
        'Test Failed',
        'Error scheduling test sequence: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      if (kDebugMode) print('❌ Error scheduling test sequence: $e');
    }
  }

  Future<void> cancelTestNotifications() async {
    try {
      await AwesomeNotifications().cancel(999);
      for (int i = 0; i < 4; i++) {
        await AwesomeNotifications().cancel(990 + i);
      }

      Get.snackbar(
        'Tests Cancelled',
        'Semua test notifications telah dibatalkan',
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );

      if (kDebugMode) print('✅ All test notifications cancelled');
    } catch (e) {
      if (kDebugMode) print('❌ Error cancelling test notifications: $e');
    }
  }

  Future<List<NotificationModel>> getPendingNotifications() async {
    try {
      return await AwesomeNotifications().listScheduledNotifications();
    } catch (e) {
      if (kDebugMode) print('❌ Error getting pending notifications: $e');
      return [];
    }
  }

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
        notificationsList +=
            '• ID: ${notification.content?.id} - ${notification.content?.title}\n';
        if (notification.content?.payload != null) {
          notificationsList += '  Payload: ${notification.content?.payload}\n';
        }
      }

      Get.dialog(
        AlertDialog(
          title: Text('Pending Notifications (${pendingNotifications.length})'),
          content: SingleChildScrollView(child: Text(notificationsList)),
          actions: [
            TextButton(onPressed: () => Get.back(), child: const Text('Tutup')),
            ElevatedButton(
              onPressed: () {
                Get.back();
                cancelAllNotifications();
              },
              child: const Text('Cancel All'),
            ),
          ],
        ),
      );

      if (kDebugMode) {
        print('📋 Pending notifications: ${pendingNotifications.length}');
        for (var notification in pendingNotifications) {
          print(
            '   • ID: ${notification.content?.id}, Title: ${notification.content?.title}',
          );
          if (notification.content?.payload != null) {
            print('     Payload: ${notification.content?.payload}');
          }
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

  Future<void> scheduleSadariReminders({
    required String scheduleId,
    required List<DateTime> reminderDates,
    String? notes,
  }) async {
    try {
      if (kDebugMode)
        print(
          '🔔 Starting to schedule SADARI reminders for $scheduleId with ${reminderDates.length} dates',
        ); // Pastikan permission sudah ada
      final hasPermission = await isNotificationPermissionGranted();
      if (!hasPermission) {
        if (kDebugMode)
          print('❌ No notification permission - showing user-friendly message');

        Get.snackbar(
          'Izin Notifikasi Diperlukan',
          'Untuk menjadwalkan pengingat SADARI, aplikasi memerlukan izin notifikasi',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
          mainButton: TextButton(
            onPressed: () async {
              Get.back(); // Close snackbar
              await requestNotificationPermissions();
            },
            child: const Text(
              'Berikan Izin',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );

        throw Exception('Notification permission required');
      }

      // Cancel notifikasi lama untuk schedule ini
      await cancelScheduleNotifications(scheduleId);

      for (int i = 0; i < reminderDates.length; i++) {
        final reminderDate = reminderDates[i];
        final dayNumber = i + 7; // Hari ke-7, 8, 9, 10
        final notificationId = _generateNotificationId(scheduleId, i);

        final now = DateTime.now();

        if (kDebugMode) {
          print('⏰ Scheduling notification $notificationId for day $dayNumber');
          print('   📅 Scheduled time: ${reminderDate.toString()}');
          print('   🕐 Current time: ${now.toString()}');
          print(
            '   ⏱️ Time difference: ${reminderDate.difference(now).inMinutes} minutes',
          );
        }

        // Skip jika waktu sudah lewat
        if (reminderDate.isBefore(now)) {
          if (kDebugMode) {
            print('   ⚠️ Skipping past date: ${reminderDate.toString()}');
          }
          continue;
        }

        final title = '🩺 SADARI - Hari ke-$dayNumber';
        final body =
            'Periode SADARI hari ke-$dayNumber! Lakukan pemeriksaan payudara sendiri untuk kesehatan Anda.\n\nTap untuk membuka panduan SADARI.${notes != null ? '\n\nCatatan: $notes' : ''}';
        final payload = {
          'route': '/schedule',
          'type': 'sadari_reminder',
          'scheduleId': scheduleId,
          'day': dayNumber.toString(),
        };
        try {
          await AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: notificationId,
              channelKey: _channelKey,
              title: title,
              body: body,
              category: NotificationCategory.Reminder,
              wakeUpScreen: false, // Don't force wake screen
              fullScreenIntent: false, // Don't force full screen
              criticalAlert: false, // Normal notification
              autoDismissible: true, // Allow auto dismiss
              showWhen: true, // Show time
              payload: payload,
              locked: false, // Allow swipe dismissal
              displayOnForeground: true, // Show when app is open
              displayOnBackground: true, // Show when app is closed
            ),
            schedule: NotificationCalendar.fromDate(
              date: reminderDate,
              preciseAlarm: true, // Use precise alarm for exact timing
              allowWhileIdle: true, // Allow while device is idle
            ),
            actionButtons: [
              NotificationActionButton(
                key: 'MARK_DONE',
                label: 'Selesai',
                actionType:
                    ActionType.DismissAction, // Dismiss the notification
              ),
              NotificationActionButton(
                key: 'OPEN_APP',
                label: 'Buka App',
                actionType: ActionType.Default,
              ),
            ],
          );

          if (kDebugMode)
            print('   ✅ Successfully scheduled notification $notificationId');
        } catch (e) {
          if (kDebugMode)
            print('   ❌ Failed to schedule notification $notificationId: $e');
          rethrow;
        }
      }

      // Verifikasi berapa notification yang berhasil dijadwalkan
      final pendingNotifications = await getPendingNotifications();
      final scheduleNotifications =
          pendingNotifications
              .where((n) => n.content?.payload?['scheduleId'] == scheduleId)
              .toList();

      if (kDebugMode) {
        print('🎯 Schedule completed for $scheduleId');
        print(
          '   📊 Total pending notifications: ${pendingNotifications.length}',
        );
        print(
          '   📋 Notifications for this schedule: ${scheduleNotifications.length}',
        );
        for (var notification in scheduleNotifications) {
          print(
            '     • ID: ${notification.content?.id} - ${notification.content?.title}',
          );
        }
      }
    } catch (e) {
      if (kDebugMode) print('💥 Error scheduling SADARI reminders: $e');
      rethrow;
    }
  }

  int _generateNotificationId(String scheduleId, int index) {
    // Generate unique ID berdasarkan schedule ID dan index
    final baseId = scheduleId.hashCode.abs() % 100000;
    return baseId +
        index +
        1000; // Offset untuk avoid conflict dengan test notifications
  }

  Future<void> cancelScheduleNotifications(String scheduleId) async {
    try {
      if (kDebugMode)
        print('🗑️ Cancelling notifications for schedule: $scheduleId');

      final pendingNotifications = await getPendingNotifications();
      final scheduleNotifications =
          pendingNotifications
              .where((n) => n.content?.payload?['scheduleId'] == scheduleId)
              .toList();

      if (kDebugMode)
        print(
          '   📋 Found ${scheduleNotifications.length} notifications to cancel',
        );

      for (var notification in scheduleNotifications) {
        await AwesomeNotifications().cancel(notification.content?.id ?? 0);
        if (kDebugMode)
          print('   ✅ Cancelled notification ID: ${notification.content?.id}');
      }

      if (kDebugMode)
        print('🎯 Schedule cancellation completed for $scheduleId');
    } catch (e) {
      if (kDebugMode)
        print('💥 Error cancelling notifications for schedule $scheduleId: $e');
    }
  }

  Future<void> cancelAllNotifications() async {
    try {
      await AwesomeNotifications().cancelAll();
      if (kDebugMode) print('🗑️ Cancelled all notifications');
    } catch (e) {
      if (kDebugMode) print('💥 Error cancelling all notifications: $e');
    }
  }

  /// Debug method untuk verifikasi sistem notifikasi
  Future<void> debugNotificationSystem() async {
    if (kDebugMode) {
      print('🔍 ==> DEBUGGING AWESOME NOTIFICATION SYSTEM <==');

      // 1. Cek permission status
      final permissionStatus = await getPermissionStatus();
      print('📱 Permission Status:');
      print('   • Notification Allowed: ${permissionStatus['isEnabled']}');
      print('   • Precise Alarms: ${permissionStatus['hasExactAlarm']}');
      print('   • Schedule Mode: ${permissionStatus['scheduleMode']}');
      print('   • Granted: ${permissionStatus['grantedPermissions']}');
      print('   • Denied: ${permissionStatus['deniedPermissions']}');

      // 2. Cek timezone
      final now = DateTime.now();
      print('🌍 Timezone Info:');
      print('   • Current Time: ${now.toString()}');
      print('   • UTC Offset: ${now.timeZoneOffset}');

      // 3. Cek pending notifications
      final pending = await getPendingNotifications();
      print('📋 Pending Notifications: ${pending.length}');
      for (var notification in pending) {
        print(
          '   • ID: ${notification.content?.id} - ${notification.content?.title}',
        );
      }

      // 4. Test immediate notification
      print('🧪 Testing immediate notification...');
      try {
        await showTestNotification();
        print('   ✅ Immediate notification sent successfully');
      } catch (e) {
        print('   ❌ Immediate notification failed: $e');
      }

      // 5. Test scheduled notification (5 seconds)
      print('🧪 Testing scheduled notification (5 seconds)...');
      try {
        final testTime = DateTime.now().add(const Duration(seconds: 5));

        await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: 9999,
            channelKey: _channelKey,
            title: '🔬 Debug Test',
            body: 'Debug scheduled notification - should appear in 5 seconds',
            category: NotificationCategory.Reminder,
            wakeUpScreen: true,
            payload: {'route': '/schedule', 'type': 'debug_test'},
          ),
          schedule: NotificationCalendar.fromDate(date: testTime),
        );

        print('   ✅ Scheduled notification set for: ${testTime.toString()}');

        // Verify it's in pending list
        final pendingAfter = await getPendingNotifications();
        final debugNotification =
            pendingAfter.where((n) => n.content?.id == 9999).toList();
        print('   📋 Found in pending list: ${debugNotification.isNotEmpty}');
      } catch (e) {
        print('   ❌ Scheduled notification failed: $e');
      }

      print('🔍 ==> DEBUG COMPLETE <==');
    }
  }

  /// Method untuk membantu troubleshooting notifikasi background
  Future<void> checkBackgroundNotificationSetup() async {
    if (kDebugMode) {
      print('🔍 ==> CHECKING BACKGROUND NOTIFICATION SETUP <==');

      // 1. Check if app is allowed to run in background
      try {
        final isIgnoringBatteryOptimizations =
            await Permission.ignoreBatteryOptimizations.status;
        print('🔋 Battery Optimization: $isIgnoringBatteryOptimizations');
        if (isIgnoringBatteryOptimizations != PermissionStatus.granted) {
          print('⚠️ App may be killed by battery optimization!');
          print('   Requesting battery optimization exemption...');
          await requestBatteryOptimizationExemption();
        }
      } catch (e) {
        print('❌ Error checking battery optimization: $e');
      }

      // 2. Check notification channel settings
      try {
        final isAllowed = await AwesomeNotifications().isNotificationAllowed();
        print('📱 Notification Permission: $isAllowed');

        final channels =
            await AwesomeNotifications().listScheduledNotifications();
        print('📋 Scheduled Notifications: ${channels.length}');

        for (var notification in channels) {
          print(
            '   • ID: ${notification.content?.id} - ${notification.content?.title}',
          );
          if (notification.schedule != null) {
            print('     ⏰ Schedule: ${notification.schedule.toString()}');
          }
        }
      } catch (e) {
        print('❌ Error checking notifications: $e');
      }

      // 3. Test immediate notification
      print('🧪 Testing immediate notification...');
      try {
        await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: 99999,
            channelKey: _channelKey,
            title: '🔧 Background Test',
            body:
                'If you see this, immediate notifications work! Check for scheduled ones next.',
            category: NotificationCategory.Status,
            wakeUpScreen: true,
            criticalAlert: true,
          ),
        );
        print('✅ Immediate notification sent');
      } catch (e) {
        print('❌ Immediate notification failed: $e');
      }

      // 4. Test scheduled notification (30 seconds from now)
      print('⏰ Testing scheduled notification...');
      try {
        final testTime = DateTime.now().add(const Duration(seconds: 30));
        await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: 99998,
            channelKey: _channelKey,
            title: '⏰ Background Schedule Test',
            body:
                'This tests if scheduled notifications work when app is closed. Close the app now!',
            category: NotificationCategory.Status,
            wakeUpScreen: true,
            fullScreenIntent: true,
            criticalAlert: true,
          ),
          schedule: NotificationCalendar.fromDate(
            date: testTime,
            preciseAlarm: true,
            allowWhileIdle: true,
          ),
        );
        print('✅ Scheduled notification set for: $testTime');
        print('🔥 CLOSE THE APP NOW to test background delivery!');
      } catch (e) {
        print('❌ Scheduled notification failed: $e');
      }
    }
  }

  /// Method untuk menampilkan tips troubleshooting kepada user
  Future<void> showBackgroundNotificationTips() async {
    Get.dialog(
      AlertDialog(
        title: const Text('🔧 Tips Notifikasi Background'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Jika notifikasi tidak muncul saat aplikasi tertutup:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text('📱 1. Buka Settings > Apps > My SADARI'),
              Text('🔋 2. Pilih "Battery" > Unrestricted'),
              Text('🔔 3. Pilih "Notifications" > Allow all'),
              Text('⏰ 4. Enable "Schedule exact alarms"'),
              Text('🚫 5. Disable "Remove permissions if app unused"'),
              SizedBox(height: 10),
              Text(
                'Untuk beberapa brand HP:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('• Xiaomi: Security > Permissions > Autostart'),
              Text('• Huawei: Settings > App launch > Manual manage'),
              Text(
                '• Samsung: Settings > Device care > Battery > App power management',
              ),
              Text('• Oppo/OnePlus: Settings > Battery > Battery optimization'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Mengerti'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              checkBackgroundNotificationSetup();
            },
            child: const Text('Test Sekarang'),
          ),
        ],
      ),
    );
  }
}
