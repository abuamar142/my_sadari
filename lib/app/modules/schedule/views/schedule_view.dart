import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../styles/app_colors.dart';
import '../../../styles/app_dimension.dart';
import '../../../styles/app_text_style.dart';
import '../../../widgets/app_dialog.dart';
import '../controllers/schedule_controller.dart';

class ScheduleView extends GetView<ScheduleController> {
  const ScheduleView({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.background2),
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
          centerTitle: true,
          actions: [
            // Debug Test button (only show in debug mode)
            if (kDebugMode)
              IconButton(
                onPressed: controller.showTestNotificationBottomSheet,
                icon: Icon(
                  Icons.bug_report,
                  color: AppColors.white.withValues(alpha: 0.8),
                ),
                tooltip: 'Test Notifikasi',
              ),
            _buildNotificationStatusIcon(),
            SizedBox(width: AppDimensions.paddingMedium),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.paddingLarge),
            child: Column(
              children: [
                SizedBox(height: AppDimensions.paddingSmall),

                // Summary Card
                _buildSummaryCard(),

                SizedBox(height: AppDimensions.paddingLarge),

                // Schedule List Card
                _buildScheduleListCard(),

                SizedBox(height: 100), // Extra space for FAB
              ],
            ),
          ),
        ),
        floatingActionButton: Container(
          margin: EdgeInsets.only(bottom: 16),
          child: FloatingActionButton.extended(
            onPressed: controller.showAddScheduleBottomSheet,
            backgroundColor: AppColors.purple1,
            elevation: 8,
            icon: Icon(Icons.add, color: AppColors.white, size: 20),
            label: Text('Tambah Jadwal', style: AppTextStyle.buttonText1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Obx(() {
        final activeSchedule = controller.activeSchedule;
        final isTodayReminder = controller.isTodayReminderDay;

        if (isTodayReminder) {
          return _buildTodayReminderContent();
        }

        if (activeSchedule != null) {
          final windowInfo = controller.getSadariWindowInfo(activeSchedule);

          if (windowInfo['isInWindow']) {
            return _buildActiveWindowContent(activeSchedule, windowInfo);
          } else {
            return _buildUpcomingWindowContent(activeSchedule, windowInfo);
          }
        }

        return _buildNoScheduleContent();
      }),
    );
  }

  Widget _buildScheduleListCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Filter Controls
          _buildScheduleHeader(),

          SizedBox(height: AppDimensions.paddingMedium),

          // Filter Controls
          _buildFilterControls(),

          SizedBox(height: AppDimensions.paddingMedium),

          // Schedule List
          Obx(() {
            if (controller.schedules.isEmpty) {
              return _buildEmptyScheduleList();
            }

            final groupedSchedules = _groupSchedulesByMonth();

            if (groupedSchedules.isEmpty) {
              return _buildNoFilteredSchedules();
            }

            return Column(
              children: [
                for (final entry in groupedSchedules.entries)
                  _buildMonthSection(entry.key, entry.value),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTodayReminderContent() {
    final activeSchedule = controller.activeSchedule;
    final isCompleted = activeSchedule?.isCompleted ?? false;

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: (isCompleted ? Colors.green : AppColors.purple1).withValues(
              alpha: 0.1,
            ),
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          ),
          child: Icon(
            isCompleted ? Icons.check_circle : Icons.notifications_active,
            size: 48,
            color: isCompleted ? Colors.green : AppColors.purple1,
          ),
        ),
        SizedBox(height: 16),
        Text(
          isCompleted ? 'SADARI Selesai!' : 'Waktunya SADARI!',
          style: AppTextStyle.headingMedium1.copyWith(
            color: AppColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          isCompleted
              ? 'Terima kasih! Anda telah menyelesaikan pemeriksaan SADARI untuk periode ini.'
              : 'Hari ini adalah waktu yang tepat untuk melakukan pemeriksaan SADARI.',
          style: AppTextStyle.bodyMedium1.copyWith(color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
        if (!isCompleted)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                controller.navigateToTutorial();
              },
              icon: Icon(Icons.play_arrow, color: AppColors.white),
              label: Text('Mulai SADARI', style: AppTextStyle.buttonText1),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.purple1,
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radiusMedium,
                  ),
                ),
              ),
            ),
          ),
        if (isCompleted)
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 20),
                SizedBox(width: 8),
                Text(
                  'Selesai pada ${controller.formatDate(activeSchedule!.completedAt!)}',
                  style: AppTextStyle.bodyMedium1.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildActiveWindowContent(
    dynamic schedule,
    Map<String, dynamic> windowInfo,
  ) {
    final isCompleted = schedule.isCompleted;

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: (isCompleted ? Colors.green : Colors.green).withValues(
              alpha: 0.1,
            ),
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          ),
          child: Icon(
            isCompleted ? Icons.check_circle : Icons.schedule,
            size: 48,
            color: isCompleted ? Colors.green : Colors.green,
          ),
        ),
        SizedBox(height: 16),
        Text(
          isCompleted ? 'SADARI Selesai!' : 'Periode SADARI Aktif',
          style: AppTextStyle.headingMedium1.copyWith(
            color: AppColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: (isCompleted ? Colors.green : Colors.green).withValues(
              alpha: 0.1,
            ),
            borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
          ),
          child: Text(
            'Periode: ${windowInfo['windowDays']}',
            style: AppTextStyle.bodyMedium1.copyWith(
              color: Colors.green[700],
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 12),
        Text(
          isCompleted
              ? 'Terima kasih! Anda telah menyelesaikan pemeriksaan SADARI untuk periode ini.'
              : 'Lakukan pemeriksaan SADARI dalam periode ini untuk kesehatan optimal.',
          style: AppTextStyle.bodyMedium1.copyWith(color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
        if (isCompleted) ...[
          SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 20),
                SizedBox(width: 8),
                Text(
                  'Selesai pada ${controller.formatDate(schedule.completedAt!)}',
                  style: AppTextStyle.bodyMedium1.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildUpcomingWindowContent(
    dynamic schedule,
    Map<String, dynamic> windowInfo,
  ) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          ),
          child: Icon(Icons.event_available, size: 48, color: Colors.orange),
        ),
        SizedBox(height: 16),
        Text(
          'SADARI Berikutnya',
          style: AppTextStyle.headingMedium1.copyWith(
            color: AppColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.purple1.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          ),
          child: Text(
            '${windowInfo['daysUntilStart']} hari lagi',
            style: AppTextStyle.headingLarge1.copyWith(
              color: AppColors.purple1,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 12),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.orange.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
          ),
          child: Text(
            'Periode: ${windowInfo['windowDays']}',
            style: AppTextStyle.bodyMedium1.copyWith(
              color: Colors.orange[700],
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Pengingat otomatis akan dikirim saat waktunya tiba.',
          style: AppTextStyle.bodyMedium1.copyWith(color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildNoScheduleContent() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.purple1.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          ),
          child: Icon(Icons.calendar_today, size: 48, color: AppColors.purple1),
        ),
        SizedBox(height: AppDimensions.paddingMedium),
        Text(
          'Belum Ada Jadwal',
          style: AppTextStyle.headingMedium1.copyWith(
            color: AppColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: AppDimensions.paddingSmall),
        Text(
          'Tambahkan jadwal SADARI untuk mendapatkan pengingat otomatis sesuai siklus menstruasi Anda.',
          style: AppTextStyle.bodyMedium1.copyWith(color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppDimensions.paddingLarge),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: controller.showAddScheduleBottomSheet,
            icon: Icon(Icons.add, color: AppColors.purple1),
            label: Text(
              'Tambah Jadwal SADARI',
              style: AppTextStyle.buttonText1.copyWith(
                color: AppColors.purple1,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.purple1),
              padding: EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyScheduleList() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingLarge),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.purple1.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.schedule, size: 48, color: AppColors.purple1),
          ),
          SizedBox(height: AppDimensions.paddingMedium),
          Text(
            'Belum ada riwayat jadwal',
            style: AppTextStyle.headingMedium1.copyWith(
              color: AppColors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppDimensions.paddingSmall),
          Text(
            'Jadwal SADARI yang Anda buat akan muncul di sini',
            style: AppTextStyle.bodyMedium1.copyWith(color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
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
    AppDialog.show(
      title: 'Notifikasi Aktif',
      headerIcon: Icons.notifications_active,
      headerColor: Colors.green,
      headerSecondaryColor: Colors.green.withValues(alpha: 0.8),
      content:
          'Pengingat SADARI telah diaktifkan dan akan dikirim sesuai jadwal.',
      customContent: Obx(() {
        final status = controller.notificationStatus;
        final scheduleMode = status['scheduleMode'] ?? 'Tidak Diketahui';
        final hasExactAlarm = status['hasExactAlarm'] ?? false;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pengingat SADARI telah diaktifkan dan akan dikirim sesuai jadwal.',
              textAlign: TextAlign.center,
              style: AppTextStyle.bodyMedium1.copyWith(
                color: AppColors.black,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 16),
            InfoBox(
              text: 'Waktu: 09:00 WIB',
              icon: Icons.schedule,
              color: AppColors.teal1,
            ),
            SizedBox(height: 8),
            InfoBox(
              text: 'Hari ke-7 s/d ke-10 setelah menstruasi',
              icon: Icons.calendar_today,
              color: AppColors.teal1,
            ),
            SizedBox(height: 8),
            InfoBox(
              text: 'Mode: $scheduleMode',
              icon: hasExactAlarm ? Icons.alarm : Icons.alarm_off,
              color: hasExactAlarm ? Colors.green : Colors.orange,
            ),
            if (!hasExactAlarm) ...[
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(AppDimensions.paddingMedium),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radiusSmall,
                  ),
                  border: Border.all(
                    color: Colors.orange.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Notifikasi mungkin tidak tepat waktu karena batasan sistem. Untuk pengingat yang lebih akurat, aktifkan izin alarm tepat waktu di pengaturan.',
                        style: AppTextStyle.bodySmall1.copyWith(
                          color: Colors.orange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        );
      }),
      actions: [
        if (controller.notificationStatus['hasExactAlarm'] == false)
          DialogAction(
            label: 'Pengaturan',
            type: DialogActionType.secondary,
            color: AppColors.purple1,
            onPressed: () {
              Get.back();
              controller.checkNotificationPermission();
            },
          ),
        DialogAction(
          label: 'Test Notifikasi',
          type: DialogActionType.primary,
          color: AppColors.purple1,
          onPressed: () {
            Get.back();
            controller.testNotification();
          },
        ),
      ],
      barrierDismissible: true,
    );
  }

  Widget _buildScheduleHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Riwayat Jadwal',
          style: AppTextStyle.headingMedium1.copyWith(
            color: AppColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.purple1.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
          ),
          child: Obx(
            () => Text(
              '${controller.schedules.length} jadwal',
              style: AppTextStyle.caption.copyWith(
                color: AppColors.purple1,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterControls() {
    return Obx(() {
      final availableYears = controller.availableYears;
      final availableMonths = controller.availableMonths;

      // Ensure selected values are valid
      final selectedYear =
          availableYears.contains(controller.selectedYear.value)
              ? controller.selectedYear.value
              : (availableYears.isNotEmpty
                  ? availableYears.first
                  : DateTime.now().year);

      final selectedMonth =
          availableMonths.contains(controller.selectedMonth.value)
              ? controller.selectedMonth.value
              : (availableMonths.isNotEmpty
                  ? availableMonths.first
                  : DateTime.now().month);

      return Row(
        children: [
          // Year Selector
          Expanded(
            child: GestureDetector(
              onTap: () => _showYearSelector(availableYears, selectedYear),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radiusSmall,
                  ),
                  color: Colors.grey.withValues(alpha: 0.05),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: AppColors.purple1,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        selectedYear.toString(),
                        style: AppTextStyle.bodyMedium1.copyWith(
                          color: AppColors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey[600],
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          // Month Selector
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () => _showMonthSelector(availableMonths, selectedMonth),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radiusSmall,
                  ),
                  color: Colors.grey.withValues(alpha: 0.05),
                ),
                child: Row(
                  children: [
                    Icon(Icons.event, color: AppColors.purple1, size: 18),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        controller.getMonthName(selectedMonth),
                        style: AppTextStyle.bodyMedium1.copyWith(
                          color: AppColors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey[600],
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Map<String, List<dynamic>> _groupSchedulesByMonth() {
    final filtered = controller.filteredSchedules;
    final Map<String, List<dynamic>> grouped = {};

    for (final schedule in filtered) {
      final monthYear =
          '${controller.getMonthName(schedule.menstruationStartDate.month)} ${schedule.menstruationStartDate.year}';

      if (!grouped.containsKey(monthYear)) {
        grouped[monthYear] = [];
      }
      grouped[monthYear]!.add(schedule);
    }

    return grouped;
  }

  Widget _buildNoFilteredSchedules() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.purple1.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.filter_list, size: 48, color: AppColors.purple1),
          ),
          SizedBox(height: AppDimensions.paddingMedium),
          Text(
            'Tidak ada jadwal',
            textAlign: TextAlign.center,
            style: AppTextStyle.headingMedium1.copyWith(
              color: AppColors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppDimensions.paddingSmall),
          Text(
            'Coba pilih bulan atau tahun yang berbeda',
            style: AppTextStyle.bodyMedium1.copyWith(color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMonthSection(String monthYear, List<dynamic> schedules) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Month Header
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          margin: EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppColors.purple1.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
          ),
          child: Row(
            children: [
              Icon(Icons.calendar_month, color: AppColors.purple1, size: 20),
              SizedBox(width: 8),
              Text(
                monthYear,
                style: AppTextStyle.headingMedium1.copyWith(
                  color: AppColors.purple1,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.purple1.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radiusSmall,
                  ),
                ),
                child: Text(
                  '${schedules.length} jadwal',
                  style: AppTextStyle.caption.copyWith(
                    color: AppColors.purple1,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Schedules in this month
        ...schedules.map((schedule) => _buildDetailedScheduleItem(schedule)),
        SizedBox(height: AppDimensions.paddingMedium),
      ],
    );
  }

  Widget _buildDetailedScheduleItem(dynamic schedule) {
    final windowInfo = controller.getSadariWindowInfo(schedule);
    final resultInfo = controller.getResultInfo(schedule.result);

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row with Status and Menu
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color:
                      schedule.isCompleted
                          ? Colors.green.withValues(alpha: 0.1)
                          : Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radiusSmall,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      schedule.isCompleted ? Icons.check_circle : Icons.pending,
                      size: 14,
                      color:
                          schedule.isCompleted ? Colors.green : Colors.orange,
                    ),
                    SizedBox(width: 4),
                    Text(
                      schedule.isCompleted ? 'Selesai' : 'Belum Selesai',
                      style: AppTextStyle.caption.copyWith(
                        color:
                            schedule.isCompleted ? Colors.green : Colors.orange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              PopupMenuButton(
                icon: Icon(Icons.more_vert, color: Colors.grey[600], size: 18),
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
                              style: AppTextStyle.bodyMedium1,
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
                            Text(
                              'Hapus',
                              style: AppTextStyle.bodyMedium1.copyWith(
                                color: Colors.red,
                              ),
                            ),
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

          SizedBox(height: AppDimensions.paddingMedium),

          // Schedule Details
          _buildScheduleDetailRow(
            'Tanggal Menstruasi',
            controller.formatDate(schedule.menstruationStartDate),
            Icons.event,
            AppColors.purple1,
          ),

          SizedBox(height: 8),

          _buildScheduleDetailRow(
            'Periode SADARI',
            windowInfo['windowDays'],
            Icons.schedule,
            Colors.blue,
          ),

          SizedBox(height: 8),

          // Result Row
          Row(
            children: [
              Icon(resultInfo['icon'], size: 16, color: resultInfo['color']),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hasil Pemeriksaan',
                      style: AppTextStyle.caption.copyWith(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      resultInfo['text'],
                      style: AppTextStyle.bodySmall1.copyWith(
                        color: resultInfo['color'],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (schedule.isCompleted) ...[
            SizedBox(height: 8),
            _buildScheduleDetailRow(
              'Tanggal Selesai',
              controller.formatDate(schedule.completedAt!),
              Icons.check_circle,
              Colors.green,
            ),
          ],

          if (schedule.notes != null && schedule.notes!.isNotEmpty) ...[
            SizedBox(height: AppDimensions.paddingSmall),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Catatan',
                    style: AppTextStyle.caption.copyWith(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    schedule.notes!,
                    style: AppTextStyle.caption.copyWith(
                      color: Colors.grey[700],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildScheduleDetailRow(
    String label,
    String value,
    IconData icon,
    Color iconColor,
  ) {
    return Row(
      children: [
        Icon(icon, size: 16, color: iconColor),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyle.caption.copyWith(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: AppTextStyle.bodySmall1.copyWith(
                  color: AppColors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showYearSelector(List<int> availableYears, int selectedYear) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppDimensions.radiusLarge),
            topRight: Radius.circular(AppDimensions.radiusLarge),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: EdgeInsets.all(AppDimensions.paddingLarge),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, color: AppColors.purple1),
                  SizedBox(width: 12),
                  Text(
                    'Pilih Tahun',
                    style: AppTextStyle.headingMedium1.copyWith(
                      color: AppColors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.close, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            // Year List
            Container(
              constraints: BoxConstraints(maxHeight: 300),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: availableYears.length,
                itemBuilder: (context, index) {
                  final year = availableYears[index];
                  final isSelected = year == selectedYear;

                  return ListTile(
                    leading: Icon(
                      Icons.date_range,
                      color: isSelected ? AppColors.purple1 : Colors.grey[600],
                    ),
                    title: Text(
                      year.toString(),
                      style: AppTextStyle.bodyMedium1.copyWith(
                        color: isSelected ? AppColors.purple1 : AppColors.black,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    trailing:
                        isSelected
                            ? Icon(Icons.check, color: AppColors.purple1)
                            : null,
                    onTap: () {
                      controller.updateSelectedYear(year);
                      Get.back();
                    },
                  );
                },
              ),
            ),
            SizedBox(height: AppDimensions.paddingLarge),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _showMonthSelector(List<int> availableMonths, int selectedMonth) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppDimensions.radiusLarge),
            topRight: Radius.circular(AppDimensions.radiusLarge),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: EdgeInsets.all(AppDimensions.paddingLarge),
              child: Row(
                children: [
                  Icon(Icons.event, color: AppColors.purple1),
                  SizedBox(width: 12),
                  Text(
                    'Pilih Bulan',
                    style: AppTextStyle.headingMedium1.copyWith(
                      color: AppColors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.close, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            // Month List
            Container(
              constraints: BoxConstraints(maxHeight: 400),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: availableMonths.length,
                itemBuilder: (context, index) {
                  final month = availableMonths[index];
                  final isSelected = month == selectedMonth;

                  return ListTile(
                    leading: Icon(
                      Icons.calendar_month,
                      color: isSelected ? AppColors.purple1 : Colors.grey[600],
                    ),
                    title: Text(
                      controller.getMonthName(month),
                      style: AppTextStyle.bodyMedium1.copyWith(
                        color: isSelected ? AppColors.purple1 : AppColors.black,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    trailing:
                        isSelected
                            ? Icon(Icons.check, color: AppColors.purple1)
                            : null,
                    onTap: () {
                      controller.updateSelectedMonth(month);
                      Get.back();
                    },
                  );
                },
              ),
            ),
            SizedBox(height: AppDimensions.paddingLarge),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
