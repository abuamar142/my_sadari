import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../styles/app_colors.dart';
import '../../../styles/app_text_style.dart';
import '../controllers/notification_controller.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue2,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Notifikasi', style: AppTextStyle.headingMedium2),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back, color: AppColors.white),
        ),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: [

        ],
      )
    );
  }


}
