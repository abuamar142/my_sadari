import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/notification_service.dart';
import '../../../../core/services/schedule_service.dart';
import '../../../data/models/sadari_schedule.dart';
import '../../../routes/app_pages.dart';
import '../../../styles/app_colors.dart';
import '../../../widgets/app_dialog.dart';
import '../../../widgets/app_snackbar.dart';

class ScheduleController extends GetxController {
  final ScheduleService _scheduleService = Get.find<ScheduleService>();
  final NotificationService _notificationService =
      Get.find<NotificationService>();

  // Form controllers
  final TextEditingController notesController = TextEditingController();

  // Observable variables
  final Rx<DateTime> selectedMenstruationDate = DateTime.now().obs;
  final RxBool isLoading = false.obs;
  final RxString selectedView = 'calendar'.obs; // 'calendar' or 'list'
  final RxMap<String, dynamic> notificationStatus = <String, dynamic>{}.obs;

  // Filter variables
  final RxInt selectedYear = DateTime.now().year.obs;
  final RxInt selectedMonth = DateTime.now().month.obs;

  // Getters
  List<Schedule> get schedules => _scheduleService.schedules;
  Schedule? get activeSchedule => _scheduleService.activeSchedule;
  bool get isTodayReminderDay => _scheduleService.isTodayReminderDay;
  Map<String, dynamic>? get nextReminderInfo =>
      _scheduleService.nextReminderInfo;

  // Filtered schedules by month and year
  List<Schedule> get filteredSchedules {
    return schedules.where((schedule) {
        final scheduleDate = schedule.menstruationStartDate;
        return scheduleDate.year == selectedYear.value &&
            scheduleDate.month == selectedMonth.value;
      }).toList()
      ..sort(
        (a, b) => b.menstruationStartDate.compareTo(a.menstruationStartDate),
      );
  }

  // Get available years from schedules
  List<int> get availableYears {
    if (schedules.isEmpty) return [DateTime.now().year];

    final years =
        schedules.map((s) => s.menstruationStartDate.year).toSet().toList()
          ..sort((a, b) => b.compareTo(a));

    return years;
  }

  // Get available months for selected year
  List<int> get availableMonths {
    if (schedules.isEmpty) return [DateTime.now().month];

    final months =
        schedules
            .where((s) => s.menstruationStartDate.year == selectedYear.value)
            .map((s) => s.menstruationStartDate.month)
            .toSet()
            .toList()
          ..sort((a, b) => b.compareTo(a));

    return months.isEmpty ? [DateTime.now().month] : months;
  }

  @override
  void onInit() {
    super.onInit();
    _scheduleService.loadSchedules();
    _loadNotificationStatus();
  }

  @override
  void onClose() {
    notesController.dispose();
    super.onClose();
  }

  // Load notification permission status
  Future<void> _loadNotificationStatus() async {
    notificationStatus.value = await _notificationService.getPermissionStatus();
  }

  // Check notification permission status without requesting
  Future<void> checkNotificationPermissionStatus() async {
    final hasPermission =
        await _notificationService.isNotificationPermissionGranted();
    await _loadNotificationStatus();

    if (kDebugMode) {
      print('🔔 Notification permission status: $hasPermission');
    }
  }

  // Request notification permission when user explicitly wants it
  Future<void> requestNotificationPermissions() async {
    try {
      final granted =
          await _notificationService.requestNotificationPermissions();
      await _loadNotificationStatus();

      if (granted) {
        AppSnackbar.success(
          title: 'Izin Diberikan',
          message: 'Notifikasi berhasil diaktifkan untuk pengingat SADARI',
        );
      } else {
        AppSnackbar.action(
          title: 'Izin Ditolak',
          message:
              'Silakan aktifkan notifikasi di pengaturan aplikasi untuk mendapatkan pengingat SADARI',
          actionLabel: 'Pengaturan',
          onAction: () => _notificationService.openNotificationSettings(),
          backgroundColor: AppColors.red,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error requesting notification permission: $e');
      }
      AppSnackbar.error(
        title: 'Error',
        message: 'Terjadi kesalahan saat meminta izin notifikasi',
      );
    }
  }

  // Legacy method - now just checks status
  Future<void> checkNotificationPermission() async {
    final hasPermission =
        await _notificationService.isNotificationPermissionGranted();
    await _loadNotificationStatus();

    if (!hasPermission) {
      AppSnackbar.action(
        title: 'Izin Notifikasi',
        message: 'Notifikasi perlu diaktifkan untuk pengingat SADARI',
        actionLabel: 'Buka Pengaturan',
        onAction: () {
          _notificationService.openNotificationSettings();
        },
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 4),
      );
    }
  }

  // Test notification
  Future<void> testNotification() async {
    await _notificationService.showTestNotification();
    await _loadNotificationStatus();
  }

  // Select menstruation date
  Future<void> selectMenstruationDate() async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: selectedMenstruationDate.value,
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now().add(Duration(days: 365)),
      helpText: 'Pilih Tanggal Awal Menstruasi',
      cancelText: 'Batal',
      confirmText: 'Pilih',
    );

    if (picked != null) {
      selectedMenstruationDate.value = picked;
    }
  }

  // Add new schedule
  Future<void> addSchedule() async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;

      final success = await _scheduleService.addSchedule(
        menstruationStartDate: selectedMenstruationDate.value,
        notes:
            notesController.text.trim().isEmpty
                ? null
                : notesController.text.trim(),
      );

      if (success) {
        // Reset form
        selectedMenstruationDate.value = DateTime.now();
        notesController.clear();

        Navigator.of(Get.context!).pop();
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Delete schedule
  Future<void> deleteSchedule(String scheduleId) async {
    final confirmed = await Get.dialog<bool>(
      AppDialog(
        title: 'Hapus Jadwal',
        headerIcon: Icons.delete_outline,
        headerColor: AppColors.red,
        headerSecondaryColor: AppColors.pink,
        content: 'Apakah Anda yakin ingin menghapus jadwal ini?',
        actions: [
          DialogAction(
            label: 'Batal',
            type: DialogActionType.secondary,
            onPressed: () => Get.back(result: false),
          ),
          DialogAction(
            label: 'Hapus',
            type: DialogActionType.primary,
            color: AppColors.red,
            icon: Icons.delete,
            onPressed: () => Get.back(result: true),
          ),
        ],
        barrierDismissible: false,
      ),
    );

    if (confirmed == true) {
      await _scheduleService.deleteSchedule(scheduleId);
    }
  }

  // Toggle schedule active status
  Future<void> toggleScheduleStatus(Schedule schedule) async {
    final updatedSchedule = schedule.copyWith(isActive: !schedule.isActive);
    await _scheduleService.updateSchedule(updatedSchedule);
  }

  // Get schedules for specific month
  List<Schedule> getSchedulesForMonth(DateTime month) {
    return _scheduleService.getSchedulesForMonth(month);
  }

  // Show add schedule bottom sheet
  void showAddScheduleBottomSheet() {
    // Reset form
    selectedMenstruationDate.value = DateTime.now();
    notesController.clear();

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Get.theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 20),

            Text(
              'Tambah Jadwal SADARI',
              style: Get.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),

            // Date picker
            Text('Tanggal Awal Menstruasi', style: Get.textTheme.titleMedium),
            SizedBox(height: 8),
            Obx(
              () => InkWell(
                onTap: selectMenstruationDate,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.grey[600]),
                      SizedBox(width: 12),
                      Text(
                        '${selectedMenstruationDate.value.day}/${selectedMenstruationDate.value.month}/${selectedMenstruationDate.value.year}',
                        style: Get.textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Notes
            Text('Catatan (Opsional)', style: Get.textTheme.titleMedium),
            SizedBox(height: 8),
            TextField(
              controller: notesController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Tambahkan catatan...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 24),

            // Info
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Get.theme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Get.theme.primaryColor),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Reminder SADARI akan diatur pada hari ke-7 sampai ke-10 setelah hari awal menstruasi.',
                      style: Get.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    child: Text('Batal'),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Obx(
                    () => ElevatedButton(
                      onPressed: isLoading.value ? null : addSchedule,
                      child:
                          isLoading.value
                              ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                              : Text('Simpan'),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(Get.context!).viewInsets.bottom),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  } // Calculate sadari window info

  Map<String, dynamic> getSadariWindowInfo(Schedule schedule) {
    return {
      'isInWindow': schedule.isInSadariWindow,
      'daysUntilStart': schedule.daysUntilSadari,
      'windowDays':
          '${schedule.sadariStartDate.day}/${schedule.sadariStartDate.month} - ${schedule.sadariEndDate.day}/${schedule.sadariEndDate.month}',
      'reminderDates': schedule.reminderDates,
    };
  }

  // Format date for display
  String formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agt',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  // Get status text for schedule
  String getScheduleStatusText(Schedule schedule) {
    if (!schedule.isActive) return 'Nonaktif';

    if (schedule.isInSadariWindow) {
      return 'Waktunya SADARI';
    }

    final daysUntil = schedule.daysUntilSadari;
    if (daysUntil > 0) {
      return '$daysUntil hari lagi';
    }

    return 'Selesai';
  }

  // Get status color for schedule
  Color getScheduleStatusColor(Schedule schedule) {
    if (!schedule.isActive) return Colors.grey;

    if (schedule.isInSadariWindow) {
      return Colors.green;
    }

    final daysUntil = schedule.daysUntilSadari;
    if (daysUntil > 0) {
      return Colors.orange;
    }

    return Colors.grey;
  }

  /// Testing Methods for Notifications
  /// These methods provide UI access to test notification functionality

  // Show immediate test notification
  Future<void> showTestNotification() async {
    await _notificationService.showTestNotification();
  }

  // Schedule test notification for 2 seconds from now
  Future<void> scheduleTestNotificationNow() async {
    await _notificationService.scheduleTestNotificationNow();
  }

  // Schedule test SADARI sequence (1-4 minutes)
  Future<void> scheduleTestSadariSequence() async {
    await _notificationService.scheduleTestSadariSequence();
  }

  // Cancel all test notifications
  Future<void> cancelTestNotifications() async {
    await _notificationService.cancelTestNotifications();
  }

  // Show all pending notifications
  Future<void> showPendingNotifications() async {
    await _notificationService.showPendingNotifications();
  }

  // Debug notification system
  Future<void> debugNotificationSystem() async {
    await _notificationService.debugNotificationSystem();
  }

  // Debug methods for testing notifications
  Future<void> checkBackgroundSetup() async {
    await _notificationService.checkBackgroundNotificationSetup();
  }

  Future<void> showBackgroundTips() async {
    await _notificationService.showBackgroundNotificationTips();
  }

  // Show test notification bottom sheet
  void showTestNotificationBottomSheet() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Test Notifikasi SADARI',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Gunakan fitur ini untuk menguji notifikasi tanpa menunggu jadwal sebenarnya',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            SizedBox(height: 20),

            // Test buttons
            _buildTestButton(
              'Test Langsung',
              'Tampilkan notifikasi sekarang',
              Icons.notifications_active,
              Colors.blue,
              showTestNotification,
            ),
            SizedBox(height: 12),
            _buildTestButton(
              'Test Terjadwal (2 detik)',
              'Notifikasi muncul dalam 2 detik',
              Icons.schedule,
              Colors.orange,
              scheduleTestNotificationNow,
            ),
            SizedBox(height: 12),
            _buildTestButton(
              'Test Sequence SADARI',
              'Simulasi hari 7-10 (1-4 menit)',
              Icons.view_week,
              Colors.green,
              scheduleTestSadariSequence,
            ),
            SizedBox(height: 12),
            _buildTestButton(
              'Lihat Notifikasi Pending',
              'Tampilkan daftar notifikasi terjadwal',
              Icons.list,
              Colors.purple,
              showPendingNotifications,
            ),
            SizedBox(height: 12),
            _buildTestButton(
              'Debug Sistem Notifikasi',
              'Analisis mendalam sistem notifikasi',
              Icons.bug_report,
              Colors.red,
              debugNotificationSystem,
            ),
            SizedBox(height: 12),
            _buildTestButton(
              'Batalkan Test',
              'Batalkan semua test notifications',
              Icons.cancel,
              Colors.red,
              cancelTestNotifications,
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildTestButton(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: color.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  // Navigate to tutorial
  Future<void> navigateToTutorial() async {
    try {
      await Get.toNamed(Routes.tutorial, arguments: {'fromSchedule': true});
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error in navigateToTutorial: $e');
      }
    }
  }

  // Navigate to screening
  Future<void> navigateToScreening() async {
    try {
      await Get.toNamed(Routes.screening, arguments: {'fromSchedule': true});
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error in navigateToScreening: $e');
      }
    }
  }

  // Filter methods
  void updateSelectedYear(int year) {
    selectedYear.value = year;
    // Update month to the first available month for this year
    final months = availableMonths;
    if (months.isNotEmpty && !months.contains(selectedMonth.value)) {
      selectedMonth.value = months.first;
    }
  }

  void updateSelectedMonth(int month) {
    selectedMonth.value = month;
  }

  // Get month name
  String getMonthName(int month) {
    const monthNames = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return monthNames[month - 1];
  }

  // Get result text and color
  Map<String, dynamic> getResultInfo(String? result) {
    if (result == null) {
      return {
        'text': 'Belum ada hasil',
        'color': Colors.grey,
        'icon': Icons.help_outline,
      };
    } else if (result == 'normal') {
      return {
        'text': 'Tidak ditemukan adanya ketidaknormalan pada payudara',
        'color': Colors.green,
        'icon': Icons.check_circle,
      };
    } else {
      return {
        'text': 'Ditemukan adanya ketidaknormalan pada payudara',
        'color': Colors.red,
        'icon': Icons.warning,
      };
    }
  }
}
