import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_sadari/app/styles/app_text_style.dart';

import '../../../styles/app_colors.dart';
import '../../screening/controllers/screening_controller.dart';
import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  HistoryView({super.key});

  final screeningC =
      Get.isRegistered<ScreeningController>()
          ? Get.find<ScreeningController>()
          : Get.put(ScreeningController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue2,
      appBar: AppBar(
        title: Text(
          'Riwayat Skrining',
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.white),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back, color: AppColors.white),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        final allResults = controller.results;
        if (allResults.isEmpty) {
          return Center(child: Text('Belum ada riwayat.', style: AppTextStyle.bodyLarge2,));
        }
        final reversed = allResults.reversed.toList();
        return ListView.separated(
          padding: EdgeInsets.all(16),
          itemCount: reversed.length,
          separatorBuilder: (_, __) => Divider(color: AppColors.purple1),
          itemBuilder: (_, i) {
            final result = reversed[i];
            final timestamp = DateFormat(
              'd MMM yyyy – HH:mm',
              'id_ID',
            ).format(result.timestamp);
            Color badgeColor;
            if (result.riskLevel.contains('Anda Berisiko Terkena Kanker Payudara')) {
              badgeColor = AppColors.red;
            } else {
              badgeColor = AppColors.teal1;
            }

            return Dismissible(
              key: Key(result.timestamp.toIso8601String()),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(horizontal: 20),
                color: AppColors.red,
                child: Icon(Icons.delete, color: Colors.white),
              ),
              confirmDismiss: (_) async {
                return await showDialog<bool>(
                  context: context,
                  builder:
                      (_) => AlertDialog(
                        title: Text('Hapus Data'),
                        content: Text('Yakin ingin menghapus riwayat ini?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text('Batal'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text('Hapus'),
                          ),
                        ],
                      ),
                );
              },
              onDismissed: (_) {
                controller.deleteResult(result);
                Get.snackbar(
                  'Terhapus',
                  'Riwayat skrining telah dihapus.',
                  backgroundColor: AppColors.pink,
                  colorText: Colors.white,
                );
              },
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: badgeColor,
                  child: Icon(Icons.info_outline, color: AppColors.white),
                ),
                title: Text(timestamp, style: AppTextStyle.bodyMedium2),
                subtitle: Text(result.riskLevel, style: AppTextStyle.bodyLarge2),
                trailing: Icon(Icons.chevron_right, color: AppColors.white),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    ),

                    builder: (_) {
                      return Padding(
                        padding: EdgeInsets.only(
                          top: 16,
                          left: 16,
                          right: 16,
                          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                width: 40,
                                height: 4,
                                margin: EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                            Center(
                              child: Column(
                                children: [
                                  Text(
                                    'Detail Skrining',
                                    style: AppTextStyle.headingSmall1,
                                  ),
                                  SizedBox(height: 8),
                                  Text('Waktu: $timestamp'),
                                ],
                              ),
                            ),
                            SizedBox(height: 12),
                            SizedBox(
                              height: Get.height / 2,
                              child: ListView.separated(
                                itemCount: result.answers.length,
                                separatorBuilder: (_, __) => Divider(),
                                itemBuilder: (_, idx) {
                                  final q = screeningC.statements[idx];
                                  final ans = result.answers[idx] == 2 ? 'Ya' : 'Tidak';
                                  return ListTile(
                                    title: Text(q.text),
                                    trailing: Text(
                                      ans,
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => Get.back(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.purple3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                ),
                                child: Text(
                                  'Tutup',
                                  style: TextStyle(color: AppColors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            );
          },
        );
      }),
    );
  }
}
