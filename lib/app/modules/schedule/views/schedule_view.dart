import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../styles/app_colors.dart';
import '../../../styles/app_dimension.dart';
import '../../../styles/app_text_style.dart';
import '../controllers/schedule_controller.dart';

class ScheduleView extends GetView<ScheduleController> {
  const ScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.background1),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            'Jadwal SADARI',
            style: AppTextStyle.headingLarge1.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.white),
          actions: [
            // Debug/Test button (only show in debug mode)
            if (kDebugMode)
              IconButton(
                onPressed: controller.showTestNotificationBottomSheet,
                icon: Icon(
                  Icons.bug_report,
                  color: AppColors.white.withOpacity(0.8),
                ),
                tooltip: 'Test Notifikasi',
              ),
            _buildNotificationStatusIcon(),
            SizedBox(width: 16),
          ],
        ),
        body: Column(
          children: [
            // Summary Card
            _buildSummaryCard(),

            // Content
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppDimensions.radiusLarge),
                  ),
                ),
                child: _buildScheduleList(),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: controller.showAddScheduleBottomSheet,
          backgroundColor: AppColors.pink,
          child: Icon(Icons.add, color: AppColors.white),
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      margin: EdgeInsets.all(AppDimensions.paddingMedium),
      padding: EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Obx(() {
        final activeSchedule = controller.activeSchedule;
        final isTodayReminder = controller.isTodayReminderDay;

        if (isTodayReminder) {
          return _buildTodayReminderCard();
        }

        if (activeSchedule != null) {
          final windowInfo = controller.getSadariWindowInfo(activeSchedule);

          if (windowInfo['isInWindow']) {
            return _buildActiveWindowCard(activeSchedule, windowInfo);
          } else {
            return _buildUpcomingWindowCard(activeSchedule, windowInfo);
          }
        }

        return _buildNoScheduleCard();
      }),
    );
  }

  Widget _buildTodayReminderCard() {
    return Column(
      children: [
        Icon(Icons.notifications_active, size: 48, color: AppColors.pink),
        SizedBox(height: 12),
        Text(
          'Waktunya SADARI!',
          style: AppTextStyle.headingMedium1.copyWith(
            color: AppColors.pink,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Hari ini adalah waktu yang tepat untuk melakukan pemeriksaan SADARI.',
          style: AppTextStyle.bodyMedium1.copyWith(color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {
            // Navigate to SADARI tutorial or checklist
            Get.toNamed('/sadari-tutorial');
          },
          icon: Icon(Icons.play_arrow, color: AppColors.white),
          label: Text('Mulai SADARI', style: AppTextStyle.buttonText1),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.pink,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActiveWindowCard(schedule, windowInfo) {
    return Column(
      children: [
        Icon(Icons.schedule, size: 48, color: Colors.green),
        SizedBox(height: 12),
        Text(
          'Periode SADARI Aktif',
          style: AppTextStyle.headingMedium1.copyWith(
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Periode: ${windowInfo['windowDays']}',
          style: AppTextStyle.bodyMedium1.copyWith(color: Colors.grey[600]),
        ),
        SizedBox(height: 4),
        Text(
          'Lakukan pemeriksaan SADARI dalam periode ini.',
          style: AppTextStyle.bodySmall1.copyWith(color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildUpcomingWindowCard(schedule, windowInfo) {
    return Column(
      children: [
        Icon(Icons.event_available, size: 48, color: Colors.orange),
        SizedBox(height: 12),
        Text(
          'SADARI Berikutnya',
          style: AppTextStyle.headingMedium1.copyWith(
            color: Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          '${windowInfo['daysUntilStart']} hari lagi',
          style: AppTextStyle.headingLarge1.copyWith(
            color: AppColors.pink,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Periode: ${windowInfo['windowDays']}',
          style: AppTextStyle.bodyMedium1.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildNoScheduleCard() {
    return Column(
      children: [
        Icon(Icons.calendar_today, size: 48, color: Colors.grey[400]),
        SizedBox(height: 12),
        Text(
          'Belum Ada Jadwal',
          style: AppTextStyle.headingMedium1.copyWith(
            color: Colors.grey[600],
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Tambahkan jadwal SADARI untuk mendapatkan pengingat otomatis.',
          style: AppTextStyle.bodyMedium1.copyWith(color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: controller.showAddScheduleBottomSheet,
          icon: Icon(Icons.add, color: AppColors.pink),
          label: Text('Tambah Jadwal', style: TextStyle(color: AppColors.pink)),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: AppColors.pink),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleList() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Semua Jadwal',
            style: AppTextStyle.headingMedium1.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              final schedules = controller.schedules;
              if (schedules.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.event_note, size: 64, color: Colors.grey[300]),
                      SizedBox(height: 16),
                      Text(
                        'Belum ada jadwal SADARI',
                        style: AppTextStyle.bodyLarge1.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Tekan tombol + untuk menambah jadwal',
                        style: AppTextStyle.bodyMedium1.copyWith(
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                itemCount: schedules.length,
                separatorBuilder: (context, index) => SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final schedule = schedules[index];
                  return _buildScheduleListItem(schedule);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleListItem(schedule) {
    final statusColor = controller.getScheduleStatusColor(schedule);
    final statusText = controller.getScheduleStatusText(schedule);
    final windowInfo = controller.getSadariWindowInfo(schedule);

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Spacer(),
              PopupMenuButton(
                icon: Icon(Icons.more_vert, color: Colors.grey[600]),
                itemBuilder:
                    (context) => [
                      PopupMenuItem(
                        value: 'toggle',
                        child: Row(
                          children: [
                            Icon(
                              schedule.isActive
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              size: 16,
                            ),
                            SizedBox(width: 8),
                            Text(
                              schedule.isActive ? 'Nonaktifkan' : 'Aktifkan',
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 16, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Hapus', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                onSelected: (value) {
                  if (value == 'toggle') {
                    controller.toggleScheduleStatus(schedule);
                  } else if (value == 'delete') {
                    controller.deleteSchedule(schedule.id);
                  }
                },
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            'Menstruasi: ${controller.formatDate(schedule.menstruationStartDate)}',
            style: AppTextStyle.bodyLarge1.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'SADARI: ${windowInfo['windowDays']}',
            style: AppTextStyle.bodyMedium1.copyWith(color: Colors.grey[600]),
          ),
          if (schedule.notes != null && schedule.notes!.isNotEmpty) ...[
            SizedBox(height: 8),
            Text(
              schedule.notes!,
              style: AppTextStyle.bodySmall1.copyWith(
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNotificationStatusIcon() {
    return Obx(() {
      final status = controller.notificationStatus;
      if (status.isEmpty) {
        return Icon(
          Icons.notifications_none,
          color: AppColors.white.withValues(alpha: 0.7),
        );
      }

      final isEnabled = status['isEnabled'] ?? false;

      return GestureDetector(
        onTap: () {
          if (isEnabled) {
            // Show notification info or test
            _showNotificationInfoDialog();
          } else {
            // Request permission
            controller.checkNotificationPermission();
          }
        },
        child: Container(
          padding: EdgeInsets.all(4),
          child: Stack(
            children: [
              Icon(
                isEnabled
                    ? Icons.notifications_active
                    : Icons.notifications_off,
                color: AppColors.white,
                size: 26,
              ),
              if (!isEnabled)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }

  void _showNotificationInfoDialog() {
    Get.dialog(
      Obx(() {
        final status = controller.notificationStatus;
        final scheduleMode = status['scheduleMode'] ?? 'Tidak Diketahui';
        final hasExactAlarm = status['hasExactAlarm'] ?? false;

        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.notifications_active, color: Colors.green),
              SizedBox(width: 8),
              Text('Notifikasi Aktif'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pengingat SADARI telah diaktifkan dan akan dikirim sesuai jadwal.',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 8),
                  Text(
                    'Waktu: 09:00 WIB',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 8),
                  Text(
                    'Hari ke-7 s/d ke-10 setelah menstruasi',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    hasExactAlarm ? Icons.alarm : Icons.alarm_off,
                    size: 16,
                    color: hasExactAlarm ? Colors.green : Colors.orange,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Mode: $scheduleMode',
                      style: TextStyle(
                        color: hasExactAlarm ? Colors.green : Colors.orange,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              if (!hasExactAlarm) ...[
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'ℹ️ Notifikasi mungkin tidak tepat waktu karena batasan sistem. Untuk pengingat yang lebih akurat, aktifkan izin alarm tepat waktu di pengaturan.',
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(onPressed: () => Get.back(), child: Text('Tutup')),
            if (!hasExactAlarm)
              TextButton(
                onPressed: () {
                  Get.back();
                  controller.checkNotificationPermission();
                },
                child: Text('Pengaturan'),
              ),
            ElevatedButton(
              onPressed: () {
                Get.back();
                controller.testNotification();
              },
              child: Text('Test Notifikasi'),
            ),
          ],
        );
      }),
    );
  }
}
