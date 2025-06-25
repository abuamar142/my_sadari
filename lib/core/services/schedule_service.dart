import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../app/data/models/sadari_schedule.dart';
import 'notification_service.dart';

class ScheduleService extends GetxService {
  final GetStorage _storage = GetStorage();
  final NotificationService _notificationService =
      Get.find<NotificationService>();
  static const String _storageKey = 'sadari_schedules';

  final RxList<Schedule> _schedules = <Schedule>[].obs;
  List<Schedule> get schedules => _schedules.toList();

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    loadSchedules();
  }

  // Load schedules from storage
  void loadSchedules() {
    try {
      _isLoading.value = true;
      final schedulesData = _storage.read(_storageKey);

      if (schedulesData != null) {
        final List<dynamic> schedulesList = jsonDecode(schedulesData);
        _schedules.value =
            schedulesList.map((json) => Schedule.fromJson(json)).toList();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat jadwal: $e',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  // Save schedules to storage
  Future<void> _saveSchedules() async {
    try {
      final schedulesJson =
          _schedules.map((schedule) => schedule.toJson()).toList();
      await _storage.write(_storageKey, jsonEncode(schedulesJson));
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menyimpan jadwal: $e',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  // Add new schedule
  Future<bool> addSchedule({
    required DateTime menstruationStartDate,
    String? notes,
  }) async {
    try {
      _isLoading.value = true;

      final newSchedule = Schedule.fromMenstruationDate(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        menstruationStartDate: menstruationStartDate,
        notes: notes,
      );

      _schedules.add(newSchedule);
      await _saveSchedules();

      // Schedule notifications
      await _scheduleNotifications(newSchedule);

      Get.snackbar(
        'Berhasil',
        'Jadwal SADARI berhasil ditambahkan!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.primaryColor,
        colorText: Get.theme.colorScheme.onPrimary,
      );

      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menambahkan jadwal: $e',
        snackPosition: SnackPosition.TOP,
      );
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  // Update schedule
  Future<bool> updateSchedule(Schedule updatedSchedule) async {
    try {
      _isLoading.value = true;

      final index = _schedules.indexWhere(
        (schedule) => schedule.id == updatedSchedule.id,
      );
      if (index != -1) {
        _schedules[index] = updatedSchedule;
        await _saveSchedules();

        // Reschedule notifications
        await _scheduleNotifications(updatedSchedule);

        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mengupdate jadwal: $e',
        snackPosition: SnackPosition.TOP,
      );
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  // Delete schedule
  Future<bool> deleteSchedule(String scheduleId) async {
    try {
      _isLoading.value = true;

      _schedules.removeWhere((schedule) => schedule.id == scheduleId);
      await _saveSchedules();

      // Cancel notifications for this schedule
      await _cancelNotifications(scheduleId);

      Get.snackbar(
        'Berhasil',
        'Jadwal berhasil dihapus',
        snackPosition: SnackPosition.TOP,
      );

      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menghapus jadwal: $e',
        snackPosition: SnackPosition.TOP,
      );
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  // Get active schedule (current or next)
  Schedule? get activeSchedule {
    final now = DateTime.now();

    // Find schedule that is currently in sadari window
    for (final schedule in _schedules) {
      if (schedule.isActive && schedule.isInSadariWindow) {
        return schedule;
      }
    }

    // If no current schedule, find the next upcoming one
    final upcomingSchedules =
        _schedules
            .where(
              (schedule) =>
                  schedule.isActive && schedule.sadariStartDate.isAfter(now),
            )
            .toList()
          ..sort((a, b) => a.sadariStartDate.compareTo(b.sadariStartDate));

    return upcomingSchedules.isNotEmpty ? upcomingSchedules.first : null;
  }

  // Get schedules for current month
  List<Schedule> getSchedulesForMonth(DateTime month) {
    return _schedules.where((schedule) {
      return schedule.sadariStartDate.year == month.year &&
          schedule.sadariStartDate.month == month.month;
    }).toList();
  }

  // Schedule local notifications
  Future<void> _scheduleNotifications(Schedule schedule) async {
    try {
      await _notificationService.scheduleSadariReminders(
        scheduleId: schedule.id,
        reminderDates: schedule.reminderDates,
        notes: schedule.notes,
      );

      if (kDebugMode) {
        print(
          'Successfully scheduled notifications for schedule: ${schedule.id}',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error scheduling notifications: $e');
      }
    }
  }

  // Cancel notifications for a schedule
  Future<void> _cancelNotifications(String scheduleId) async {
    try {
      await _notificationService.cancelScheduleNotifications(scheduleId);

      if (kDebugMode) {
        print('Successfully cancelled notifications for schedule: $scheduleId');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error cancelling notifications: $e');
      }
    }
  }

  // Get next reminder info
  Map<String, dynamic>? get nextReminderInfo {
    final activeSchedule = this.activeSchedule;
    if (activeSchedule == null) return null;

    final nextReminder = activeSchedule.nextReminderDate;
    if (nextReminder == null) return null;

    final now = DateTime.now();
    final difference = nextReminder.difference(now);

    return {
      'date': nextReminder,
      'daysUntil': difference.inDays,
      'hoursUntil': difference.inHours,
      'schedule': activeSchedule,
    };
  }

  // Check if today is a reminder day
  bool get isTodayReminderDay {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    for (final schedule in _schedules) {
      if (!schedule.isActive) continue;

      for (final reminderDate in schedule.reminderDates) {
        final reminderDay = DateTime(
          reminderDate.year,
          reminderDate.month,
          reminderDate.day,
        );

        if (today.isAtSameMomentAs(reminderDay)) {
          return true;
        }
      }
    }

    return false;
  }

  // Mark SADARI as completed for the active schedule
  Future<bool> markSadariCompleted() async {
    try {
      final active = activeSchedule;
      if (active == null) {
        if (kDebugMode) {
          print('❌ No active schedule found to mark as completed');
        }
        return false;
      }

      // Check if already completed
      if (active.isCompleted) {
        if (kDebugMode) {
          print('⚠️ SADARI already completed for this period');
        }
        return false;
      }

      // Update the schedule with completion time
      final updatedSchedule = active.copyWith(completedAt: DateTime.now());

      // Update in the list
      final index = _schedules.indexWhere((s) => s.id == active.id);
      if (index != -1) {
        _schedules[index] = updatedSchedule;
        await _saveSchedules();

        if (kDebugMode) {
          print('✅ SADARI marked as completed for schedule ${active.id}');
        }

        return true;
      }

      return false;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error marking SADARI as completed: $e');
      }
      return false;
    }
  }
}
